import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_meta/dashboard_items_list.dart';
import '../../../../core/themes/themes.dart';
import '../providers/dashboard_index_provider.dart';

class CustomSideBar extends StatefulWidget {
  const CustomSideBar({super.key});

  @override
  State<CustomSideBar> createState() => _CustomSideBarState();
}

class _CustomSideBarState extends State<CustomSideBar> {
  final colors = AppStyle.colors;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashBoardIndexProvider>();

    return Container(
      width: 330,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.only(),
        border: BoxBorder.fromBorderSide(BorderSide(color: colors.grey)),
      ),
      child: Column(
        children: [
          SidebarHeader(
            schoolName: 'EduScale Dashboard'.tr(),
            userName: 'Admin account'.tr(),
          ),

          const SizedBox(height: 16),
          Divider(color: colors.grey),
          const SizedBox(height: 12),

          Expanded(
            child: ListView(
              children: [
                ...dashboardItems.map((group) {
                  final items = group['items'] as List;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                        child: Text(
                          group['group'].toString().tr(),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colors.black.withValues(alpha: 0.5),
                              ),
                        ),
                      ),

                      ...items.map((item) {
                        final index = flatDashboardItems.indexOf(item);
                        final isSelected = index == provider.index;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: InkWell(
                            key: ValueKey(item['title']),
                            onTap: () => provider.setIndex(index),
                            borderRadius: BorderRadius.circular(10),
                            child: _SidebarItem(
                              icon: item['icon'],
                              text: item['title'],
                              isSelected: isSelected,
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= HEADER =================

class SidebarHeader extends StatelessWidget {
  const SidebarHeader({super.key, this.schoolName, this.userName});

  final String? schoolName;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    final textTheme = AppStyle.theme.primaryTextTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
      child: Row(
        children: [
          if (userName?.isNotEmpty ?? false)
            // Container(
            //   width: 70,
            //   height: 70,
            //   alignment: Alignment.center,
            //   decoration: BoxDecoration(
            //     color: colors.black.withValues(alpha: 0.05),
            //     borderRadius: BorderRadius.circular(24),
            //   ),
            //   child: Icon(CupertinoIcons.list_dash),
            // ),
            const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (schoolName != null)
                  Text(
                    schoolName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                if (userName != null)
                  Text(
                    userName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= ITEM =================

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.icon,
    required this.text,
    required this.isSelected,
  });

  final IconData icon;
  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = AppStyle.colors;

    final bgColor = isSelected
        ? colors.black.withValues(alpha: 0.05)
        : colors.grey.withValues(alpha: 0);
    final contentColor = isSelected ? colors.black : colors.black.withValues();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: contentColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text.tr(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: contentColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
