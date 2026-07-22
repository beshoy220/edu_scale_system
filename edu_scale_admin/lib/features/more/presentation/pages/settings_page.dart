import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/core/shared_components/builders/responsive_layout_builder.dart';
import 'package:edu_scale_admin/core/shared_pref/cached_resources.dart';
import 'package:edu_scale_admin/core/themes/themes.dart';
import 'package:edu_scale_admin/features/more/presentation/providers/settings_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/pages/sign_in_page.dart';
import '../widgets/setting_tile.dart';

// The provider needs error handling
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSchoolSettings = true;
  late var textTheme = AppStyle.theme.primaryTextTheme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Settings'.tr(), style: textTheme.titleMedium),

                  const SizedBox(height: 2),

                  Text(
                    'Settings for my school and my account'.tr(),
                    style: textTheme.bodySmall,
                  ),
                ],
              ),

              ResponsiveLayoutBuilder(
                small: IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu),
                ),
                medium: Center(),
              ),
            ],
          ),

          SizedBox(height: 18),

          // Tab row
          Row(
            children: [
              _buildTabButton('My school', isSchoolSettings),
              const SizedBox(width: 16),
              _buildTabButton('My account', !isSchoolSettings),
            ],
          ),

          SizedBox(height: 18),

          isSchoolSettings
              ? const SchoolSettingsList()
              : const MySettingsList(),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, bool isSelected) {
    return TextButton(
      onPressed: () {
        setState(() {
          isSchoolSettings = !isSchoolSettings;
        });
      },
      style: TextButton.styleFrom(
        foregroundColor: isSelected
            ? AppStyle.colors.black
            : AppStyle.colors.black.withAlpha(100),
        textStyle: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 16,
        ),
      ),
      child: Text(title.tr()),
    );
  }
}

// ------------------------- School Settings -------------------------
class SchoolSettingsList extends StatefulWidget {
  const SchoolSettingsList({super.key});

  @override
  State<SchoolSettingsList> createState() => _SchoolSettingsListState();
}

class _SchoolSettingsListState extends State<SchoolSettingsList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsProvider>().getSchoolData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, provider, child) {
        final isLoading = provider.isSchoolDataLoading;
        final schoolData = provider.schoolData;
        final hasData = schoolData.isNotEmpty;

        // Show loading
        if (isLoading) {
          return LinearProgressIndicator();
        }

        // If loading finished but no data (error / empty)
        if (!hasData) {
          return Center(
            child: Text(
              'No school data available. Pull to refresh or contact support.'
                  .tr(),
              textAlign: TextAlign.center,
            ),
          );
        }

        // Data ready – display real values
        final school = schoolData.first;
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            SettingsTile(
              icon: CupertinoIcons.cube,
              title: 'School system'.tr(),
              subtitle: 'School educational system'.tr(),
              rightSideWidget: Text(
                '${school['educational_system'].toString().tr()} ${'system'.tr()}',
              ),
            ),
            SettingsTile(
              icon: CupertinoIcons.calendar,
              title: 'Weekends'.tr(),
              subtitle: 'Weekends days of my school'.tr(),
              rightSideWidget: Text(
                (school['school_weekend'] as List?)?.join(', ') ?? 'None'.tr(),
              ),
            ),
            SettingsTile(
              icon: CupertinoIcons.person_3,
              title: 'Class capacity'.tr(),
              subtitle: 'Max student number per class'.tr(),
              rightSideWidget: Text(
                '${school['class_max_capacity']} ${'student per class'.tr()}',
              ),
            ),
          ],
        );
      },
    );
  }
}

class MySettingsList extends StatefulWidget {
  const MySettingsList({super.key});

  @override
  State<MySettingsList> createState() => _MySettingsListState();
}

class _MySettingsListState extends State<MySettingsList> {
  @override
  void initState() {
    super.initState();
    // Fetch auth data once after first frame to avoid calling during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsProvider>().getAuthData();
    });
  }

  void _signOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        constraints: BoxConstraints(minWidth: 800),
        title: Text('Sign out'.tr()),
        content: Text('Are you sure you want to sign out?'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel'.tr()),
          ),
          TextButton(
            onPressed: () async {
              // Close the confirmation dialog
              Navigator.pop(ctx);

              // Perform sign out (should be async)
              await context.read<SettingsProvider>().signOut();

              // Clear cache and navigate to sign-in page
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SignInPage()),
                );
              }
            },
            child: Text('Sign Out'.tr()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, provider, child) {
        final user = provider.authUser;

        // Show loading indicator while user data is being fetched
        if (user == null) {
          return const LinearProgressIndicator();
        }

        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            SettingsTile(
              icon: CupertinoIcons.text_aligncenter,
              title: 'Full name'.tr(),
              subtitle: 'Your registered name'.tr(),
              rightSideWidget: Text(
                user.userMetadata?['name']?.toString() ?? 'Not set'.tr(),
              ),
            ),
            SettingsTile(
              icon: CupertinoIcons.at,
              title: 'Email address'.tr(),
              subtitle: 'Your login email'.tr(),
              rightSideWidget: Text(user.email ?? 'Not set'.tr()),
            ),
            SettingsTile(
              icon: CupertinoIcons.globe,
              title: 'Language'.tr(),
              subtitle: 'Your app language'.tr(),
              rightSideWidget: DropdownMenu<String>(
                width: 200,
                enableFilter: false,
                requestFocusOnTap: false,
                initialSelection: context.locale.languageCode == 'ar'
                    ? 'Arabic'
                    : 'English',
                dropdownMenuEntries: [
                  DropdownMenuEntry(value: 'English', label: 'English'.tr()),
                  DropdownMenuEntry(value: 'Arabic', label: 'Arabic'.tr()),
                ],
                onSelected: (selectedLang) async {
                  if (selectedLang == 'Arabic') {
                    await context.setLocale(const Locale('ar', 'EG'));
                    CachedResources.setAppLanguageToEnglish(false);
                  } else {
                    await context.setLocale(const Locale('en', 'US'));
                    CachedResources.setAppLanguageToEnglish(true);
                  }
                },
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _signOut(context),
              icon: const Icon(Icons.logout),
              label: Text('Sign Out'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyle.colors.red,
                foregroundColor: AppStyle.colors.surface,
                minimumSize: const Size(double.infinity, 48),
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(8),
                // ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
