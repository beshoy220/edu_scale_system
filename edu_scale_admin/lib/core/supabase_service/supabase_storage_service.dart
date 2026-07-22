// import 'package:image_picker/image_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class StorageService {
//   final SupabaseClient _supabase = Supabase.instance.client;

//   /// Upload file to Supabase storage web version and need to modify before used for mobile version
//   Future<String?> uploadFile() async {
//     try {
//       final pickedFile = await ImagePicker().pickImage(
//         source: ImageSource.gallery,
//       );

//       if (pickedFile == null) return null;

//       final bytes = await pickedFile.readAsBytes();

//       await _supabase.storage
//           .from('new bucket')
//           .uploadBinary(
//             'folder/sub-folder/filename.png',
//             bytes,
//             fileOptions: const FileOptions(
//               contentType: 'image/png',
//               upsert: true,
//             ),
//           );

//       final url = _supabase.storage
//           .from('new-bucket')
//           .getPublicUrl('filename.png');

//       return url;
//     } catch (e) {
//       print('Upload error: $e');
//       return null;
//     }
//   }

//   /// Get file URL for viewing
//   String getFileUrl({required String bucket, required String path}) {
//     final url = _supabase.storage.from(bucket).getPublicUrl(path);
//     return url;
//   }
// }
