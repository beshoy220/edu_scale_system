import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/teacher/attendance/data/models/teacher_attendance_classes_list_model.dart';
import 'package:edu_scale/teacher/attendance/presentation/pages/teacher_attendance_students_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/teacher_attendance_provider.dart';

class TeacherAttendancePage extends StatefulWidget {
  const TeacherAttendancePage({super.key});

  @override
  State<TeacherAttendancePage> createState() => _TeacherAttendancePageState();
}

class _TeacherAttendancePageState extends State<TeacherAttendancePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeacherAttendanceProvider>().getClassesBySchoolId();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TeacherAttendanceProvider>();

    final groupedClasses = <String, List<TeacherAttendanceClassesListModel>>{};

    for (final item in provider.classesList) {
      groupedClasses.putIfAbsent(item.gradeName, () => []);
      groupedClasses[item.gradeName]!.add(item);
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new),
              ),
              SizedBox(width: 4),
              const Text('Attendance'),
            ],
          ),
        ),
        body: Builder(
          builder: (_) {
            if (provider.isLoading) {
              return LinearProgressIndicator();
            }

            if (provider.errorMessage != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    provider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppStyle.colors.red),
                  ),
                ),
              );
            }

            if (provider.classesList.isEmpty) {
              return const Center(
                child: Text(
                  'No classes found.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groupedClasses.length,
              itemBuilder: (context, gradeIndex) {
                final gradeName = groupedClasses.keys.elementAt(gradeIndex);
                final classes = groupedClasses[gradeName]!;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gradeName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...classes.map(
                        (item) => InkWell(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TeacherAttendanceStudentsPage(
                                  gradeId: item.gradeId,
                                  classId: item.classId,
                                  title:
                                      '${item.gradeName} - ${item.classNickname}',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 4),

                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(18),
                            //   color: AppStyle.colors.grey,
                            // ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    color: AppStyle.colors.grey,
                                  ),

                                  child: Icon(CupertinoIcons.person_3),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item.gradeName} - ${item.classNickname}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text('Click to view students'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
