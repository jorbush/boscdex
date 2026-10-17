import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/core/constants/app_constants.dart';
import 'package:boscdex/providers/app_info_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppInfo & appInfoProvider Tests', () {
    test('AppInfo formatting methods produce expected version strings', () {
      const info = AppInfo(
        appName: 'Boscdex',
        packageName: 'cat.boscdex.boscdex',
        version: '1.2.3',
        buildNumber: '42',
      );

      expect(info.displayVersion, equals('v1.2.3'));
      expect(info.fullDisplayVersion, equals('v1.2.3+42'));
    });

    test('AppInfo.fallback defaults to AppConstants.appVersion', () {
      expect(AppInfo.fallback.appName, equals(AppConstants.appName));
      expect(AppInfo.fallback.version, equals(AppConstants.appVersion));
      expect(AppInfo.fallback.buildNumber, equals('1'));
      expect(
        AppInfo.fallback.displayVersion,
        equals('v${AppConstants.appVersion}'),
      );
    });

    test('appInfoProvider returns valid AppInfo fallback in unit tests',
        () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final appInfo = await container.read(appInfoProvider.future);

      expect(appInfo.appName, isNotEmpty);
      expect(appInfo.version, isNotEmpty);
      expect(appInfo.displayVersion, startsWith('v'));
    });
  });
}
