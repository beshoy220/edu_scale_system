class StudentLibraryResourceModel {
  final int id;
  final String title;
  final String fileUrl;
  final int fileSizeInKb;
  final String fileType;
  final DateTime createdAt;

  const StudentLibraryResourceModel({
    required this.id,
    required this.title,
    required this.fileUrl,
    required this.fileSizeInKb,
    required this.fileType,
    required this.createdAt,
  });

  factory StudentLibraryResourceModel.fromJson(Map<String, dynamic> json) {
    return StudentLibraryResourceModel(
      id: json['id'] as int,
      title: json['title'] as String,
      fileUrl: json['file_url'] as String,
      fileSizeInKb: json['file_size_in_kb'] as int,
      fileType: json['file_type'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
