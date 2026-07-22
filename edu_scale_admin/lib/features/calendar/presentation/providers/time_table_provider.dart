import 'package:edu_scale_admin/features/calendar/data/data_sources/time_table_remote_data_source.dart';
import 'package:flutter/material.dart';
import '../../data/data_sources/delete_session_remote_data_source.dart';
import '../../data/data_sources/get_classes_remote_data_source.dart';
import '../../data/models/class_model.dart';
import '../../data/models/grade_model.dart';
import '../../data/models/time_table_session_model.dart';

class TimeTableProvider extends ChangeNotifier {
  //sesions fields:
  bool isLoadingForSessions = false;
  String? errorMessageForSessions;
  List<TimeTableSessionModel> sessions = [];

  // classes fields:
  List<ClassModel> classes = [];
  ClassModel? selectedClass;
  bool isLoadingForClasses = false;
  String? errorMessageForClasses;

  // sessions related methods:

  Future<bool> addSession({
    required int gradeId,
    required int classId,
    required int subjectId,
    required String teacherId,
    required int dayOfWeek,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    String? room,
  }) async {
    try {
      await TimeTableRemoteDataSource().addSession(
        gradeId: gradeId,
        classId: classId,
        subjectId: subjectId,
        teacherId: teacherId,
        dayOfWeek: dayOfWeek,
        startTime: startTime,
        endTime: endTime,
        room: room,
      );

      return true;
    } catch (e) {
      errorMessageForSessions = e.toString();
      return false;
    }
  }

  Future<void> getSessions({required int gradeId, required int classId}) async {
    isLoadingForSessions = true;
    errorMessageForSessions = null;
    notifyListeners();

    try {
      sessions = await TimeTableRemoteDataSource().getSessions(
        gradeId: gradeId,
        classId: classId,
      );
    } catch (e) {
      errorMessageForSessions = e.toString();
      sessions = [];
    } finally {
      isLoadingForSessions = false;
      notifyListeners();
    }
  }

  void clearSessionsError() {
    errorMessageForSessions = null;
    notifyListeners();
  }

  // classes related methods:

  Future<void> getClasses() async {
    isLoadingForClasses = true;
    errorMessageForClasses = null;

    notifyListeners();

    try {
      final result = await GetClassesRemoteDataSource().get();

      classes = result;
    } catch (e) {
      errorMessageForClasses = e.toString();
    } finally {
      isLoadingForClasses = false;

      notifyListeners();
    }
  }

  void clearClassesError() {
    errorMessageForClasses = null;
    notifyListeners();
  }

  void clearClasses() {
    classes = [];
    notifyListeners();
  }

  void setSelectedClass(ClassModel classs) {
    selectedClass = classs;
    notifyListeners();
  }

  // Optional helpers

  List<ClassModel> getClassesByGradeId(int gradeId) {
    return classes.where((e) => e.grade?.id == gradeId).toList();
  }

  List<GradeModel> get grades {
    final Map<int, GradeModel> uniqueGrades = {};

    for (final item in classes) {
      if (item.grade != null) {
        uniqueGrades[item.grade!.id] = item.grade!;
      }
    }

    return uniqueGrades.values.toList();
  }

  Future<void> deleteSession(int sessionId) async {
    errorMessageForSessions = null;
    notifyListeners();

    try {
      await DeleteSessionRemoteDataSource().deleteSession(sessionId);
      sessions.removeWhere((session) => session.id == sessionId);
      notifyListeners();
    } catch (e) {
      errorMessageForSessions = e.toString();
      notifyListeners();
    } finally {
      notifyListeners();
    }
  }
}
