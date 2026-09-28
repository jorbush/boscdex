import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/database/app_database.dart';

/// Service responsible for exporting, saving to device photo library,
/// and sharing user-captured field scan photographs.
class PhotoExportService {
  const PhotoExportService();

  /// Saves the photograph at [filePath] directly into the device's native photo gallery / camera roll.
  ///
  /// Requests necessary permissions and returns a user-friendly status message.
  Future<ExportResult> saveToGallery(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return const ExportResult(
          success: false,
          message: 'El fitxer de la imatge no existeix al dispositiu.',
        );
      }

      // Check and request storage/photos permission if needed on Android/iOS
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (status.isPermanentlyDenied) {
          return const ExportResult(
            success: false,
            message:
                'Cal activar els permisos d\'emmagatzematge als Paràmetres.',
          );
        }
      } else if (Platform.isIOS) {
        final status = await Permission.photosAddOnly.request();
        if (status.isPermanentlyDenied) {
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
  Future<void> sharePhoto(String filePath, {String? text}) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return;

      await Share.shareXFiles(
        [XFile(filePath)],
        text: text ?? 'Fotografia presa amb la guia micològica Boscdex 🍄',
      );
    } catch (e) {
      debugPrint('Error sharing photo: $e');
    }
  }

  /// Deletes an avistament record from the database and deletes its file from disk.
  Future<bool> deleteSighting(AppDatabase db, String avistamentId) async {
    try {
      final avistament = await db.avistamentDao.getAvistamentById(avistamentId);
      if (avistament != null && avistament.photoPath != null) {
        final file = File(avistament.photoPath!);
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
