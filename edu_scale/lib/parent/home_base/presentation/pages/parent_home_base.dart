import 'package:edu_scale/core/app_meta/parent_nav.dart';
import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/parent/home_base/presentation/providers/parent_nav_index_provider.dart';
import 'package:edu_scale/parent/home_base/presentation/widgets/custom_parent_side_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParentHomeBase extends StatelessWidget {
  const ParentHomeBase({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ParentNavIndexProvider>();

    return AppStyle.deviceSize.isMobile(context)
        ? SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    parentNav[provider.index]['page'],
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
                        icon: Icon(parentNav[0]['icon']),
                        label: parentNav[0]['label'],
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(parentNav[1]['icon']),
                        label: parentNav[1]['label'],
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(parentNav[2]['icon']),
                        label: parentNav[2]['label'],
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(parentNav[3]['icon']),
                        label: parentNav[3]['label'],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : SafeArea(
            child: Scaffold(
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: CustomParentSideBar()),
                  Expanded(flex: 3, child: parentNav[provider.index]['page']),
                ],
              ),
            ),
          );
  }
}
