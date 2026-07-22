import '../../domain/entities/template_entity.dart';
import '../../domain/repo_interfaces/template_repo_interface.dart';
import '../data_sources/cache/template_cache_data_source.dart';
import '../data_sources/remote/template_remote_data_source.dart';

/// 🔗 REPOSITORY IMPLEMENTATION
/// This is where everything connects.
///
/// ❗ Why it exists:
/// - Bridges Domain ↔ Data
/// - Converts Model → Entity
///
/// ✅ Flow:
/// DataSource → Model → Entity → return
///
/// ✅ Used by:
/// - UseCase

class TemplateRepoImplementation implements TemplateRepoInterface {
  final TemplateRemoteDataSource remoteDataSource;
  final TemplateCacheDataSource cacheDataSource;

  TemplateRepoImplementation({
    required this.remoteDataSource,
    required this.cacheDataSource,
  });

  @override
  Future<List<TemplateEntity>> getTemplate() async {
    // ignore: unused_local_variable
    final cacheData = await cacheDataSource.fetchTemplate();
    final remoteData = await remoteDataSource.fetchTemplate();

    List<TemplateEntity> templates = remoteData
        .map((e) => e.toEntity())
        .toList();

    return templates;
  }
}
