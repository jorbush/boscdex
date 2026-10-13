import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

import 'package:boscdex/core/localization/app_localizations.dart';
import 'package:boscdex/domain/services/classifier_service.dart';
import 'package:boscdex/presentation/scan/icloud_photo_unavailable_sheet.dart';
import 'package:boscdex/presentation/scan/scan_screen.dart';
import 'package:boscdex/providers/classifier_provider.dart';

class _FakeImagePicker extends ImagePicker {
  final Future<XFile?> Function({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice,
    bool requestFullMetadata,
  })? onPickImage;

  _FakeImagePicker({this.onPickImage});

  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) {
    if (onPickImage != null) {
      return onPickImage!(
        source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
        preferredCameraDevice: preferredCameraDevice,
        requestFullMetadata: requestFullMetadata,
      );
    }
    return Future<XFile?>.value(null);
  }
}

Widget _buildLocalizedSheet({Locale locale = const Locale('ca')}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: const [
      Locale('ca'),
      Locale('es'),
      Locale('en'),
    ],
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: const Scaffold(
      body: ICloudPhotoUnavailableSheet(),
    ),
  );
}

Widget _buildScanScreenHarness({
  required ImagePicker imagePicker,
  Locale locale = const Locale('ca'),
}) {
  return ProviderScope(
    overrides: [
      classifierProvider.overrideWithValue(MockClassifierService()),
    ],
    child: MaterialApp(
      locale: locale,
      supportedLocales: const [
        Locale('ca'),
        Locale('es'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: ScanScreen(imagePicker: imagePicker),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  void setupMockChannels({
    required int permissionStatus,
    required Map<dynamic, dynamic> requestResult,
    List<Map<String, dynamic>> availableCameras = const [],
  }) {
    TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter.baseflow.com/permissions/methods'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'checkPermissionStatus') {
          return permissionStatus;
        }
        if (methodCall.method == 'requestPermissions') {
          return requestResult;
        }
        return null;
      },
    );

    TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/camera'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'availableCameras') {
          return availableCameras;
        }
        return null;
      },
    );
  }

  void clearMockChannels() {
    TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter.baseflow.com/permissions/methods'),
      null,
    );
    TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/camera'),
      null,
    );
  }

  group('ICloudPhotoUnavailableSheet error detection logic', () {
    test('detects exact iOS PHPicker / NSItemProvider iCloud exception', () {
      final error = PlatformException(
        code: 'invalid_image',
        message: 'Cannot load representation of type public.jpeg',
        details: 'NSItemProviderErrorDomain',
      );
      expect(
          ICloudPhotoUnavailableSheet.isICloudOrCloudSyncError(error), isTrue);
    });

    test('detects HEIC representation error', () {
      final error = PlatformException(
        code: 'invalid_image',
        message: 'Cannot load representation of type public.heic',
        details: 'NSItemProviderErrorDomain',
      );
      expect(
          ICloudPhotoUnavailableSheet.isICloudOrCloudSyncError(error), isTrue);
    });

    test('detects any invalid_image platform code from iOS PHPicker', () {
      final error = PlatformException(
        code: 'invalid_image',
        message: 'Failed to access asset',
      );
      expect(
          ICloudPhotoUnavailableSheet.isICloudOrCloudSyncError(error), isTrue);
    });

    test('detects string containing NSItemProviderErrorDomain or public.jpeg',
        () {
      const rawString =
          'PlatformException(invalid_image, Cannot load representation of type public.jpeg, NSItemProviderErrorDomain, null)';
      expect(ICloudPhotoUnavailableSheet.isICloudOrCloudSyncError(rawString),
          isTrue);
    });

    test('returns false for unrelated errors', () {
      const normalError = 'User canceled selection or camera failed';
      expect(ICloudPhotoUnavailableSheet.isICloudOrCloudSyncError(normalError),
          isFalse);

      final generalPlatformError = PlatformException(
        code: 'camera_access_denied',
        message: 'Permission denied',
      );
      expect(
          ICloudPhotoUnavailableSheet.isICloudOrCloudSyncError(
              generalPlatformError),
          isFalse);
    });
  });

  group('Localized AppLocalizations error handling', () {
    test('transforms raw iCloud error into clear user guidance in Catalan', () {
      const l10n = AppLocalizations(Locale('ca'));
      final formatted = l10n.errorLoadingGalleryImage(
        'PlatformException(invalid_image, Cannot load representation of type public.jpeg, NSItemProviderErrorDomain, null)',
      );
      expect(
        formatted,
        'Foto a l\'iCloud no descarregada al dispositiu. Obre l\'app Fotos per descarregar-la abans de seleccionar-la.',
      );
    });

    test('transforms raw iCloud error into clear user guidance in Spanish', () {
      const l10n = AppLocalizations(Locale('es'));
      final formatted = l10n.errorLoadingGalleryImage(
        'PlatformException(invalid_image, Cannot load representation of type public.jpeg, NSItemProviderErrorDomain, null)',
      );
      expect(
        formatted,
        'Foto en iCloud no descargada en el dispositivo. Abre la app Fotos para descargarla antes de seleccionarla.',
      );
    });

    test('transforms raw iCloud error into clear user guidance in English', () {
      const l10n = AppLocalizations(Locale('en'));
      final formatted = l10n.errorLoadingGalleryImage(
        'PlatformException(invalid_image, Cannot load representation of type public.jpeg, NSItemProviderErrorDomain, null)',
      );
      expect(
        formatted,
        'iCloud photo not downloaded on device. Open the Photos app to download it before selecting.',
      );
    });

    test('preserves generic error message when error is not iCloud related',
        () {
      const l10n = AppLocalizations(Locale('ca'));
      final formatted = l10n.errorLoadingGalleryImage('OutOfMemoryError');
      expect(formatted,
          'Error en carregar la imatge de la galeria: OutOfMemoryError');
    });
  });

  group('ICloudPhotoUnavailableSheet widget rendering', () {
    testWidgets('renders Catalan explanations and dismisses on Entès tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(_buildLocalizedSheet(locale: const Locale('ca')));
      await tester.pump();

      expect(find.text('Foto a l\'iCloud no disponible'), findsOneWidget);
      expect(find.text('COM SOLUCIONAR-HO'), findsOneWidget);
      expect(find.text('1. Obre l\'aplicació Fotos d\'Apple al teu iPhone.'),
          findsOneWidget);
      expect(
          find.text(
              '2. Toca aquesta foto perquè es descarregui (veuràs el cercle de càrrega d\'iCloud).'),
          findsOneWidget);
      expect(
          find.text(
              '3. Torna a Boscdex i selecciona-la de nou des de la galeria.'),
          findsOneWidget);
      expect(find.text('Entès'), findsOneWidget);

      await tester
          .tap(find.byKey(const Key('icloud_unavailable_dismiss_button')));
      await tester.pump();
    });

    testWidgets('renders Spanish explanations correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(_buildLocalizedSheet(locale: const Locale('es')));
      await tester.pump();

      expect(find.text('Foto en iCloud no disponible'), findsOneWidget);
      expect(find.text('CÓMO SOLUCIONARLO'), findsOneWidget);
      expect(find.text('1. Abre la app Fotos de Apple en tu iPhone.'),
          findsOneWidget);
      expect(find.text('Entendido'), findsOneWidget);
    });

    testWidgets('renders English explanations correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(_buildLocalizedSheet(locale: const Locale('en')));
      await tester.pump();

      expect(find.text('iCloud Photo Unavailable'), findsOneWidget);
      expect(find.text('HOW TO RESOLVE THIS'), findsOneWidget);
      expect(find.text('1. Open Apple\'s Photos app on your iPhone.'),
          findsOneWidget);
      expect(find.text('Got it'), findsOneWidget);
    });
  });

  group('ScanScreen gallery iCloud integration', () {
    setUp(() {
      setupMockChannels(
        permissionStatus: 1, // granted
        requestResult: {1: 1},
        availableCameras: [],
      );
    });

    tearDown(() {
      clearMockChannels();
    });

    testWidgets(
        'shows ICloudPhotoUnavailableSheet when iOS gallery throws iCloud representation error',
        (WidgetTester tester) async {
      bool requestFullMetadataUsed = true;

      final fakePicker = _FakeImagePicker(
        onPickImage: ({
          required ImageSource source,
          double? maxWidth,
          double? maxHeight,
          int? imageQuality,
          CameraDevice preferredCameraDevice = CameraDevice.rear,
          bool requestFullMetadata = true,
        }) async {
          requestFullMetadataUsed = requestFullMetadata;
          throw PlatformException(
            code: 'invalid_image',
            message: 'Cannot load representation of type public.jpeg',
            details: 'NSItemProviderErrorDomain',
          );
        },
      );

      await tester.pumpWidget(_buildScanScreenHarness(imagePicker: fakePicker));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final galleryButton = find.byKey(const Key('gallery_picker_button'));
      expect(galleryButton, findsOneWidget);

      await tester.tap(galleryButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verify requestFullMetadata was explicitly passed as false
      expect(requestFullMetadataUsed, isFalse);

      // Verify that the iCloud sheet appeared
      expect(find.text('Foto a l\'iCloud no disponible'), findsOneWidget);
      expect(find.text('COM SOLUCIONAR-HO'), findsOneWidget);

      // Tap Entès to close
      await tester
          .tap(find.byKey(const Key('icloud_unavailable_dismiss_button')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verify sheet dismissed
      expect(find.text('Foto a l\'iCloud no disponible'), findsNothing);
    });

    testWidgets('shows standard SnackBar for generic non-iCloud gallery errors',
        (WidgetTester tester) async {
      final fakePicker = _FakeImagePicker(
        onPickImage: ({
          required ImageSource source,
          double? maxWidth,
          double? maxHeight,
          int? imageQuality,
          CameraDevice preferredCameraDevice = CameraDevice.rear,
          bool requestFullMetadata = true,
        }) async {
          throw PlatformException(
            code: 'photo_access_denied',
            message: 'Access denied by system policy',
          );
        },
      );

      await tester.pumpWidget(_buildScanScreenHarness(imagePicker: fakePicker));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final galleryButton = find.byKey(const Key('gallery_picker_button'));
      await tester.tap(galleryButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verify SnackBar appeared instead of iCloud bottom sheet
      expect(find.text('Foto a l\'iCloud no disponible'), findsNothing);
      expect(
        find.textContaining('Error en carregar la imatge de la galeria:'),
        findsOneWidget,
      );
    });

    testWidgets(
        'handles user canceling gallery selection gracefully without errors',
        (WidgetTester tester) async {
      final fakePicker = _FakeImagePicker(
        onPickImage: ({
          required ImageSource source,
          double? maxWidth,
          double? maxHeight,
          int? imageQuality,
          CameraDevice preferredCameraDevice = CameraDevice.rear,
          bool requestFullMetadata = true,
        }) async {
          return null; // User tapped cancel
        },
      );

      await tester.pumpWidget(_buildScanScreenHarness(imagePicker: fakePicker));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final galleryButton = find.byKey(const Key('gallery_picker_button'));
      await tester.tap(galleryButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Foto a l\'iCloud no disponible'), findsNothing);
      expect(find.byType(SnackBar), findsNothing);
    });
  });
}
