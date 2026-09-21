import 'package:flutter/material.dart';
import '../../core/theme/retro_decorations.dart';

class SafetyAlertBox extends StatelessWidget {
  final String confusionSpecies;
  final VoidCallback onTap;

  const SafetyAlertBox({
    super.key,
    required this.confusionSpecies,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label:
          'Alerta de confusió perillosa: Es pot confondre fàcilment amb $confusionSpecies. Toca per comparar.',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: RetroColors.alertDangerLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: RetroColors.ink, width: 2.5),
            boxShadow: const [
              BoxShadow(
                color: RetroColors.arcadeRed,
                offset: Offset(3, 3),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: RetroColors.arcadeRed,
                  shape: BoxShape.circle,
                  border: Border.all(color: RetroColors.ink, width: 2),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ALERTA DE CONFUSIÓ PERILLOSA',
                      style: TextStyle(
                        color: RetroColors.arcadeRed,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Es pot confondre fàcilment amb: $confusionSpecies',
                      style: const TextStyle(
                        color: RetroColors.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Toca per comparar',
                      style: TextStyle(
                        color: RetroColors.inkSoft,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: RetroColors.ink),
            ],
          ),
        ),
      ),
    );
  }
}
