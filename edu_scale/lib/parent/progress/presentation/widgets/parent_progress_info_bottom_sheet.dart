import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/parent/progress/presentation/providers/parent_available_badges_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParentProgressInfoBottomSheet extends StatefulWidget {
  const ParentProgressInfoBottomSheet({super.key});

  @override
  State<ParentProgressInfoBottomSheet> createState() =>
      _ParentProgressInfoBottomSheetState();
}

class _ParentProgressInfoBottomSheetState
    extends State<ParentProgressInfoBottomSheet> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ParentAvailableBadgesProvider>().getBadges();
    });
  }

  @override
  Widget build(BuildContext context) {
    final badgesProvider = context.watch<ParentAvailableBadgesProvider>();

    return Container(
      height: AppStyle.deviceSize.currentDeviceSize(context).height * 0.8,
      decoration: BoxDecoration(
        color: AppStyle.colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'How Progress Works',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.bolt, color: AppStyle.colors.orange),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Earn Points by engaging with your learning activities.',
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.trending_up, color: AppStyle.colors.orange),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text('Every 100 points earns a new level.'),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: AppStyle.colors.orange,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Stay active at least once every week to keep your streak alive.',
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.workspace_premium,
                          color: AppStyle.colors.orange,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Unlock badges by reaching learning milestones and achievements.',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 18),

              Text(
                'Why Progress?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'You may have wondered, "Isn\'t this an educational app? Why does it have points, levels, streaks, and badges? Isn\'t that for games?"\n\nWe believe learning is a journey. By adding these elements, we\'re not turning education into a game—we\'re making the journey more engaging, motivating, and enjoyable for every student as a part of our mission.',
              ),

              SizedBox(height: 18),

              Text('All Badges', style: TextStyle(fontWeight: FontWeight.bold)),

              if (badgesProvider.isLoading)
                Center(child: LinearProgressIndicator()),

              if (badgesProvider.errorMessage != null)
                Center(child: Text(badgesProvider.errorMessage!)),

              if (badgesProvider.badges.isEmpty)
                const Center(child: Text('No badges available')),

              if (badgesProvider.badges.isNotEmpty)
                ListView.builder(
                  itemCount: badgesProvider.badges.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final badge = badgesProvider.badges[index];

                    return Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppStyle.colors.grey,
                            border: Border.all(
                              color: AppStyle.colors.black.withAlpha(50),
                              width: 2,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(24),
                            ),
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
                                badge.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(badge.description),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
