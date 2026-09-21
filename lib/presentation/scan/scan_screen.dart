import 'dart:async';
import 'dart:developer' as developer;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/classifier_provider.dart';
import '../shared/offline_indicator.dart';
import 'classification_result_sheet.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen>
    with SingleTickerProviderStateMixin {
  int _selectedModeIndex = 0; // 0 for Bolets, 1 for Arbres
  bool _isScanning = false;
  late AnimationController _animController;

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
      final classifier = ref.read(classifierProvider);
      // Pass dummy bytes for Edge-ML inference simulation
      final dummyBytes = Uint8List(0);
      final results = await classifier.classify(dummyBytes);

      if (mounted) {
        _animController.stop();
        setState(() => _isScanning = false);

        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (ctx) => ClassificationResultSheet(
            results: results,
            imageBytes: dummyBytes,
          ),
        );
      }
    } catch (e, stackTrace) {
      developer.log(
        'Identification error: $e',
        error: e,
        stackTrace: stackTrace,
        name: 'ScanScreen',
      );
      if (mounted) {
        _animController.stop();
        setState(() => _isScanning = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error d\'identificació: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Viewfinder Background
          Positioned.fill(
            child: Container(
              color: const Color(0xFF101B12),
              child: Center(
                child: AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) {
                    final scale = _isScanning
                        ? 1.0 + (_animController.value * 0.08)
                        : 1.0;
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: _isScanning
                                ? Theme.of(context).colorScheme.tertiary
                                : Colors.white.withOpacity(0.4),
                            width: _isScanning ? 3 : 2,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              _selectedModeIndex == 0
                                  ? Icons.filter_center_focus
                                  : Icons.nature,
                              size: 100,
                              color: _isScanning
                                  ? Theme.of(context)
                                      .colorScheme
                                      .tertiary
                                      .withOpacity(0.6)
                                  : Colors.white.withOpacity(0.2),
                            ),
                            if (_isScanning) ...[
                              Positioned(
                                top: 20,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Analitzant amb Edge-AI...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
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
              ),
            ),
          ),

          // Viewfinder Targeting Instructions
          Positioned(
            top: MediaQuery.of(context).padding.top + 70,
            left: 20,
            right: 20,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _selectedModeIndex == 0
                      ? 'Enfoca el barret i les làmines del bolet'
                      : 'Enfoca l\'escorça o les fulles de l\'arbre',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          // Mode Switcher (Bolets | Arbres)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(24),
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

          // Offline Badge
          Positioned(
            top: MediaQuery.of(context).padding.top + 24,
            right: 16,
            child: const OfflineIndicator(),
          ),

          // Bottom Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(
                  bottom: 32, top: 24, left: 24, right: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Gallery picker button
                  IconButton(
                    key: const Key('gallery_picker_button'),
                    icon: const Icon(Icons.photo_library,
                        color: Colors.white, size: 32),
                    tooltip: 'Triar de la galeria',
                    onPressed: _isScanning ? null : _performScan,
                  ),

                  // Shutter button
                  GestureDetector(
                    key: const Key('shutter_button'),
                    onTap: _isScanning ? null : _performScan,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _isScanning
                              ? Theme.of(context).colorScheme.tertiary
                              : Colors.white,
                          width: 4,
                        ),
                      ),
                      child: Center(
                        child: _isScanning
                            ? SizedBox(
                                width: 36,
                                height: 36,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              )
                            : Container(
                                width: 64,
                                height: 64,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance for left icon
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
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedModeIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
