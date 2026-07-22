import 'package:edu_scale/core/app_meta/app_meta.dart';
import 'package:edu_scale/core/app_meta/teacher_nav.dart';
import 'package:edu_scale/teacher/home_base/presentation/providers/teacher_nav_index_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomTeacherSideBar extends StatelessWidget {
  const CustomTeacherSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('${AppMeta.appName} Teacher'),
          Text('V ${AppMeta.appVersion}'),

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: teacherNav.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  final provider = context.read<TeacherNavIndexProvider>();
                  provider.setIndex(index);
                },
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(teacherNav[index]['label']),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
