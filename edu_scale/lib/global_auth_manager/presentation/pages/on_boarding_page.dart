import 'package:edu_scale/global_auth_manager/presentation/pages/sign_in_page.dart';
import 'package:edu_scale/core/themes/themes.dart';

import 'package:flutter/material.dart';

/// Data model for each "feature" slide (the 4 pages that show
/// the EduScale badge, an illustration, progress dashes, title & description).
class OnboardingSlideData {
  const OnboardingSlideData({
    required this.imageAsset,
    required this.title,
    required this.description,
    required this.bgColor,
  });

  final String imageAsset;
  final String title;
  final String description;
  final Color bgColor;
}

/// Full onboarding flow: 1 welcome page + N feature slides.
/// Wrap this in a PageView so the user can swipe or tap through.
class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // ---- EDIT THESE: swap in your real asset paths & copy ----
  final List<OnboardingSlideData> _slides = [
    OnboardingSlideData(
      imageAsset: 'assets/pics/calm_girl.png',
      title: 'Lorem ipsum',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla imperdiet.',
      bgColor: Color(0xFFE5EAD7),
    ),
    OnboardingSlideData(
      imageAsset: 'assets/pics/hands_hold_heart.png',
      title: 'Lorem ipsum',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla imperdiet.',
      bgColor: AppStyle.colors.blue,
    ),
    OnboardingSlideData(
      imageAsset: 'assets/pics/reading_girl.png',
      title: 'Lorem ipsum',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla imperdiet.',
      bgColor: AppStyle.colors.onOrange.withAlpha(40),
    ),
    OnboardingSlideData(
      imageAsset: 'assets/pics/happy_ropot.png',
      title: 'Lorem ipsum',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla imperdiet.',
      bgColor: AppStyle.colors.grey,
    ),
  ];

  // Total pages = 1 welcome page + all feature slides.
  int get _pageCount => _slides.length + 1;

  void _goToNextPage() {
    if (_currentPage < _pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _onOnboardingComplete();
    }
  }

  void _onOnboardingComplete() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const SignInPage()));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.colors.surface,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) => setState(() => _currentPage = index),
          children: [
            _WelcomePage(onNext: _goToNextPage),
            ..._slides.asMap().entries.map(
              (entry) => _FeatureSlidePage(
                data: entry.value,
                currentIndex: entry.key,
                totalSlides: _slides.length,
                onNext: _goToNextPage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Welcome page: avatar circle, title, illustration with floating icons.
// ---------------------------------------------------------------------------
class _WelcomePage extends StatelessWidget {
  const _WelcomePage({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 16),

          // Avatar placeholder circle
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppStyle.colors.brown,
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/pics/logo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Welcome to EduScale',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Lorem ipsum dolor sit amet, consectetur\nadipiscing elit. Nulla imperdiet. 🌿',
            textAlign: TextAlign.center,
            // style: AppTextStyles.body,
          ),

          // Text(AppStyle.deviceSize.currentDeviceSize(context).toString()),
          const SizedBox(height: 24),

          // Illustration
          Expanded(
            child: Image.asset(
              width: 300,
              height: 300,
              'assets/pics/happy_girl.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: onNext,
                child: Text('Seems impressive'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Feature slide page (used 4x): badge + illustration + dashes + copy.
// ---------------------------------------------------------------------------
class _FeatureSlidePage extends StatelessWidget {
  const _FeatureSlidePage({
    required this.data,
    required this.currentIndex,
    required this.totalSlides,
    required this.onNext,
  });

  final OnboardingSlideData data;
  final int currentIndex;
  final int totalSlides;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Illustration block.
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(data.imageAsset),
                fit: BoxFit.fitWidth,
                onError: (_, __) {},
              ),
              color: data.bgColor,
            ),
          ),
        ),

        // Progress dashes just under the illustration.
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: _ProgressDashes(
            currentIndex: currentIndex,
            totalCount: totalSlides,
          ),
        ),

        // Title + description + button.
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(data.title, style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  data.description,
                  textAlign: TextAlign.center,
                  // style: AppTextStyles.body,
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: onNext,
                      child: Text('Seems impressive'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Row of dash segments indicating progress through the feature slides.
/// The active dash is dark, the rest are light grey.
class _ProgressDashes extends StatelessWidget {
  const _ProgressDashes({required this.currentIndex, required this.totalCount});

  final int currentIndex;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalCount, (index) {
        final isActive = index == currentIndex;
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: index == totalCount - 1 ? 0 : 6),
            decoration: BoxDecoration(
              color: isActive ? AppStyle.colors.brown : AppStyle.colors.grey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}

/// Fallback placeholder shown if an illustration asset is missing,
/// so the layout still looks reasonable during development.
class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: AppStyle.colors.grey,
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, size: 48),
    );
  }
}
