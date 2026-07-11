import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageCompressionService {
  static const int _maxSizeInBytes = 5 * 1024 * 1024; // ✅ 5MB
  static const int _minQuality = 40;
  static const int _initialQuality = 90;

  /// Compress multiple images sequentially.
  /// Returns only successfully compressed files.
  static Future<List<File>> compressImages(List<XFile> originals) async {
    final List<File> results = [];

    for (final file in originals) {
      final compressed = await _compressSingle(file);
      if (compressed != null) {
        results.add(compressed);
      }
    }

    return results;
  }

  /// Compress single image under 5MB constraint.
  static Future<File?> _compressSingle(XFile original) async {
    try {
      final tempDir = await getTemporaryDirectory();

      final targetPath = p.join(
        tempDir.path,
        'img_${DateTime.now().microsecondsSinceEpoch}.jpg',
      );

      int quality = _initialQuality;
      File? compressed;

      do {
        final result = await FlutterImageCompress.compressAndGetFile(
          original.path,
          targetPath,
          quality: quality,
          minWidth: 1080, // better visual fidelity for product images
          minHeight: 1080,
          format: CompressFormat.jpeg,
        );

        if (result == null) return null;

        compressed = File(result.path);
        final size = await compressed.length();

        if (kDebugMode) {
          debugPrint(
            'Compressing ${p.basename(original.path)} '
            '| Quality=$quality '
            '| Size=${(size / 1024 / 1024).toStringAsFixed(2)} MB',
          );
        }

        if (size <= _maxSizeInBytes) break;

        quality -= 10;
      } while (quality >= _minQuality);

      return compressed;
    } catch (e, st) {
      debugPrint('Image compression failed: $e');
      debugPrintStack(stackTrace: st);
      return null;
    }
  }
}
