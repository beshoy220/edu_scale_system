import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/progress_manager/progress_manager.dart';
import 'package:edu_scale/core/themes/themes.dart';
import 'package:flutter/material.dart';

class GainPointsRewardPage extends StatefulWidget {
  final int points;

  const GainPointsRewardPage({super.key, required this.points});

  @override
  State<GainPointsRewardPage> createState() => _GainPointsRewardPageState();
}

class _GainPointsRewardPageState extends State<GainPointsRewardPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<int> _pointsAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _pointsAnimation = IntTween(
      begin: 0,
      end: widget.points,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final currentUser = await AccountManager.currentAccount();

      await ProgressManager.addPoints(currentUser!.id, widget.points);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppStyle.colors.orange,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/pics/bg_pic_2.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: AppStyle.deviceSize.currentDeviceSize(context).width,
                  height:
                      AppStyle.deviceSize.currentDeviceSize(context).height / 2,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/pics/calm_girl_2.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Text(
                  'Great job!',
                  style: AppStyle.theme.primaryTextTheme.titleLarge?.copyWith(
                    color: AppStyle.colors.surface,
                  ),
                ),

                /// Animated Points
                AnimatedBuilder(
                  animation: _pointsAnimation,
                  builder: (context, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '+${_pointsAnimation.value}',
                          style: AppStyle.theme.primaryTextTheme.titleLarge
                              ?.copyWith(
                                color: AppStyle.colors.surface,
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          ' Points',
                          style: AppStyle.theme.primaryTextTheme.bodyLarge
                              ?.copyWith(color: AppStyle.colors.surface),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Next!'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
