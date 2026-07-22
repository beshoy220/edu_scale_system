import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/features/auth/presentation/pages/sign_in_page.dart';
import 'package:flutter/material.dart';
import '../../../../core/shared_components/builders/responsive_layout_builder.dart';
import '../widgets/minimal_on_boarding.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: OnBoardingSmallView(),
      medium: OnBoardingMediumView(),
    );
  }
}

class OnBoardingSmallView extends StatefulWidget {
  const OnBoardingSmallView({super.key});

  @override
  State<OnBoardingSmallView> createState() => _OnBoardingSmallViewState();
}

class _OnBoardingSmallViewState extends State<OnBoardingSmallView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.maxFinite,
              height: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: MinimalOnBoarding(),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EduScale Admin Dashboard'.tr(),
                    style: theme.primaryTextTheme.titleLarge,
                  ),

                  const SizedBox(height: 12),
                  Text(
                    'Manage your school efficiently with powerful tools and analytics and unlock a new eara of eduaction.'
                        .tr(),
                    style: theme.primaryTextTheme.bodyMedium,
                  ),

                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInPage(),
                          ),
                        );
                      },
                      child: Text('Start Now'.tr()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnBoardingMediumView extends StatelessWidget {
  const OnBoardingMediumView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          /// LEFT SIDE
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EduScale Admin Dashboard'.tr(),
                    style: theme.primaryTextTheme.titleLarge,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Manage your school efficiently with powerful tools and analytics and unlock a new eara of eduaction.'
                        .tr(),
                    style: theme.primaryTextTheme.bodyLarge,
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: 220,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInPage(),
                          ),
                        );
                      },
                      child: Text('Start Now'.tr()),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// RIGHT SIDE
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  topLeft: Radius.circular(32),
                ),
              ),
              child: MinimalOnBoarding(),
            ),
          ),
        ],
      ),
    );
  }
}
