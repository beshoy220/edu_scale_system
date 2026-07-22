import '../entities/template_entity.dart';

/// 🧠 REPOSITORY CONTRACT
/// Defines WHAT the app can do (not HOW).
///
/// ❗ Why it exists:
/// - Decouples UI from data source (API, DB, etc.)
/// - Allows swapping backend without breaking UI
///
/// ✅ Used by:
/// - UseCase
///
/// ❌ Should NOT:
/// - contain implementation

abstract class TemplateRepoInterface {
  Future<List<TemplateEntity>> getTemplate();
}
