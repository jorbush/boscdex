import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  int _selectedModeIndex = 0; // 0 = Bolets, 1 = Arbres
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _performScan() async {
    if (_isScanning) return;

    setState(() => _isScanning = true);
    unawaited(_animController.repeat(reverse: true));

    try {
      final dummyBytes = Uint8List(0);
      final classifier = ref.read(classifierProvider);

      if (_selectedModeIndex == 0) {
        final results = await classifier.classify(dummyBytes);

        if (!mounted) return;
        _animController.stop();
        setState(() => _isScanning = false);

        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => ClassificationResultSheet(
            results: results,
            imageBytes: dummyBytes,
          ),
        );
      } else {
        final results = await classifier.classifyTree(dummyBytes);

        if (!mounted) return;
        _animController.stop();
        setState(() => _isScanning = false);

        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => TreeClassificationResultSheet(
            results: results,
            imageBytes: dummyBytes,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _animController.stop();
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
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              _selectedModeIndex == 0
                                  ? Icons.filter_center_focus_rounded
                                  : Icons.park_rounded,
                              size: 100,
                              color: _isScanning
                                  ? RetroColors.forestGreen.withOpacity(0.6)
                                  : RetroColors.forestGreen.withOpacity(0.28),
                            ),
                            if (_isScanning) ...[
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
                      onTap: () {
                        if (!_isScanning) {
                          HapticFeedback.lightImpact();
                          _performScan();
                        }
                      },
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: RetroColors.ink, width: 2.2),
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
                      onTap: () {
                        if (!_isScanning) {
                          HapticFeedback.mediumImpact();
                          _performScan();
                        }
                      },
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

  Widget _buildModeButton(int index, String text) {
    final isSelected = _selectedModeIndex == index;
    return Semantics(
      button: true,
      selected: isSelected,
      label: text,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
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
