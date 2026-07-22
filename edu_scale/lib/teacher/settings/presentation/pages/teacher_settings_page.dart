import 'package:edu_scale/global_auth_manager/presentation/pages/account_manager_page.dart';
import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/teacher/settings/presentation/widgets/teacher_setting_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TeacherSettingsPage extends StatefulWidget {
  const TeacherSettingsPage({super.key});

  @override
  State<TeacherSettingsPage> createState() => _TeacherSettingsPageState();
}

class _TeacherSettingsPageState extends State<TeacherSettingsPage> {
  @override
  Widget build(BuildContext context) {
    List<String> languages = ['English', 'Arabic'];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(height: 12),

            TeacherSettingCard(
              leadingIcon: CupertinoIcons.person,
              title: 'Account Manager',
              description: 'Go to account manager.',
              callToActionWidget: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyle.colors.surface, // Button color
                  foregroundColor: AppStyle.colors.black, // Text & icon color
                  textStyle: TextStyle(fontWeight: FontWeight.bold),
                  padding: EdgeInsets.all(12),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          const AccountManagerPage(),
                    ),
                  );
                },
                child: Text('Go'),
              ),
            ),

            SizedBox(height: 12),

            TeacherSettingCard(
              leadingIcon: CupertinoIcons.globe,
              title: 'Language',
              description: 'Change The application Language.',
              callToActionWidget: DropdownMenu<String>(
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: AppStyle.colors.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                width: 140,
                enableFilter: false,
                requestFocusOnTap: false,
                initialSelection: languages.first,

                dropdownMenuEntries: languages
                    .map(
                      (language) =>
                          DropdownMenuEntry(value: language, label: language),
                    )
                    .toList(),
                onSelected: (selected) {
                  setState(() {
                    debugPrint(selected);
                  });
                },
              ),
            ),

            SizedBox(height: 12),

            TeacherSettingCard(
              leadingIcon: CupertinoIcons.question_circle,
              title: 'Help & Support',
              description: 'For reporting any issues or technical problems.',
              callToActionWidget: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyle.colors.surface, // Button color
                  foregroundColor: AppStyle.colors.black, // Text & icon color
                  textStyle: TextStyle(fontWeight: FontWeight.bold),
                  padding: EdgeInsets.all(12),
                ),
                onPressed: () {},
                child: Text('Support'),
              ),
            ),

            SizedBox(height: 12),

            TeacherSettingCard(
              leadingIcon: CupertinoIcons.phone,
              title: 'Contact',
              description: 'For any issues, suggestions or connecting with us.',
              callToActionWidget: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyle.colors.surface, // Button color
                  foregroundColor: AppStyle.colors.black, // Text & icon color
                  textStyle: TextStyle(fontWeight: FontWeight.bold),
                  padding: EdgeInsets.all(12),
                ),
                onPressed: () {},
                child: Text('Contact'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
