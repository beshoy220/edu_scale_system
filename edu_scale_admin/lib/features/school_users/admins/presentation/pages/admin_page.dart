import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/core/themes/themes.dart';
import 'package:edu_scale_admin/features/school_users/admins/data/models/admin_user_model.dart';
import 'package:edu_scale_admin/features/school_users/admins/presentation/widgets/admin_custom_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/shared_components/builders/responsive_layout_builder.dart';
import '../providers/admins_list_provider.dart';

class AdminsPage extends StatefulWidget {
  const AdminsPage({super.key});

  @override
  State<AdminsPage> createState() => _AdminsPageState();
}

class _AdminsPageState extends State<AdminsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<AdminsListProvider>().loadAdmins();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppStyle.theme.primaryTextTheme;
    final adminProvider = context.watch<AdminsListProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admins'.tr(),
                    style: AppStyle.theme.primaryTextTheme.titleMedium,
                  ),

                  const SizedBox(height: 2),

                  Text(
                    'Admin users of my school'.tr(),
                    style: AppStyle.theme.primaryTextTheme.bodySmall,
                  ),
                ],
              ),

              ResponsiveLayoutBuilder(
                small: Row(
                  children: [
                    IconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: const Icon(Icons.menu),
                    ),
                  ],
                ),
                medium: Text(
                  '${adminProvider.admins.length} ${'Admins'.tr()}',
                  style: textTheme.bodyMedium,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          if (adminProvider.isLoading)
            const LinearProgressIndicator()
          else if (adminProvider.error != null)
            Text(
              adminProvider.error!,
              style: TextStyle(color: AppStyle.colors.red),
            )
          else if (adminProvider.admins.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Text(
                'Oops, no admins found yet!'.tr(),
                style: textTheme.bodyMedium,
              ),
            )
          else
            AdminCustomTable(
              fitWidth: true,
              headersText: ['Admin Name'.tr(), 'Email'.tr(), 'Phone'.tr()],
              rows: adminProvider.admins
                  .map((admin) => _buildMediumRow(admin))
                  .toList(),
            ),

          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

List<Widget> _buildMediumRow(AdminUserModel admin) {
  return [
    _TableText(admin.name),
    _TableText(admin.email),
    _TableText(admin.phone ?? 'No phone'.tr()),
  ];
}

/// =======================================================
/// TABLE CELL
/// =======================================================

class _TableText extends StatelessWidget {
  const _TableText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, overflow: TextOverflow.visible);
  }
}
