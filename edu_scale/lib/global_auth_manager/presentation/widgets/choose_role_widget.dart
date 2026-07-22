import 'package:edu_scale/core/themes/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChooseRoleWidget extends StatelessWidget {
  final Function(String) onRoleSelected;

  const ChooseRoleWidget({super.key, required this.onRoleSelected});

  @override
  Widget build(BuildContext context) {
    List roles = [
      {
        'name': 'student',
        'description': 'student in my school',
        'icon': CupertinoIcons.person,
      },
      {
        'name': 'parent',
        'description': 'parent of son/daughter',
        'icon': CupertinoIcons.person_2,
      },
      {
        'name': 'teacher',
        'description': 'i teach in my school',
        'icon': CupertinoIcons.briefcase,
      },
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 12),

          Text(
            'Sign in',
            style: AppStyle.theme.primaryTextTheme.titleLarge?.copyWith(
              color: AppStyle.colors.brown,
            ),
          ),
          Text(
            'Choose the role that fits you!',
            style: AppStyle.theme.primaryTextTheme.titleSmall?.copyWith(
              color: AppStyle.colors.brown,
            ),
          ),

          SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: roles.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: InkWell(
                  onTap: () {
                    onRoleSelected(roles[index]['name']);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppStyle.colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(roles[index]['icon']),
                        SizedBox(height: 8),
                        Text(roles[index]['name']),
                        SizedBox(height: 4),
                        Text(
                          roles[index]['description'],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
