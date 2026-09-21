import 'package:flutter/material.dart';

class MorphologySection extends StatelessWidget {
  const MorphologySection({
    Key? key,
    required this.cap,
    required this.gills,
    required this.stem,
    this.latex,
  }) : super(key: key);

  final String cap;
  final String gills;
  final String stem;
  final String? latex;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          iconColor: Theme.of(context).colorScheme.tertiary,
          collapsedIconColor: Theme.of(context).colorScheme.onSurface,
          title: const Text(
            'Morfologia',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.tertiary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                text,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
