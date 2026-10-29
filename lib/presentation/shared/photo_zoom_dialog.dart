import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../core/theme/retro_decorations.dart';

/// Full-screen dialog with InteractiveViewer for inspecting botanical details (gills, ring, volva, pores).
class PhotoZoomDialog extends StatelessWidget {
  final Uint8List? imageBytes;
  final String? assetPath;
  final String title;
  final String? subtitle;
  final String? attribution;

  const PhotoZoomDialog({
    super.key,
    this.imageBytes,
    this.assetPath,
    required this.title,
    this.subtitle,
    this.attribution,
  }) : assert(imageBytes != null || assetPath != null);

  static Future<void> show({
    required BuildContext context,
    Uint8List? imageBytes,
    String? assetPath,
    required String title,
    String? subtitle,
    String? attribution,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) => PhotoZoomDialog(
        imageBytes: imageBytes,
        assetPath: assetPath,
        title: title,
        subtitle: subtitle,
        attribution: attribution,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: RetroColors.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border.all(color: RetroColors.ink, width: 2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: RetroColors.ink,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: RetroColors.inkSoft,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: RetroColors.ink),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Tancar',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Zoomable image container
          Flexible(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                border: Border(
                  left: BorderSide(color: RetroColors.ink, width: 2),
                  right: BorderSide(color: RetroColors.ink, width: 2),
                ),
              ),
              child: ClipRect(
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 5.0,
                  child: Center(
                    child: imageBytes != null
                        ? Image.memory(
                            imageBytes!,
                            fit: BoxFit.contain,
                            errorBuilder: (ctx, err, st) => const Icon(
                              Icons.broken_image_rounded,
                              size: 48,
                              color: Colors.white54,
                            ),
                          )
                        : Image.asset(
                            assetPath!,
                            fit: BoxFit.contain,
                            errorBuilder: (ctx, err, st) => const Icon(
                              Icons.broken_image_rounded,
                              size: 48,
                              color: Colors.white54,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),

          // Footer bar with gesture hint and attribution
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: RetroColors.surface,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(16)),
              border: Border.all(color: RetroColors.ink, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    Icon(Icons.pinch_rounded,
                        size: 14, color: RetroColors.inkSoft),
                    SizedBox(width: 6),
                    Text(
                      'Pessiga per fer zoom i examinar els detalls botànics',
                      style: TextStyle(
                        fontSize: 11,
                        color: RetroColors.inkSoft,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (attribution != null && attribution!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    attribution!,
                    style: const TextStyle(
                      fontSize: 10,
                      color: RetroColors.inkFaint,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
