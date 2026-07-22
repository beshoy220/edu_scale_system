import 'package:edu_scale/core/app_meta/app_meta.dart';
import 'package:edu_scale/core/app_meta/student_nav.dart';
import 'package:edu_scale/student/home_base/presentation/providers/student_nav_index_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomStudentSideBar extends StatelessWidget {
  const CustomStudentSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('${AppMeta.appName} Student'),
          Text('V ${AppMeta.appVersion}'),

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: studentNav.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  final provider = context.read<StudentNavIndexProvider>();
                  provider.setIndex(index);
                },
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(studentNav[index]['label']),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
