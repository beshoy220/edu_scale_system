import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:open_filex/open_filex.dart';

class FileCacheManager {
  static final instance = CacheManager(
    Config(
      'library_cache',
      stalePeriod: const Duration(days: 365),
      maxNrOfCacheObjects: 1000,
    ),
  );

  static Future<void> openLibraryFile(String url) async {
    final file = await instance.getSingleFile(url);
    await OpenFilex.open(file.path);
  }
}
