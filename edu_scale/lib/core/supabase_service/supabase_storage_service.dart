import 'dart:io';
import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/account_manager/cached_account_model.dart';
import 'package:edu_scale/core/supabase_service/supabase_client.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_media_compress/flutter_media_compress.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  static const _bucketName = 'library';
  static const _imageExtensions = {'jpg', 'jpeg', 'png'};

  Future<void> pickCompressAndUploadFile({
    required String title,
    required int gradeId,
    int? classId,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const [
          'pdf',
          'doc',
          'docx',
          'xls',
          'xlsx',
          'ppt',
          'pptx',
          'png',
          'jpg',
          'jpeg',
        ],
      );

      if (result == null) return;

      final currentUser = await AccountManager.currentAccount();
      final platformFile = result.files.first;
      final originalFile = File(platformFile.path!);
      final extension = platformFile.extension!.toLowerCase();

      File fileToUpload = originalFile;
      bool isCompressed = false;
      int uploadedFileSizeInKb = (await originalFile.length() / 1024).ceil();

      if (_imageExtensions.contains(extension)) {
        final compressResult = await FlutterMediaCompress.compressSingle(
          file: originalFile,
          config: const CompressionConfig(quality: CompressQuality.low),
        );

        fileToUpload = compressResult.compressedFile;
        isCompressed = true;

        uploadedFileSizeInKb = (compressResult.compressedSizeBytes / 1024)
            .ceil();

        debugPrint(
          "Original: ${(compressResult.originalSizeBytes / 1024).toStringAsFixed(2)} KB",
        );

        debugPrint(
          "Compressed: ${(compressResult.compressedSizeBytes / 1024).toStringAsFixed(2)} KB",
        );
      }

      final signedUrl = await _uploadToSupabase(
        currentUser: currentUser!,
        file: fileToUpload,
        originalFileName: platformFile.name,
      );

      await _saveLibraryResourceToLibraryResourcesTable(
        currentUser: currentUser,
        title: title,
        gradeId: gradeId,
        classId: classId,
        signedUrl: signedUrl,
        fileSizeInKb: uploadedFileSizeInKb,
        fileType: extension,
      );

      if (isCompressed) {
        await fileToUpload.delete();
      }

      debugPrint("Upload completed successfully.");
    } catch (e, s) {
      debugPrint("Upload failed: $e");
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  Future<String> _uploadToSupabase({
    required dynamic currentUser,
    required File file,
    required String originalFileName,
  }) async {
    final schoolFolder = currentUser.email.split('@')[1].split('.').first;

    final extension = originalFileName.split('.').last.toLowerCase();
    final fileName = originalFileName.replaceAll(RegExp(r'\.[^.]+$'), '');

    final storagePath =
        '$schoolFolder/${DateTime.now().millisecondsSinceEpoch}_$fileName.$extension';

    await SupabaseConfig.client.storage
        .from(_bucketName)
        .upload(
          storagePath,
          file,
          fileOptions: FileOptions(contentType: _getContentType(extension)),
        );

    return await SupabaseConfig.client.storage
        .from(_bucketName)
        .createSignedUrl(
          storagePath,
          31557600, // 1 year
        );
  }

  Future<void> _saveLibraryResourceToLibraryResourcesTable({
    required CachedAccount currentUser,
    required String title,
    required String signedUrl,
    required int fileSizeInKb,
    required String fileType,
    required int gradeId,
    int? classId,
  }) async {
    await SupabaseConfig.client.from("library_resources").insert({
      "school_id": currentUser.schoolId,
      "teacher_id": currentUser.id,
      "subject_id": currentUser.ids.subjectId,
      "grade_id": gradeId,
      "class_id": classId,
      "title": title,
      "file_url": signedUrl,
      "file_size_in_kb": fileSizeInKb,
      "file_type": fileType,
    });
  }

  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';

      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';

      case 'png':
        return 'image/png';

      case 'doc':
        return 'application/msword';

      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';

      case 'xls':
        return 'application/vnd.ms-excel';

      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

      case 'ppt':
        return 'application/vnd.ms-powerpoint';

      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';

      default:
        return 'application/octet-stream';
    }
  }
}
