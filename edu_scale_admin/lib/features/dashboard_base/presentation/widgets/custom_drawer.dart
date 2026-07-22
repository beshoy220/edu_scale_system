import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/features/dashboard_base/presentation/providers/dashboard_index_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_meta/dashboard_items_list.dart';
import '../../../../core/themes/themes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashBoardIndexProvider>();

    return Drawer(
      backgroundColor: AppStyle.colors.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: 12),

          CustomDrawerHeader(
            title: 'EduScale Dashboard'.tr(),
            subTitle: 'Admin account'.tr(),
          ),

          SizedBox(height: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: dashboardItems.map((group) {
              final items = group['items'] as List;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                    child: Text(
                      group['group'].toString().tr(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppStyle.colors.black.withValues(alpha: 0.5),
                      ),
                    ),
                  ),

                  ...items.map(
                    (item) => ListTile(
                      leading: Icon(
                        item['icon'],
                        // color: AppStyle.colors.black.withValues(alpha: 0.6),
                      ),
                      title: Text(
                        item['title'].toString().tr(),
                        style: TextStyle(color: AppStyle.colors.black),
                      ),
                      onTap: () {
                        provider.setIndex(flatDashboardItems.indexOf(item));
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({super.key, this.title, this.subTitle});

  final String? title;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = AppStyle.theme.primaryTextTheme;
    final appColors = AppStyle.colors;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          if (subTitle != null && subTitle!.isNotEmpty)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: appColors.grey,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.admin_panel_settings_outlined),
            ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  Text(
                    title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (subTitle != null)
                  Text(
                    subTitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyle.theme.textTheme.bodyMedium!.copyWith(
                      color: AppStyle.colors.black.withValues(alpha: 0.6),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
