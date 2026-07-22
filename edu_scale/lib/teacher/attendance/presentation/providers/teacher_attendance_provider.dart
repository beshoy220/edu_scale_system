import 'package:edu_scale/teacher/attendance/data/data_sources/teacher_attandance_classes_list_remote_data_list.dart';
import 'package:edu_scale/teacher/attendance/data/models/teacher_attendace_student_model.dart';
import 'package:edu_scale/teacher/attendance/data/models/teacher_attendance_classes_list_model.dart';
import 'package:flutter/material.dart';

class TeacherAttendanceProvider extends ChangeNotifier {
  final TeacherAttendanceRemoteDataSource _dataSource =
      TeacherAttendanceRemoteDataSource();

  bool isLoading = false;
  bool hasUnsavedChanges = false;

  String? errorMessage;

  List<TeacherAttendanceClassesListModel> classesList = [];
  List<TeacherAttendanceStudentModel> studentsList = [];

  /// Only students that changed.
  final List<TeacherAttendanceStudentModel> modifiedStudents = [];

  Future<void> getClassesBySchoolId() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      classesList = await _dataSource.getClassesBySchoolId();
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> getStudentsByClassId(int classId) async {
    isLoading = true;
    errorMessage = null;

    hasUnsavedChanges = false;
    modifiedStudents.clear();

    notifyListeners();

    try {
      studentsList = await _dataSource.getStudentsAttendanceByClassId(
        classId: classId,
      );
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  /// Cycles:
  /// null -> present -> absent -> late -> excused -> present...
  void changeAttendance(int index) {
    final student = studentsList[index];

    String? newStatus;

    switch (student.attendanceStatus) {
      case null:
        newStatus = 'present';
        break;

      case 'present':
        newStatus = 'absent';
        break;

      case 'absent':
        newStatus = 'late';
        break;

      case 'late':
        newStatus = 'excused';
        break;

      default:
        newStatus = 'present';
    }

    final updated = TeacherAttendanceStudentModel(
      studentId: student.studentId,
      studentName: student.studentName,
      avatarUrl: student.avatarUrl,
      attendanceId: student.attendanceId,
      attendanceStatus: newStatus,
      attendanceReason: student.attendanceReason,
    );

    studentsList[index] = updated;

    _markStudentAsModified(updated);

    hasUnsavedChanges = true;

    notifyListeners();
  }

  /// Makes everyone present.
  void attendAll() {
    for (int i = 0; i < studentsList.length; i++) {
      final student = studentsList[i];

      final updated = TeacherAttendanceStudentModel(
        studentId: student.studentId,
        studentName: student.studentName,
        avatarUrl: student.avatarUrl,
        attendanceId: student.attendanceId,
        attendanceStatus: 'present',
        attendanceReason: student.attendanceReason,
      );

      studentsList[i] = updated;

      _markStudentAsModified(updated);
    }

    hasUnsavedChanges = true;

    notifyListeners();
  }

  void _markStudentAsModified(TeacherAttendanceStudentModel student) {
    modifiedStudents.removeWhere((e) => e.studentId == student.studentId);

    modifiedStudents.add(student);
  }

  Future<void> saveAttendance(int gradeId, int classId) async {
    if (modifiedStudents.isEmpty) return;

    isLoading = true;
    notifyListeners();

    try {
      await _dataSource.saveAttendance(gradeId, classId, modifiedStudents);

      modifiedStudents.clear();
      hasUnsavedChanges = false;
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void clearStudents() {
    studentsList.clear();
    modifiedStudents.clear();
    hasUnsavedChanges = false;
    notifyListeners();
  }

  void clear() {
    classesList.clear();
    studentsList.clear();
    modifiedStudents.clear();

    hasUnsavedChanges = false;
    errorMessage = null;
    isLoading = false;

    notifyListeners();
  }
}
