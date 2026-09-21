import 'package:flutter/material.dart';
import '../../core/theme/retro_decorations.dart';

class MorphologySection extends StatelessWidget {
  const MorphologySection({
    super.key,
    required this.cap,
    required this.gills,
    required this.stem,
    this.latex,
  });

  final String cap;
  final String gills;
  final String stem;
  final String? latex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: RetroDecorations.card(
        backgroundColor: Colors.white,
        borderColor: RetroColors.ink,
        borderWidth: 2,
        shadowOffset: 3,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          iconColor: RetroColors.forestGreen,
          collapsedIconColor: RetroColors.inkSoft,
          title: const Text(
            'Morfologia',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: RetroColors.ink,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMorphologyItem(
                      context, 'Barret', Icons.panorama_horizontal, cap),
                  const SizedBox(height: 12),
                  _buildMorphologyItem(
                      context, 'Làmines', Icons.format_align_justify, gills),
                  const SizedBox(height: 12),
                  _buildMorphologyItem(
                      context, 'Peu', Icons.vertical_align_bottom, stem),
                  if (latex != null && latex!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildMorphologyItem(
                        context, 'Làtex', Icons.water_drop, latex!),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMorphologyItem(
      BuildContext context, String title, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD4DFD2), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: RetroColors.forestGreen.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 18, color: RetroColors.forestGreen),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    color: RetroColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 13,
                    color: RetroColors.inkSoft,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
