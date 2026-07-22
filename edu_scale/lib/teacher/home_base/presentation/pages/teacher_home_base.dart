import 'package:edu_scale/core/app_meta/teacher_nav.dart';
import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/teacher/home_base/presentation/providers/teacher_nav_index_provider.dart';
import 'package:edu_scale/teacher/home_base/presentation/widgets/custom_teacher_side_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherHomeBase extends StatelessWidget {
  const TeacherHomeBase({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TeacherNavIndexProvider>();

    return AppStyle.deviceSize.isMobile(context)
        ? SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    teacherNav[provider.index]['page'],
                    const SizedBox(height: 58),
                  ],
                ),
              ),

              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppStyle.colors.black.withAlpha(30),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, -4), // Shadow above the bar
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                  child: BottomNavigationBar(
                    currentIndex: provider.index,
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: AppStyle.colors.brown,
                    unselectedItemColor: AppStyle.colors.black.withAlpha(150),
                    showUnselectedLabels: true,
                    backgroundColor: AppStyle.colors.surface,

                    onTap: (index) {
                      provider.setIndex(index);
                    },

                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(teacherNav[0]['icon']),
                        label: teacherNav[0]['label'],
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(teacherNav[1]['icon']),
                        label: teacherNav[1]['label'],
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(teacherNav[2]['icon']),
                        label: teacherNav[2]['label'],
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(teacherNav[3]['icon']),
                        label: teacherNav[3]['label'],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: CustomTeacherSideBar()),
                Expanded(flex: 3, child: teacherNav[provider.index]['page']),
              ],
            ),
          );
  }
}
