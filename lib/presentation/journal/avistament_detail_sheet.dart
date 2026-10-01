import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/retro_decorations.dart';
import '../../data/database/app_database.dart';
import '../../domain/models/edibilitat.dart';
import '../../domain/services/photo_export_service.dart';
import '../../providers/database_provider.dart';
import '../boscdex/boscdex_provider.dart';
import '../shared/edibility_badge.dart';

/// Modal bottom sheet or screen displaying the full details of a user's scanned sighting:
/// original photograph, neural confidence coincidence %, date, field notes, and export tools.
class AvistamentDetailSheet extends ConsumerStatefulWidget {
  final Avistament avistament;
  final VoidCallback? onDeleted;
  final PhotoExportService photoExportService;

  const AvistamentDetailSheet({
    Key? key,
    required this.avistament,
    this.onDeleted,
    this.photoExportService = const PhotoExportService(),
  }) : super(key: key);

  static Future<void> show(
    BuildContext context,
    Avistament avistament, {
    VoidCallback? onDeleted,
    PhotoExportService photoExportService = const PhotoExportService(),
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AvistamentDetailSheet(
        avistament: avistament,
        onDeleted: onDeleted,
        photoExportService: photoExportService,
      ),
    );
  }

  @override
  ConsumerState<AvistamentDetailSheet> createState() =>
      _AvistamentDetailSheetState();
}

class _AvistamentDetailSheetState extends ConsumerState<AvistamentDetailSheet> {
  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  PhotoExportService get _photoExportService => widget.photoExportService;

  Bolet? _bolet;
  Arbre? _arbre;
  bool _isExporting = false;

  bool get _isTree => widget.avistament.arbreId != null;

  @override
  void initState() {
    super.initState();
    _loadEntity();
  }

  Future<void> _loadEntity() async {
    final db = ref.read(appDatabaseProvider);
    if (widget.avistament.arbreId != null) {
      final arbre = await db.arbreDao.getArbreById(widget.avistament.arbreId!);
      if (mounted) {
        setState(() {
          _arbre = arbre;
        });
      }
    } else if (widget.avistament.boletId != null) {
      final bolet = await db.boletDao.getBoletById(widget.avistament.boletId!);
      if (mounted) {
        setState(() {
          _bolet = bolet;
        });
      }
    }
  }

