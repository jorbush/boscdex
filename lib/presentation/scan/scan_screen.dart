import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/theme/retro_decorations.dart';
import '../../providers/classifier_provider.dart';
import 'classification_result_sheet.dart';
import 'tree_classification_result_sheet.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late AnimationController _animController;
  int _selectedModeIndex = 0; // 0 = Bolets, 1 = Arbres
  bool _isScanning = false;

  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isCameraLoading = true;
  bool _hasCameraPermission = false;
  bool _isPermissionPermanentlyDenied = false;
  String? _cameraErrorMessage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cameraController = _cameraController;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
      _cameraController = null;
      if (mounted) {
        setState(() {
          _isCameraInitialized = false;
        });
      }
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    if (!mounted) return;
    setState(() {
      _isCameraLoading = true;
      _cameraErrorMessage = null;
    });

    try {
      // 1. Check and request camera permission via permission_handler
      var status = await Permission.camera.status;
      if (!status.isGranted) {
        status = await Permission.camera.request();
      }

      if (!mounted) return;

      if (status.isPermanentlyDenied) {
        setState(() {
          _isCameraLoading = false;
          _hasCameraPermission = false;
          _isPermissionPermanentlyDenied = true;
        });
        return;
      }

      if (!status.isGranted) {
        setState(() {
          _isCameraLoading = false;
          _hasCameraPermission = false;
          _isPermissionPermanentlyDenied = false;
        });
        return;
      }

      _hasCameraPermission = true;
      _isPermissionPermanentlyDenied = false;

      // 2. Discover available cameras on the device
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (!mounted) return;
        setState(() {
          _isCameraLoading = false;
          _cameraErrorMessage = 'No s\'ha detectat cap càmera al dispositiu.';
        });
        return;
      }

      // 3. Prefer back camera for scanning wild mushrooms/trees
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup:
            Platform.isIOS ? ImageFormatGroup.bgra8888 : ImageFormatGroup.jpeg,
      );

      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _cameraController = controller;
        _isCameraInitialized = true;
        _isCameraLoading = false;
      });
    } on CameraException catch (e) {
      if (!mounted) return;
      final isPermissionError = e.code == 'CameraAccessDenied' ||
          e.code == 'CameraAccessDeniedWithoutPrompt' ||
          e.code == 'CameraAccessRestricted';
      setState(() {
        _isCameraLoading = false;
        _hasCameraPermission = !isPermissionError;
        _isPermissionPermanentlyDenied = isPermissionError;
        _cameraErrorMessage = isPermissionError
            ? null
            : 'Error en la càmera (${e.code}): ${e.description}';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isCameraLoading = false;
        _cameraErrorMessage = 'Error en inicialitzar la càmera: $e';
      });
    }
  }

  Future<void> _onShutterTapped() async {
    if (_isScanning) return;
    unawaited(HapticFeedback.mediumImpact());

    Uint8List? imageBytes;

    if (_isCameraInitialized && _cameraController != null) {
      try {
        final file = await _cameraController!.takePicture();
        imageBytes = await file.readAsBytes();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error en capturar la foto: $e'),
              backgroundColor: RetroColors.arcadeRed,
            ),
          );
        }
        return;
      }
    } else {
      // If camera is not available (e.g. simulator), fallback to dummy sample bytes
      imageBytes = Uint8List(0);
    }

    await _processClassification(imageBytes);
  }

  Future<void> _onGalleryTapped() async {
    if (_isScanning) return;
    unawaited(HapticFeedback.lightImpact());

    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (pickedFile == null) return; // User canceled gallery selection

      final bytes = await pickedFile.readAsBytes();
      await _processClassification(bytes);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error en carregar la imatge de la galeria: $e'),
            backgroundColor: RetroColors.arcadeRed,
          ),
        );
      }
    }
  }

  Future<void> _processClassification(Uint8List imageBytes) async {
    if (_isScanning) return;

    setState(() => _isScanning = true);
    unawaited(_animController.repeat(reverse: true));

    try {
      final classifier = ref.read(classifierProvider);

      if (_selectedModeIndex == 0) {
        final results = await classifier.classify(imageBytes);

        if (!mounted) return;
        _animController.stop();
        _animController.reset();
        setState(() => _isScanning = false);

        if (results.isNotEmpty) {
          unawaited(showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => ClassificationResultSheet(
              results: results,
              imageBytes: imageBytes.isNotEmpty ? imageBytes : null,
            ),
          ));
        }
      } else {
        final results = await classifier.classifyTree(imageBytes);

        if (!mounted) return;
        _animController.stop();
        _animController.reset();
        setState(() => _isScanning = false);

        if (results.isNotEmpty) {
          unawaited(showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => TreeClassificationResultSheet(
              results: results,
              imageBytes: imageBytes.isNotEmpty ? imageBytes : null,
            ),
          ));
        }
      }
    } catch (e) {
      if (mounted) {
        _animController.stop();
        _animController.reset();
        setState(() => _isScanning = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error durant l\'anàlisi: $e'),
            backgroundColor: RetroColors.arcadeRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RetroColors.creamBg,
      body: Stack(
        children: [
          // Viewfinder Center Area
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) {
                    final scale = _isScanning
                        ? 1.0 + (_animController.value * 0.05)
                        : 1.0;
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 270,
                        height: 270,
                        decoration: BoxDecoration(
                          color: RetroColors.sectionBg,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: _isScanning
                                ? RetroColors.forestGreen
                                : RetroColors.ink,
                            width: _isScanning ? 3 : 2.5,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: RetroColors.ink,
                              offset: Offset(3, 4),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(21),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // 1. Live Camera Preview or fallback state
                              if (_isCameraInitialized &&
                                  _cameraController != null)
                                SizedBox.expand(
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: SizedBox(
                                      width: _cameraController!
                                              .value.previewSize?.height ??
                                          270,
                                      height: _cameraController!
                                              .value.previewSize?.width ??
                                          270,
                                      child: CameraPreview(_cameraController!),
                                    ),
                                  ),
                                )
                              else if (_isCameraLoading)
                                Container(
                                  color: RetroColors.sectionBg,
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        CircularProgressIndicator(
                                          color: RetroColors.forestGreen,
                                          strokeWidth: 3,
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          'Iniciant càmera...',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: RetroColors.inkSoft,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else if (!_hasCameraPermission)
                                _buildPermissionDeniedView()
                              else
                                _buildNoCameraView(),

                              // 2. Retro targeting brackets & reticle overlay
                              _buildReticleOverlay(),

                              // 3. Scanning Animation Overlay
                              if (_isScanning) ...[
                                Positioned(
                                  top: _animController.value * 230,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: RetroColors.mintGlow,
                                      boxShadow: [
                                        BoxShadow(
                                          color: RetroColors.mintGlow
                                              .withOpacity(0.8),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 16,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: RetroColors.forestGreen,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: RetroColors.ink, width: 2),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: RetroColors.ink,
                                          offset: Offset(2, 2),
                                          blurRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      'ANALITZANT AMB EDGE-AI...',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Viewfinder Targeting Instructions (Retro prompt banner)
          Positioned(
            top: MediaQuery.of(context).padding.top + 76,
            left: 24,
            right: 24,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: RetroColors.ink, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: RetroColors.ink,
                      offset: Offset(2, 2),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Text(
                  _selectedModeIndex == 0
                      ? 'Enfoca el barret i les làmines del bolet'
                      : 'Enfoca l\'escorça o les fulles de l\'arbre',
                  style: const TextStyle(
                    color: RetroColors.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          // Mode Switcher (Bolets | Arbres) styled like arcade console toggle
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2EBE2),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: RetroColors.ink, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: RetroColors.ink,
                      offset: Offset(0, 2),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildModeButton(0, 'Bolets'),
                    _buildModeButton(1, 'Arbres'),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(
                  bottom: 36, top: 24, left: 28, right: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Gallery picker button (retro cartridge icon)
                  Semantics(
                    button: true,
                    label: 'Obrir galeria de fotos',
                    child: GestureDetector(
                      key: const Key('gallery_picker_button'),
                      onTap: _onGalleryTapped,
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border:
                              Border.all(color: RetroColors.ink, width: 2.2),
                          boxShadow: const [
                            BoxShadow(
                              color: RetroColors.ink,
                              offset: Offset(0, 3),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.photo_library_rounded,
                            color: RetroColors.ink,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Shutter button (3D arcade cabinet lens button)
                  Semantics(
                    button: true,
                    label: _selectedModeIndex == 0
                        ? 'Fotografiar i identificar bolet'
                        : 'Fotografiar i identificar arbre',
                    child: GestureDetector(
                      key: const Key('shutter_button'),
                      onTap: _onShutterTapped,
                      child: Container(
                        width: 82,
                        height: 82,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: RetroColors.forestGreen,
                          border: Border.all(color: RetroColors.ink, width: 3),
                          boxShadow: const [
                            BoxShadow(
                              color: RetroColors.ink,
                              offset: Offset(0, 4),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isScanning
                              ? const SizedBox(
                                  width: 34,
                                  height: 34,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Container(
                                  width: 62,
                                  height: 62,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                      color: RetroColors.ink,
                                      width: 1.8,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.camera_alt_rounded,
                                      color: RetroColors.forestGreen,
                                      size: 28,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 52), // Balance for left icon
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionDeniedView() {
    return Container(
      color: RetroColors.sectionBg,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.no_photography_rounded,
            size: 44,
            color: RetroColors.arcadeRed,
          ),
          const SizedBox(height: 8),
          const Text(
            'Permís de càmera necessari',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: RetroColors.ink,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _isPermissionPermanentlyDenied
                ? 'Activa el permís des dels Paràmetres del teu iPhone per escanejar.'
                : 'Boscdex necessita la càmera per identificar bolets al bosc.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: RetroColors.inkSoft,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              if (_isPermissionPermanentlyDenied) {
                unawaited(openAppSettings());
              } else {
                _initCamera();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: RetroColors.forestGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: RetroColors.ink, width: 1.5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            ),
            child: Text(
              _isPermissionPermanentlyDenied
                  ? 'Obrir Paràmetres'
                  : 'Demanar permís',
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoCameraView() {
    return Container(
      color: RetroColors.sectionBg,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _selectedModeIndex == 0
                ? Icons.filter_center_focus_rounded
                : Icons.park_rounded,
            size: 54,
            color: RetroColors.forestGreen.withOpacity(0.5),
          ),
          const SizedBox(height: 10),
          Text(
            _cameraErrorMessage ?? 'Càmera no detectada',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: RetroColors.ink,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Fes servir la Galeria o prem Disparador per provar la identificació.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: RetroColors.inkSoft,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReticleOverlay() {
    return IgnorePointer(
      child: Stack(
        children: [
          // Center focus reticle
          Center(
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.6),
                  width: 1.5,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          // 4 Corner Brackets
          Positioned(
            top: 14,
            left: 14,
            child: _buildCornerBracket(isTop: true, isLeft: true),
          ),
          Positioned(
            top: 14,
            right: 14,
            child: _buildCornerBracket(isTop: true, isLeft: false),
          ),
          Positioned(
            bottom: 14,
            left: 14,
            child: _buildCornerBracket(isTop: false, isLeft: true),
          ),
          Positioned(
            bottom: 14,
            right: 14,
            child: _buildCornerBracket(isTop: false, isLeft: false),
          ),
        ],
      ),
    );
  }

  Widget _buildCornerBracket({required bool isTop, required bool isLeft}) {
    const double size = 18;
    const double thickness = 3;
    const color = Colors.white;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CornerBracketPainter(
          isTop: isTop,
          isLeft: isLeft,
          thickness: thickness,
          color: color,
        ),
      ),
    );
  }

  Widget _buildModeButton(int index, String text) {
    final isSelected = _selectedModeIndex == index;
    return Semantics(
      button: true,
      selected: isSelected,
      label: text,
      child: GestureDetector(
        onTap: () {
          unawaited(HapticFeedback.selectionClick());
          setState(() {
            _selectedModeIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? RetroColors.forestGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : RetroColors.inkSoft,
              fontWeight: FontWeight.w900,
              fontSize: 13,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

class _CornerBracketPainter extends CustomPainter {
  final bool isTop;
  final bool isLeft;
  final double thickness;
  final Color color;

  _CornerBracketPainter({
    required this.isTop,
    required this.isLeft,
    required this.thickness,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (isTop && isLeft) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else if (isTop && !isLeft) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (!isTop && isLeft) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CornerBracketPainter oldDelegate) => false;
}
