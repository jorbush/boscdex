import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/database/app_database.dart';

/// Service responsible for exporting, saving to device photo library,
/// and sharing user-captured field scan photographs.
class PhotoExportService {
  const PhotoExportService();

  static String? _documentsDirectoryPath;

  /// Initializes the base documents directory path used to resolve relative photo paths.
  static void initDocumentsDirectory(String path) {
    _documentsDirectoryPath = path;
  }

  /// Returns the configured documents directory path, if set.
  static String? get documentsDirectoryPath => _documentsDirectoryPath;

  /// Resolves any stored photo path (relative, legacy absolute, or filename)
  /// to a concrete [File] on disk against the active application container.
  static File resolveFile(String photoPath) {
    final cleanPath = photoPath.trim();
    if (cleanPath.isEmpty) return File(photoPath);

    // 1. If it already exists directly (e.g. current container or relative in current dir)
    final direct = File(cleanPath);
    if (direct.existsSync()) return direct;

    final docPath = _documentsDirectoryPath;
    if (docPath != null) {
      // 2. If it has scans/, extract from scans/ onward
      final scansIndex = cleanPath.indexOf('scans/');
      if (scansIndex != -1) {
        final rel = cleanPath.substring(scansIndex);
        final candidate = File(p.join(docPath, rel));
        if (candidate.existsSync()) return candidate;
        // Return candidate path even if not yet flushed (e.g. pending write)
        return candidate;
      }

      // 3. Fallback: match by filename inside scans/
      final fileName = p.basename(cleanPath);
      final inScans = File(p.join(docPath, 'scans', fileName));
      if (inScans.existsSync()) return inScans;

      // 4. Fallback: directly in documents
      final inDoc = File(p.join(docPath, fileName));
      if (inDoc.existsSync()) return inDoc;

      return inScans;
    }

    return direct;
  }

  /// Asynchronously resolves the photo file, ensuring getApplicationDocumentsDirectory
  /// is checked even if initDocumentsDirectory was not called.
  static Future<File> resolveFileAsync(String photoPath) async {
    if (_documentsDirectoryPath == null) {
      try {
        final dir = await getApplicationDocumentsDirectory();
        _documentsDirectoryPath = dir.path;
      } catch (_) {}
    }
    return resolveFile(photoPath);
  }

  /// Saves the photograph at [filePath] directly into the device's native photo gallery / camera roll.
  ///
  /// Requests necessary permissions and returns a user-friendly status message.
  Future<ExportResult> saveToGallery(String filePath) async {
    try {
      final file = await resolveFileAsync(filePath);
      if (!await file.exists()) {
        return const ExportResult(
          success: false,
          message: 'El fitxer de la imatge no existeix al dispositiu.',
        );
      }

      // Check and request storage/photos permission if needed on Android/iOS
      if (!kIsWeb && Platform.isAndroid) {
        var status = await Permission.photos.request();
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
        if (status.isPermanentlyDenied) {
          return const ExportResult(
            success: false,
            message:
                'Cal activar els permisos d\'emmagatzematge o fotos als Paràmetres.',
          );
        }
      } else if (!kIsWeb && Platform.isIOS) {
        final status = await Permission.photosAddOnly.request();
        if (status.isPermanentlyDenied || status.isDenied) {
          return const ExportResult(
            success: false,
            message:
                'Cal activar el permís de Fotos als Paràmetres de l\'iPhone.',
          );
        }
      }

      final bytes = await file.readAsBytes();
      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(bytes),
        quality: 100,
        name: 'boscdex_${DateTime.now().millisecondsSinceEpoch}',
      );

      final isSuccess = result != null &&
          (result['isSuccess'] == true ||
              result['isSuccess'] == 'true' ||
              result['isSuccess'] == 1);

      if (isSuccess) {
        return const ExportResult(
          success: true,
          message: '✅ Foto desada correctament a la teva galeria!',
        );
      } else {
        final error = result?['errorMessage'] ?? 'Error desconegut';
        return ExportResult(
          success: false,
          message: 'No s\'ha pogut desar la foto: $error',
        );
      }
    } catch (e) {
      return ExportResult(
        success: false,
        message: 'Error en desar la fotografia: $e',
      );
    }
  }

  /// Opens the system native share sheet to share or export the photograph.
  ///
  /// On iOS/iPadOS, [sharePositionOrigin] is required to anchor the share popover
  /// and avoid system crashes or presentation failures.
  Future<bool> sharePhoto(
    String filePath, {
    String? text,
    String? subject,
    Rect? sharePositionOrigin,
  }) async {
    try {
      final file = await resolveFileAsync(filePath);
      if (!await file.exists()) {
        debugPrint('PhotoExportService: file does not exist at $filePath');
        return false;
      }

      final ext = p.extension(file.path).toLowerCase();
      final isPng = ext == '.png';
      final mimeType = isPng ? 'image/png' : 'image/jpeg';
      final validExt = isPng ? '.png' : '.jpg';

      String pathToShare = file.path;
      String? shareName;

      try {
        final tempDir = await getTemporaryDirectory();
        final shareFileName =
            'boscdex_share_${DateTime.now().millisecondsSinceEpoch}$validExt';
        final shareFile = File(p.join(tempDir.path, shareFileName));
        await file.copy(shareFile.path);
        pathToShare = shareFile.path;
        shareName = shareFileName;
      } catch (e) {
        // Fallback to original file path if temporary copy cannot be created
        debugPrint('PhotoExportService: could not copy to temp directory: $e');
        pathToShare = file.path;
      }

      final xFile = XFile(
        pathToShare,
        mimeType: mimeType,
        name: shareName,
      );

      final origin = sharePositionOrigin ?? const Rect.fromLTWH(0, 0, 100, 100);

      await Share.shareXFiles(
        [xFile],
        text: text ?? 'Fotografia presa amb la guia micològica Boscdex 🍄',
        subject: subject ?? 'Boscdex - Identificació de camp',
        sharePositionOrigin: origin,
      );
      return true;
    } catch (e, stack) {
      debugPrint('Error sharing photo: $e\n$stack');
      return false;
    }
  }

  /// Deletes an avistament record from the database and deletes its file from disk.
  Future<bool> deleteSighting(AppDatabase db, String avistamentId) async {
    try {
      final avistament = await db.avistamentDao.getAvistamentById(avistamentId);
      if (avistament != null && avistament.photoPath != null) {
        final file = await resolveFileAsync(avistament.photoPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }
      // Unlink foreign key in descobriments if this sighting was the first discovery
      await (db.update(db.descobriments)
            ..where((t) => t.firstAvistamentId.equals(avistamentId)))
          .write(
        const DescobrimentsCompanion(
          firstAvistamentId: Value(null),
        ),
      );

      await db.avistamentDao.deleteAvistament(avistamentId);
      return true;
    } catch (e) {
      debugPrint('Error deleting sighting: $e');
      return false;
    }
  }
}

class ExportResult {
  final bool success;
  final String message;

  const ExportResult({required this.success, required this.message});
}
