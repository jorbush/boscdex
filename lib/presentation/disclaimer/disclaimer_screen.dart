import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/retro_decorations.dart';
import '../../providers/preferences_provider.dart';

class DisclaimerScreen extends ConsumerStatefulWidget {
  const DisclaimerScreen({super.key});

  @override
  ConsumerState<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends ConsumerState<DisclaimerScreen> {
  bool _accepted = false;

  void _toggleAccepted() {
    HapticFeedback.selectionClick();
    setState(() {
      _accepted = !_accepted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RetroColors.creamBg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 32,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      // Briefing Card
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: RetroDecorations.card(
                          backgroundColor: Colors.white,
                          borderColor: RetroColors.ink,
                          borderWidth: 2.5,
                          shadowOffset: 5,
                        ),
                        child: Column(
                          children: [
                            // Hazard icon pill
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: RetroColors.alertDangerLight,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: RetroColors.arcadeRed, width: 2.5),
                              ),
                              child: const Icon(
                                Icons.warning_amber_rounded,
                                size: 48,
                                color: RetroColors.arcadeRed,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Avís Legal Important',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: RetroColors.arcadeRed,
                                letterSpacing: -0.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Aquesta aplicació és una guia orientativa i educativa. La intel·ligència artificial pot cometre errors. Mai consumeixis cap bolet sense la validació d\'un expert micòleg humà. L\'ús d\'aquesta aplicació no substitueix el coneixement expert. L\'equip de Boscdex no es fa responsable de cap intoxicació o dany derivat de l\'ús incorrecte de la informació proporcionada.',
                              style: TextStyle(
                                fontSize: 13.5,
                                height: 1.45,
                                fontWeight: FontWeight.w600,
                                color: RetroColors.inkSoft,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Acceptance Checkbox (Fully interactive row)
                      GestureDetector(
                        onTap: _toggleAccepted,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: RetroColors.ink, width: 2),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: _accepted,
                                activeColor: RetroColors.forestGreen,
                                checkColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                side: const BorderSide(
                                    color: RetroColors.ink, width: 2),
                                onChanged: (val) {
                                  _toggleAccepted();
                                },
                              ),
                              const Expanded(
                                child: Text(
                                  'He llegit i accepto les condicions d\'avisos de seguretat',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: RetroColors.ink,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(height: 16),

                      // Start Action Button (ElevatedButton)
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: RetroColors.forestGreen,
                            disabledBackgroundColor: const Color(0xFFBDC7BB),
                            foregroundColor: Colors.white,
                            disabledForegroundColor: const Color(0xFF7D877B),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: const BorderSide(
                                  color: RetroColors.ink, width: 2.5),
                            ),
                          ),
                          onPressed: _accepted
                              ? () {
                                  HapticFeedback.mediumImpact();
                                  ref
                                      .read(disclaimerAcceptedProvider.notifier)
                                      .accept();
                                  context.go('/boscdex');
                                }
                              : null,
                          child: const Text(
                            'Començar a explorar',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