  Future<void> _downloadPhoto() async {
    if (_isExporting) return;
    final photoPath = widget.avistament.photoPath;
    if (photoPath == null || photoPath.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hi ha cap fitxer de foto per descarregar.'),
          backgroundColor: RetroColors.arcadeRed,
        ),
      );
      return;
    }
    final file = await PhotoExportService.resolveFileAsync(photoPath);
    if (!await file.exists()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hi ha cap fitxer de foto per descarregar.'),
          backgroundColor: RetroColors.arcadeRed,
        ),
      );
      return;
    }

    setState(() => _isExporting = true);
    unawaited(HapticFeedback.lightImpact());

    final result = await _photoExportService.saveToGallery(file.path);

    if (mounted) {
      setState(() => _isExporting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor:
              result.success ? RetroColors.forestGreen : RetroColors.arcadeRed,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _sharePhoto([BuildContext? buttonContext]) async {
    final photoPath = widget.avistament.photoPath;
    if (photoPath == null || photoPath.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hi ha cap fitxer de foto per compartir.'),
          backgroundColor: RetroColors.arcadeRed,
        ),
      );
      return;
    }

    // Calculate anchor bounding box synchronously before async operations
    // for iOS iPad popover and newer iPhone presentation
    Rect? sharePositionOrigin;
    final targetContext = buttonContext ?? context;
    final box = targetContext.findRenderObject() as RenderBox?;
    if (box != null &&
        box.hasSize &&
        box.size.width > 0 &&
        box.size.height > 0) {
      sharePositionOrigin = box.localToGlobal(Offset.zero) & box.size;
    } else {
      final size = MediaQuery.of(context).size;
      sharePositionOrigin = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: 44,
        height: 44,
      );
    }

    final file = await PhotoExportService.resolveFileAsync(photoPath);
    if (!await file.exists()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No s\'ha trobat la imatge al dispositiu.'),
            backgroundColor: RetroColors.arcadeRed,
          ),
        );
      }
      return;
    }

    unawaited(HapticFeedback.selectionClick());
    final name = _isTree
        ? (_arbre?.catalanName ?? widget.avistament.arbreId ?? 'Arbre')
        : (_bolet?.catalanName ?? widget.avistament.boletId ?? 'Bolet');
    final icon = _isTree ? '🌲' : '🍄';

    final success = await _photoExportService.sharePhoto(
      file.path,
      text: 'Mireu aquest exemplar de $name identificat amb Boscdex AI $icon',
      subject: 'Boscdex - Identificació de $name',
      sharePositionOrigin: sharePositionOrigin,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No s\'ha pogut obrir el menú per compartir.'),
          backgroundColor: RetroColors.arcadeRed,
        ),
      );
    }
  }

  Future<void> _confirmDelete() async {
    unawaited(HapticFeedback.mediumImpact());
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: RetroColors.ink, width: 2.5),
        ),
        title: const Text(
          'Eliminar avistament?',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: RetroColors.ink,
          ),
        ),
        content: const Text(
          'Aquesta acció eliminarà el registre del teu diari i la fotografia del dispositiu.',
          style: TextStyle(
            color: RetroColors.inkSoft,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: const Text(
              'Cancel·lar',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: RetroColors.inkSoft,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: RetroColors.arcadeRed,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: RetroColors.ink, width: 1.5),
              ),
            ),
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            child: const Text(
              'Eliminar',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final db = ref.read(appDatabaseProvider);
      await _photoExportService.deleteSighting(db, widget.avistament.id);
      ref.invalidate(boscdexEntriesProvider);

      if (mounted) {
        Navigator.of(context).pop();
        widget.onDeleted?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Avistament eliminat del teu diari.'),
            backgroundColor: RetroColors.ink,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoPath = widget.avistament.photoPath;
    final hasPhoto = photoPath != null && photoPath.isNotEmpty;
    final confidence = widget.avistament.confidenceScore ?? 0.0;
    final confidencePct = (confidence * 100).toInt();
    final isHighConfidence = confidence >= 0.70;

    final displayName = _isTree
        ? (_arbre?.catalanName ??
            widget.avistament.arbreId ??
            'Arbre indicador')
        : (_bolet?.catalanName ?? widget.avistament.boletId ?? 'Bolet');
    final scientificName = _isTree
        ? (_arbre?.scientificName ?? '')
        : (_bolet?.scientificName ?? '');
    final edibilitat = _bolet != null
        ? EdibilitatExtension.fromString(_bolet!.edibility)
        : null;

    final mediaQuery = MediaQuery.of(context);
    // Sheet opens comfortably below the iOS top status bar (hours, wifi, notch)
    final sheetHeight = mediaQuery.size.height * 0.78;

    return SafeArea(
      top: true,
      bottom: false,
      child: Container(
        constraints: BoxConstraints(maxHeight: sheetHeight),
        decoration: BoxDecoration(
          color: RetroColors.creamBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: RetroColors.ink, width: 3),
        ),
        child: Column(
          children: [
            // Centered Drag handle pill
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: RetroColors.ink.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),

            // Header bar (Clean, centered title without X button)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: RetroColors.forestGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'DETALL DE L\'AVISTAMENT',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: RetroColors.forestGreen,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: RetroColors.ink, height: 1, thickness: 1.5),

            // Scrollable content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Scanned Photograph Preview
                  Container(
                    height: 280,
                    width: double.infinity,
                    decoration: RetroDecorations.card(
                      backgroundColor: Colors.black,
                      borderColor: RetroColors.ink,
                      borderWidth: 2.5,
                      shadowOffset: 4,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (hasPhoto)
                          InteractiveViewer(
                            clipBehavior: Clip.antiAlias,
                            minScale: 1.0,
                            maxScale: 3.5,
                            child: Image.file(
                              PhotoExportService.resolveFile(photoPath),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                child: Text(
                                  'Error en carregar la imatge',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                            ),
                          )
                        else
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_isTree)
                                  Image.asset(
                                    'assets/images/trees/${widget.avistament.arbreId}.png',
                                    width: 96,
                                    height: 96,
                                    filterQuality: FilterQuality.none,
                                    errorBuilder: (ctx, err, st) => const Text(
                                      '🌲',
                                      style: TextStyle(fontSize: 64),
                                    ),
                                  )
                                else
                                  Image.asset(
                                    'assets/images/mushrooms/${widget.avistament.boletId}.png',
                                    width: 96,
                                    height: 96,
                                    filterQuality: FilterQuality.none,
                                    errorBuilder: (ctx, err, st) => const Text(
                                      '🍄',
                                      style: TextStyle(fontSize: 64),
                                    ),
                                  ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Sense fotografia adjunta',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Overlay badge: Scan tag
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: RetroColors.ink.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: Colors.white24, width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.camera_alt_rounded,
                                    color: RetroColors.goldCoin, size: 14),
                                SizedBox(width: 5),
                                Text(
                                  'Captura de Camp',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 11.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Neural Confidence Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: RetroDecorations.card(
                      backgroundColor: Colors.white,
                      borderColor: RetroColors.ink,
                      borderWidth: 2,
                      shadowOffset: 3,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isHighConfidence
                                      ? Icons.verified_rounded
                                      : Icons.warning_amber_rounded,
                                  size: 18,
                                  color: isHighConfidence
                                      ? RetroColors.forestGreen
                                      : RetroColors.goldCoin,
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Coincidència Neural AI',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: RetroColors.ink,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: isHighConfidence
                                    ? RetroColors.forestGreen.withOpacity(0.12)
                                    : RetroColors.goldCoin.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isHighConfidence
                                      ? RetroColors.forestGreen
                                      : RetroColors.ink,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                '$confidencePct%',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                  color: isHighConfidence
                                      ? RetroColors.forestGreen
                                      : RetroColors.ink,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: confidence.clamp(0.0, 1.0),
                            minHeight: 10,
                            backgroundColor: RetroColors.sectionBg,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isHighConfidence
                                  ? RetroColors.forestGreen
                                  : RetroColors.goldCoin,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isHighConfidence
                              ? '✅ Alta concordança morfològica amb els patrons del model (Series 011).'
                              : '⚠️ Coincidència moderada. Verifica sempre l\'himeni (làmines/tubs) i la base del peu.',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: RetroColors.inkSoft,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Species Identification Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: RetroDecorations.card(
                      backgroundColor: Colors.white,
                      borderColor: RetroColors.ink,
                      borderWidth: 2,
                      shadowOffset: 3,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: RetroColors.ink,
                                    ),
                                  ),
                                  if (scientificName.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      scientificName,
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w600,
                                        color: RetroColors.inkSoft,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (_isTree)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color:
                                      RetroColors.forestGreen.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: RetroColors.forestGreen,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.park_rounded,
                                      size: 14,
                                      color: RetroColors.forestGreen,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _arbre?.leafType ?? 'Arbre',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w900,
                                        color: RetroColors.forestGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else if (edibilitat != null)
                              EdibilityBadge(edibilitat: edibilitat),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: RetroColors.surfaceLight,
                              foregroundColor: RetroColors.ink,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                    color: RetroColors.ink, width: 2),
                              ),
                            ),
                            icon: Icon(
                              _isTree
                                  ? Icons.park_rounded
                                  : Icons.menu_book_rounded,
                              size: 18,
                              color: RetroColors.forestGreen,
                            ),
                            label: Text(
                              _isTree
                                  ? 'Veure fitxa completa de l\'arbre'
                                  : 'Veure fitxa completa a la Boscdex',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                              ),
                            ),
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              Navigator.of(context).pop();
                              if (_isTree) {
                                context.push(
                                    '/arbre/${widget.avistament.arbreId}');
                              } else {
                                context.push(
                                    '/boscdex/${widget.avistament.boletId}');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Expedition & Field Metadata Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: RetroDecorations.card(
                      backgroundColor: Colors.white,
                      borderColor: RetroColors.ink,
                      borderWidth: 2,
                      shadowOffset: 3,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dades de l\'expedició',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: RetroColors.ink,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.event_rounded,
                                size: 16, color: RetroColors.forestGreen),
                            const SizedBox(width: 8),
                            Text(
                              _dateFormat.format(widget.avistament.timestamp),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: RetroColors.ink,
                              ),
                            ),
                          ],
                        ),
                        if (widget.avistament.altitude != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.terrain_rounded,
                                  size: 16, color: RetroColors.forestGreen),
                              const SizedBox(width: 8),
                              Text(
                                '${widget.avistament.altitude!.toInt()} m sobre el nivell del mar',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: RetroColors.ink,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (widget.avistament.notes != null &&
                            widget.avistament.notes!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.notes_rounded,
                                  size: 16, color: RetroColors.forestGreen),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.avistament.notes!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: RetroColors.inkSoft,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Download, Share & Delete Actions Row
                  Row(
                    children: [
                      // Download to Gallery button
                      Expanded(
                        flex: 3,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: RetroColors.forestGreen,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                  color: RetroColors.ink, width: 2),
                            ),
                          ),
                          icon: _isExporting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.download_rounded, size: 20),
                          label: Text(
                            _isExporting ? 'Desant...' : 'Descarregar Foto',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 13.5,
                            ),
                          ),
                          onPressed:
                              hasPhoto && !_isExporting ? _downloadPhoto : null,
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Native Share button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: RetroColors.ink, width: 2),
                        ),
                        child: Builder(
                          builder: (btnContext) {
                            return IconButton(
                              icon: const Icon(Icons.share_rounded,
                                  color: RetroColors.ink),
                              tooltip: 'Compartir',
                              onPressed: hasPhoto
                                  ? () => _sharePhoto(btnContext)
                                  : null,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Delete sighting button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: RetroColors.ink, width: 2),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete_outline_rounded,
                              color: RetroColors.arcadeRed),
                          tooltip: 'Eliminar avistament',
                          onPressed: _confirmDelete,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
