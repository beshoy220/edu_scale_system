import 'package:edu_scale/core/supabase_service/supabase_storage_service.dart';
import 'package:edu_scale/teacher/library/data/data_sources/get_teacher_library_grade_classes_remote_data_source.dart';
import 'package:edu_scale/teacher/library/data/data_sources/get_teacher_library_resources_remote_data_source.dart';
import 'package:edu_scale/teacher/library/data/models/teacher_library_grade_class_model.dart';
import 'package:edu_scale/teacher/library/data/models/teacher_library_resources_item_model.dart';
import 'package:flutter/material.dart';

class TeacherLibraryProvider extends ChangeNotifier {
  final SupabaseStorageService _storageService = SupabaseStorageService();
  final GetTeacherLibraryGradeClassesRemoteDataSource _classesRemoteDataSource =
      GetTeacherLibraryGradeClassesRemoteDataSource();
  final GetTeacherLibraryResourcesRemoteDataSource
  _libraryResourcesRemoteDataSource =
      GetTeacherLibraryResourcesRemoteDataSource();

  List<TeacherLibraryGradeClassModel> classes = [];
  final List<TeacherLibraryResourcesItemModel> libraryResources = [];

  // ================= Upload =================
  bool isUploading = false;
  String? uploadErrorMessage;

  // ================= Grade Classes =================
  bool isLoadingGradeClasses = false;
  String? gradeClassesErrorMessage;

  // ================= Resources =================
  bool isLoadingResources = false;
  String? resourcesErrorMessage;

  Future<void> upload({
    required String title,
    required int gradeId,
    int? classId,
  }) async {
    isUploading = true;
    uploadErrorMessage = null;
    notifyListeners();

    try {
      await _storageService.pickCompressAndUploadFile(
        title: title,
        gradeId: gradeId,
        classId: classId,
      );
    } catch (e) {
      uploadErrorMessage = e.toString();
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  Future<void> getGradeClasses() async {
    isLoadingGradeClasses = true;
    gradeClassesErrorMessage = null;
    notifyListeners();

    try {
      classes = await _classesRemoteDataSource
          .getGradesAndClassesAssignedToTeacher();
    } catch (e) {
      gradeClassesErrorMessage = e.toString();
    } finally {
      isLoadingGradeClasses = false;
      notifyListeners();
    }
  }

  Future<void> loadResources({
    required int gradeId,
    required int? classId,
  }) async {
    isLoadingResources = true;
    resourcesErrorMessage = null;
    notifyListeners();

    try {
      final data = await _libraryResourcesRemoteDataSource.getLatestResources(
        gradeId: gradeId,
        classId: classId,
      );

      libraryResources
        ..clear()
        ..addAll(data);
    } catch (e) {
      resourcesErrorMessage = e.toString();
    } finally {
      isLoadingResources = false;
      notifyListeners();
    }
  }
}
