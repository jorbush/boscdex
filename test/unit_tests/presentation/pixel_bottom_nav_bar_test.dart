import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:boscdex/core/localization/app_localizations.dart';
import 'package:boscdex/presentation/shared/pixel_icons.dart';
import 'package:boscdex/core/router/app_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Pixel BottomNavigationBar Tests', () {
    testWidgets(
        'Renders PixelDexIcon, PixelCameraIcon, and PixelJournalIcon in BottomNav',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final router = GoRouter(
        initialLocation: '/boscdex',
        routes: [
          ShellRoute(
            builder: (context, state, child) => BoscdexShell(child: child),
            routes: [
              GoRoute(
                path: '/boscdex',
                builder: (context, state) => const Text('Boscdex Page'),
              ),
              GoRoute(
                path: '/scan',
                builder: (context, state) => const Text('Scan Page'),
              ),
              GoRoute(
                path: '/journal',
                builder: (context, state) => const Text('Journal Page'),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ca'),
              Locale('es'),
              Locale('en'),
            ],
            locale: const Locale('ca'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify that all 3 custom pixel icons exist in the bottom navigation bar
      expect(find.byType(PixelDexIcon), findsOneWidget);
      expect(find.byType(PixelCameraIcon), findsOneWidget);
      expect(find.byType(PixelJournalIcon), findsOneWidget);

      // Tab 0 (Boscdex) is active
      final activeDex = tester.widget<PixelDexIcon>(find.byType(PixelDexIcon));
      expect(activeDex.isActive, isTrue);

      final inactiveCamera =
          tester.widget<PixelCameraIcon>(find.byType(PixelCameraIcon));
      expect(inactiveCamera.isActive, isFalse);

      final inactiveJournal =
          tester.widget<PixelJournalIcon>(find.byType(PixelJournalIcon));
      expect(inactiveJournal.isActive, isFalse);

      // Tap Scan tab (PixelCameraIcon)
      await tester.tap(find.byType(PixelCameraIcon));
      await tester.pumpAndSettle();

      expect(router.location, equals('/scan'));
      expect(find.text('Scan Page'), findsOneWidget);

      // Tap Journal tab (PixelJournalIcon)
      await tester.tap(find.byType(PixelJournalIcon));
      await tester.pumpAndSettle();

      expect(router.location, equals('/journal'));
      expect(find.text('Journal Page'), findsOneWidget);

      // Tap Boscdex tab (PixelDexIcon)
      await tester.tap(find.byType(PixelDexIcon));
      await tester.pumpAndSettle();

      expect(router.location, equals('/boscdex'));
      expect(find.text('Boscdex Page'), findsOneWidget);
    });
  });
}
