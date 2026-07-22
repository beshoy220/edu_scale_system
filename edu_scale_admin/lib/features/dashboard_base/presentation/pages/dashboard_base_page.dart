import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/core/app_meta/dashboard_display_content_list.dart';
import 'package:edu_scale_admin/core/themes/themes.dart';
import 'package:edu_scale_admin/features/dashboard_base/presentation/widgets/custom_drawer.dart';
import 'package:edu_scale_admin/features/dashboard_base/presentation/widgets/custom_side_bar.dart';
import 'package:provider/provider.dart';
import '../../../../core/shared_components/builders/responsive_layout_builder.dart';
import 'package:flutter/material.dart';
import '../providers/dashboard_index_provider.dart';

class DashboardBasePage extends StatelessWidget {
  const DashboardBasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: DashboardBaseSmallView(),
      medium: DashboardBaseMediumView(),
    );
  }
}

class DashboardBaseSmallView extends StatelessWidget {
  const DashboardBaseSmallView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashBoardIndexProvider>();

    return Scaffold(
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                dashboardDisplayContent[provider.index],
                SizedBox(height: 58),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.maxFinite,
              color: AppStyle.colors.grey,
              padding: EdgeInsets.all(16),
              child: Text(
                'We recommend using desktop to access the dashboard for better experience.'
                    .tr(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardBaseMediumView extends StatelessWidget {
  const DashboardBaseMediumView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashBoardIndexProvider>();

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSideBar(),
          Expanded(child: dashboardDisplayContent[provider.index]),
        ],
      ),
    );
  }
}
