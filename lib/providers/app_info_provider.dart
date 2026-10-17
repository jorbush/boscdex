import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../core/constants/app_constants.dart';

/// Immutable representation of application version and build metadata.
class AppInfo {
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;

  const AppInfo({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
  });

  /// Short human-readable version string, e.g. "v1.0.0".
  String get displayVersion => 'v$version';

  /// Full version string including build number, e.g. "v1.0.0+1".
  String get fullDisplayVersion => 'v$version+$buildNumber';

  /// Fallback configuration used in unit tests or when native channels are unavailable.
  static const fallback = AppInfo(
    appName: AppConstants.appName,
    packageName: 'cat.boscdex.boscdex',
    version: AppConstants.appVersion,
    buildNumber: '1',
  );
}

/// Asynchronous provider that retrieves version metadata from the native iOS/Android bundle.
///
/// Falls back to [AppInfo.fallback] in headless test environments.
final appInfoProvider = FutureProvider<AppInfo>((ref) async {
  try {
    final info = await PackageInfo.fromPlatform();
    return AppInfo(
      appName: info.appName.isNotEmpty ? info.appName : AppConstants.appName,
      packageName: info.packageName,
      version: info.version.isNotEmpty ? info.version : AppConstants.appVersion,
      buildNumber: info.buildNumber.isNotEmpty ? info.buildNumber : '1',
    );
  } catch (_) {
    return AppInfo.fallback;
  }
});
