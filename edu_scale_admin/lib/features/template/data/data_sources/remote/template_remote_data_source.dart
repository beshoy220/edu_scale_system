// ignore: dangling_library_doc_comments
import '../../models/template_model.dart';

/// 🌐 DATASOURCE
/// Responsible for fetching raw data (API, Supabase, Firebase...)
///
/// ❗ Why it exists:
/// - Isolates external services from the app
/// - Makes it easy to switch APIs later
///
/// ❌ Should NOT:
/// - contain business logic
/// - return Entity
///
/// ✅ Returns:
/// - Model

class TemplateRemoteDataSource {
  Future<List<TemplateModel>> fetchTemplate() async {
    await Future.delayed(const Duration(seconds: 1));

    List apiResponse = [
      {
        'id': '1',
        'name': 'Hii, I am template 1',
        'description': 'Description for Template 1',
        'content': 'Content for Template 1',
      },
      {
        'id': '2',
        'name': 'Hello, I am template 2',
        'description': 'Description for Template 2',
        'content': 'Content for Template 2',
      },
    ];

    List<TemplateModel> templates = apiResponse
        .map((templateData) => TemplateModel.fromMap(templateData))
        .toList();

    return templates;
  }
}
