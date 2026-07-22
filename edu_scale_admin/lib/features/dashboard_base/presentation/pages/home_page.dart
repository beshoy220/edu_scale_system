import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/core/shared_components/builders/responsive_layout_builder.dart';
import 'package:edu_scale_admin/features/dashboard_base/presentation/providers/dashboard_index_provider.dart';
import 'package:edu_scale_admin/features/dashboard_base/presentation/widgets/overall_statistics_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/themes/themes.dart';
import '../../../community/presentation/pages/community_dialog_page.dart';
import '../providers/auth_data_provider.dart';
import '../providers/school_statistics_provider.dart';
import '../widgets/home_stat_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SchoolStatisticsProvider>().getStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SchoolStatisticsProvider>();
    final authProvider = context.watch<AuthDataProvider>();
    final user = authProvider.currentUserData();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: AppStyle.colors.grey,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.admin_panel_settings_outlined,
                  color: Colors.black38,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${'Good morning admin'.tr()} ${user!.userMetadata!['name']}',
                      style: AppStyle.theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Admin account'.tr(),
                      style: AppStyle.theme.textTheme.bodyMedium!.copyWith(
                        color: AppStyle.colors.black.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),

              ResponsiveLayoutBuilder(
                small: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(CupertinoIcons.chat_bubble_2),
                    ),
                    IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(Icons.menu),
                    ),
                  ],
                ),
                medium: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyle.colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const CommunityDialogPage(),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.chat_bubble_2,
                        color: AppStyle.colors.surface,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Community'.tr(),
                        style: AppStyle.theme.primaryTextTheme.bodyMedium
                            ?.copyWith(color: AppStyle.colors.surface),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (provider.isLoading)
            LinearProgressIndicator()
          else if (provider.errorMessage != null)
            Text(
              provider.errorMessage!,
              style: TextStyle(color: AppStyle.colors.onRed),
            )
          else if (provider.statistics == null)
            Text(
              'Ops, no data available'.tr(),
              style: TextStyle(color: AppStyle.colors.red),
            )
          else if (provider.statistics != null)
            if (provider.statistics != null) ...[
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        context.read<DashBoardIndexProvider>().setIndex(1);
                      },
                      hoverColor: Colors.transparent,
                      child: HomeStatCard(
                        icon: CupertinoIcons.person,
                        title: 'Students'.tr(),
                        value: provider.statistics!.users.students.total
                            .toString(),
                        subtitle:
                            '${provider.statistics!.users.students.active} ${'active students'.tr()}\n${provider.statistics!.users.students.pending} ${'pending students'.tr()}\n${provider.statistics!.users.students.suspended} ${'suspended students'.tr()}',
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        context.read<DashBoardIndexProvider>().setIndex(2);
                      },
                      hoverColor: Colors.transparent,
                      child: HomeStatCard(
                        icon: CupertinoIcons.person_2,
                        title: 'Parents'.tr(),
                        value: provider.statistics!.users.parents.total
                            .toString(),
                        subtitle:
                            '${provider.statistics!.users.parents.active} ${'active parents'.tr()}\n${provider.statistics!.users.parents.pending} ${'pending parents'.tr()}\n${provider.statistics!.users.parents.suspended} ${'suspended parents'.tr()}',
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        context.read<DashBoardIndexProvider>().setIndex(3);
                      },
                      hoverColor: Colors.transparent,
                      child: HomeStatCard(
                        icon: CupertinoIcons.briefcase,
                        title: 'Teachers'.tr(),
                        value: provider.statistics!.users.teachers.total
                            .toString(),
                        subtitle:
                            '${provider.statistics!.users.teachers.active} ${'active teachers'.tr()}\n${provider.statistics!.users.teachers.pending} ${'pending teachers'.tr()}\n${provider.statistics!.users.teachers.suspended} ${'suspended teachers'.tr()}',
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              OverallStatisticsCard(),
            ],

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
