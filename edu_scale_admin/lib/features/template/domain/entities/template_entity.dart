// ignore: dangling_library_doc_comments
/// 🧠 ENTITY
/// This is the core business object used across the app.
///
/// ❗ Rules:
/// - Pure Dart (NO Flutter imports)
/// - No JSON / API logic
/// - Represents what UI/business actually needs
///
/// ✅ Used by:
/// - UI
/// - UseCases
/// - Repository (contract)

class TemplateEntity {
  final String id;
  final String name;

  TemplateEntity({required this.id, required this.name});
}
