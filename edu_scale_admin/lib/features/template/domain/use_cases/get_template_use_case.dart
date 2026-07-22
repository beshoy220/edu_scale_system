import '../entities/template_entity.dart';
import '../repo_interfaces/template_repo_interface.dart';

/// 🎯 USECASE
/// Represents ONE action in the app.
///
/// Example:
/// - getTemplate
/// - createTemplate
/// - deleteTemplate
///
/// ❗ Why it exists:
/// - Keeps business logic out of UI/Provider
/// - Makes logic reusable & testable
///
/// ✅ Used by:
/// - Provider

class GetTemplateUseCase {
  final TemplateRepoInterface repository;

  GetTemplateUseCase(this.repository);

  Future<List<TemplateEntity>> call() async {
    return await repository.getTemplate();
  }
}
