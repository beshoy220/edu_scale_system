import 'package:flutter/material.dart';
import '../../data/data_sources/library_resources_remote_data_source.dart';
import '../../data/models/library_item_model.dart';

class LibraryResourcesProvider extends ChangeNotifier {
  final LibraryResourcesRemoteDataSource _remoteDataSource =
      LibraryResourcesRemoteDataSource();

  final List<LibraryItemModel> resources = [];

  bool isLoading = false;
  bool hasMore = true;

  String? errorMessage;

  static int pageSize = 50;
  int from = 0;

  Future<void> loadResources() async {
    if (isLoading || !hasMore) return;

    try {
      isLoading = true;
      errorMessage = null;

      notifyListeners();

      final result = await _remoteDataSource.getLibraryResources(
        from: from,
        to: from + pageSize - 1,
      );

      resources.addAll(result);

      from += pageSize;

      if (result.length < pageSize) {
        hasMore = false;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    resources.clear();
    from = 0;
    hasMore = true;
    errorMessage = null;
    await loadResources();
  }

  void updateStatus({required int resourceId, required String status}) {
    final index = resources.indexWhere((e) => e.id == resourceId);

    if (index == -1) return;

    // update the status locally for immediate UI feedback
    resources[index] = LibraryItemModel(
      id: resources[index].id,
      title: resources[index].title,
      fileUrl: resources[index].fileUrl,
      fileSizeInKb: resources[index].fileSizeInKb,
      fileType: resources[index].fileType,
      status: status,
      createdAt: resources[index].createdAt,
      subjectName: resources[index].subjectName,
      gradeName: resources[index].gradeName,
      classNickname: resources[index].classNickname,
      uploadedBy: resources[index].uploadedBy,
    );

    // update the status on the server
    _remoteDataSource.updateResourceStatus(
      resourceId: resourceId,
      status: status,
    );

    notifyListeners();
  }
}
