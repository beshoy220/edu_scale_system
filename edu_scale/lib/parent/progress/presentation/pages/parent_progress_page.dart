// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/parent/progress/presentation/providers/parent_progress_provider.dart';
import 'package:edu_scale/parent/progress/presentation/widgets/parent_progress_info_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParentProgressPage extends StatefulWidget {
  const ParentProgressPage({super.key});

  @override
  State<ParentProgressPage> createState() => _ParentProgressPageState();
}

class _ParentProgressPageState extends State<ParentProgressPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ParentProgressProvider>().getProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    final progressProvider = context.watch<ParentProgressProvider>();

    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.fromLTRB(18, 18, 18, 32),

              decoration: BoxDecoration(
                color: AppStyle.colors.brown,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(48),
                  bottomRight: Radius.circular(48),
                ),

                image: DecorationImage(
                  alignment: Alignment.topRight,
                  image: AssetImage('assets/pics/shape_4.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  if (progressProvider.progress != null)
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: AppStyle.colors.surface,
                          ),
                        ),

                        Spacer(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppStyle.colors.grey,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Text(
                                '${progressProvider.progress!.points ~/ 100} Level',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),

                            SizedBox(width: 4),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppStyle.colors.grey,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '${progressProvider.progress?.currentStreak ?? 0}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.local_fire_department,
                                    color: AppStyle.colors.orange,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 4),

                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    return ParentProgressInfoBottomSheet();
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppStyle.colors.grey,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Icon(
                                  CupertinoIcons.exclamationmark_circle,
                                  color: AppStyle.colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                  SizedBox(height: 80),

                  if (progressProvider.progress != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${progressProvider.progress?.points ?? 0}',
                          style: AppStyle.theme.primaryTextTheme.titleLarge
                              ?.copyWith(
                                color: AppStyle.colors.surface,
                                fontSize: 38,
                              ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Points',
                          style: TextStyle(color: AppStyle.colors.surface),
                        ),
                      ],
                    ),

                  if (progressProvider.progress != null)
                    Text(
                      '${(100 - (progressProvider.progress?.points ?? 0 % 100)) % 100} points to reach level next level, Whooh!',
                      style: TextStyle(color: AppStyle.colors.surface),
                    ),

                  SizedBox(height: 80),
                ],
              ),
            ),

            SizedBox(height: 12),

            Container(
              margin: EdgeInsets.all(12),
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                color: AppStyle.colors.orange,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                'Badges My Child Achieved',
                style: TextStyle(
                  color: AppStyle.colors.surface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            if (progressProvider.progress != null &&
                progressProvider.progress!.userBadges.isNotEmpty)
              ListView.builder(
                itemCount: progressProvider.progress!.userBadges.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppStyle.colors.grey,
                          border: Border.all(
                            color: AppStyle.colors.black.withAlpha(50),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          // image: DecorationImage(
                          //   alignment: Alignment.topRight,
                          //   image: NetworkImage('url'),
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                        child: Icon(
                          CupertinoIcons.rosette,
                          size: 32,
                          color: AppStyle.colors.yellow,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              progressProvider
                                  .progress!
                                  .userBadges[index]
                                  .badge
                                  .name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              progressProvider
                                  .progress!
                                  .userBadges[index]
                                  .badge
                                  .description,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

            if (progressProvider.progress != null &&
                progressProvider.progress!.userBadges.isEmpty)
              Text('No badges achieved yet!'),
          ],
        ),
      ),
    );
  }
}
