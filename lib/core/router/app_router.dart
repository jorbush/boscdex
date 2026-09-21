import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../theme/retro_decorations.dart';
import '../../presentation/boscdex/boscdex_screen.dart';
import '../../presentation/disclaimer/disclaimer_screen.dart';
import '../../presentation/detail/bolet_detail_screen.dart';
import '../../presentation/detail/arbre_detail_screen.dart';
import '../../presentation/scan/scan_screen.dart';
import '../../presentation/journal/journal_screen.dart';
import '../../presentation/splash/splash_screen.dart';

/// Central GoRouter configuration for the Boscdex app.
///
/// Navigation structure:
/// - Bottom nav with 3 tabs: Boscdex, Escanejar, Diari
/// - Push routes for specimen detail, tree detail, and disclaimer
final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    // Main shell with bottom navigation
    ShellRoute(
      builder: (context, state, child) {
        return BoscdexShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/boscdex',
          builder: (context, state) => const BoscdexScreen(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final id = state.params['id'] ?? '';
                return BoletDetailScreen(id: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/scan',
          builder: (context, state) => const ScanScreen(),
        ),
        GoRoute(
          path: '/journal',
          builder: (context, state) => const JournalScreen(),
        ),
      ],
    ),
    // Standalone routes
    GoRoute(
      path: '/arbre/:id',
      builder: (context, state) {
        final id = state.params['id'] ?? '';
        return ArbreDetailScreen(id: id);
      },
    ),
    GoRoute(
      path: '/disclaimer',
      builder: (context, state) => const DisclaimerScreen(),
    ),
  ],
);

/// Shell widget providing the bottom navigation bar for the 3 main tabs.
class BoscdexShell extends StatelessWidget {
  const BoscdexShell({super.key, required this.child});

  final Widget child;

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouter.of(context).location;
    if (location.startsWith('/boscdex')) return 0;
    if (location.startsWith('/scan')) return 1;
    if (location.startsWith('/journal')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: RetroColors.surface,
          border: Border(
            top: BorderSide(color: RetroColors.ink, width: 2.5),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          currentIndex: selectedIndex,
          onTap: (index) {
            HapticFeedback.selectionClick();
            switch (index) {
              case 0:
                GoRouter.of(context).go('/boscdex');
                break;
              case 1:
                GoRouter.of(context).go('/scan');
                break;
              case 2:
                GoRouter.of(context).go('/journal');
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              label: 'Boscdex',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_rounded),
              label: 'Escanejar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_stories_rounded),
              label: 'Diari',
            ),
          ],
        ),
      ),
    );
  }
}
