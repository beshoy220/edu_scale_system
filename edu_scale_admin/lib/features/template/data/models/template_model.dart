import 'dart:convert';
import '../../domain/entities/template_entity.dart';

/// 📦 MODEL
/// Represents the data format coming from API/DB.
///
/// ❗ Why it exists:
/// - API structure ≠ App structure
/// - Protects your app from backend changes
///
/// ✅ Responsibilities:
/// - Convert JSON ↔ Dart
/// - Convert Model → Entity

class TemplateModel {
  final String id;
  final String name;
  final String description;
  final String content;

  TemplateModel({
    required this.id,
    required this.name,
    required this.description,
    required this.content,
  });

  TemplateEntity toEntity() {
    return TemplateEntity(id: id, name: name);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'content': content,
    };
  }

  factory TemplateModel.fromMap(Map<String, dynamic> map) {
    return TemplateModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      content: map['content'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TemplateModel.fromJson(String source) =>
      TemplateModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TemplateModel(id: $id, name: $name, description: $description, content: $content)';
  }

  @override
  bool operator ==(covariant TemplateModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.content == content;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        content.hashCode;
  }
}
