import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'domain/services/photo_export_service.dart';
import 'providers/preferences_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  try {
    final appDir = await getApplicationDocumentsDirectory();
    PhotoExportService.initDocumentsDirectory(appDir.path);
  } catch (e) {
    debugPrint('Could not initialize documents directory in main: $e');
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const BoscdexApp(),
    ),
  );
}
