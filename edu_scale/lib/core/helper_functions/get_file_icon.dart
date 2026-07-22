import 'package:flutter/cupertino.dart';

IconData getFileIcon(String fileType) {
  switch (fileType.toLowerCase()) {
    case 'pdf':
    case 'doc':
    case 'docx':
    case 'txt':
      return CupertinoIcons.doc; // or Icons.description
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
      return CupertinoIcons.photo;
    case 'mp4':
    case 'mov':
      return CupertinoIcons.video_camera;
    case 'mp3':
    case 'wav':
      return CupertinoIcons.music_note;
    default:
      return CupertinoIcons.doc;
  }
}
