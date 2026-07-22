import 'package:edu_scale/core/app_meta/student_nav.dart';
import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/student/home_base/presentation/providers/student_nav_index_provider.dart';
import 'package:edu_scale/student/home_base/presentation/widgets/custom_student_side_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentHomeBase extends StatelessWidget {
  const StudentHomeBase({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentNavIndexProvider>();

    return AppStyle.deviceSize.isMobile(context)
        ? SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    studentNav[provider.index]['page'],
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
                        icon: Icon(studentNav[0]['icon']),
                        label: studentNav[0]['label'],
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(studentNav[1]['icon']),
                        label: studentNav[1]['label'],
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(studentNav[2]['icon']),
                        label: studentNav[2]['label'],
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(studentNav[3]['icon']),
                        label: studentNav[3]['label'],
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(studentNav[4]['icon']),
                        label: studentNav[4]['label'],
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
                Expanded(child: CustomStudentSideBar()),
                Expanded(flex: 3, child: studentNav[provider.index]['page']),
              ],
            ),
          );
  }
}
