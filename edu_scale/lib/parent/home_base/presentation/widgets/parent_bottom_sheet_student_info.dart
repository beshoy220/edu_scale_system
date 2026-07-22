import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/parent/home_base/presentation/providers/parent_student_info_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParentBottomSheetStudentInfo extends StatefulWidget {
  const ParentBottomSheetStudentInfo({super.key});

  @override
  State<ParentBottomSheetStudentInfo> createState() =>
      _ParentBottomSheetStudentInfoState();
}

class _ParentBottomSheetStudentInfoState
    extends State<ParentBottomSheetStudentInfo> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final currentUser = await AccountManager.currentAccount();

      if (!mounted) return;
      context.read<ParentStudentInfoProvider>().getStudentInfoByStudentId(
        currentUser!.ids.studentId!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ParentStudentInfoProvider>();

    return SizedBox(
      height: 520,
      child: Column(
        children: [
          const SizedBox(height: 12),

          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Student Information',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),

          const SizedBox(height: 24),

          if (provider.isLoading)
            LinearProgressIndicator()
          else if (provider.errorMessage != null)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    provider.errorMessage!,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          else if (provider.student == null)
            const Expanded(child: Center(child: Text('No student found')))
          else
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: AppStyle.colors.grey,
                      backgroundImage: provider.student!.avatarUrl != null
                          ? NetworkImage(provider.student!.avatarUrl!)
                          : null,
                      child: provider.student!.avatarUrl == null
                          ? const Icon(CupertinoIcons.person, size: 42)
                          : null,
                    ),

                    const SizedBox(height: 18),

                    Text(
                      provider.student!.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    _InfoTile(
                      icon: CupertinoIcons.mail,
                      title: 'Email',
                      value: provider.student!.email,
                    ),

                    _InfoTile(
                      icon: CupertinoIcons.phone,
                      title: 'Phone',
                      value: provider.student!.phone ?? '-',
                    ),

                    _InfoTile(
                      icon: CupertinoIcons.person_2,
                      title: 'Gender',
                      value: provider.student!.gender ?? '-',
                    ),

                    _InfoTile(
                      icon: CupertinoIcons.check_mark_circled,
                      title: 'Status',
                      value: provider.student!.status,
                    ),

                    _InfoTile(
                      icon: CupertinoIcons.calendar,
                      title: 'Birthday',
                      value: provider.student!.birthday == null
                          ? '-'
                          : '${provider.student!.birthday!.day}/${provider.student!.birthday!.month}/${provider.student!.birthday!.year}',
                    ),

                    SizedBox(height: 38),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppStyle.colors.grey,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
