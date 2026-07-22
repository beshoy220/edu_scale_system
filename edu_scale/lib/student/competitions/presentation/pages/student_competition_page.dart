import 'dart:math';

import 'package:edu_scale/core/themes/themes.dart';
import 'package:flutter/material.dart';

class StudentCompetitionPage extends StatefulWidget {
  const StudentCompetitionPage({super.key});

  @override
  State<StudentCompetitionPage> createState() => _StudentCompetitionPageState();
}

class _StudentCompetitionPageState extends State<StudentCompetitionPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new),
          ),
          title: const Text('Competition'),
        ),
        body: Stack(
          children: [
            Positioned(
              bottom: -30,
              left: -20,
              child: Opacity(
                opacity: .12,
                child: Image.asset('assets/pics/happy_winner.png', width: 230),
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Spacer(),

                    AnimatedBuilder(
                      animation: controller,
                      builder: (_, child) {
                        return Transform.translate(
                          offset: Offset(
                            0,
                            sin(controller.value * pi * 2) * 10,
                          ),
                          child: child,
                        );
                      },
                      child: SizedBox(
                        width: 160,
                        height: 160,
                        child: Icon(
                          Icons.emoji_events_rounded,
                          size: 90,
                          color: AppStyle.colors.yellow,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    Text(
                      'The Arena is\nBeing Prepared',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).primaryTextTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      'Soon you\'ll challenge classmates,\ncollect rewards, earn points and climb\nleaderboards.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).primaryTextTheme.bodyMedium
                          ?.copyWith(color: Colors.black54, height: 1.5),
                    ),

                    const SizedBox(height: 45),

                    Row(
                      children: const [
                        Expanded(
                          child: _FeatureCard(
                            icon: Icons.flash_on,
                            color: Color(0xffFFBD19),
                            title: 'Live\nBattles',
                          ),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: _FeatureCard(
                            icon: Icons.workspace_premium,
                            color: Color(0xff58CC02),
                            title: 'Point\nRewards',
                          ),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: _FeatureCard(
                            icon: Icons.groups,
                            color: Color(0xff1CB0F6),
                            title: 'Team\nPlay',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    FadeTransition(
                      opacity: Tween(begin: .3, end: 1.0).animate(controller),
                      child: Text(
                        'Coming Soon...',
                        style: Theme.of(context).primaryTextTheme.bodyLarge
                            ?.copyWith(
                              color: AppStyle.colors.brown,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),

                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;

  const _FeatureCard({
    required this.icon,
    required this.color,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color.withOpacity(.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 15),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).primaryTextTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
