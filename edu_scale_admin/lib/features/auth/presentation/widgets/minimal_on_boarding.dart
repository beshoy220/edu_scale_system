import 'dart:async';
import 'package:edu_scale_admin/core/themes/themes.dart';
import 'package:flutter/material.dart';

class MinimalOnBoarding extends StatefulWidget {
  const MinimalOnBoarding({super.key});

  @override
  State<MinimalOnBoarding> createState() => _MinimalOnBoardingState();
}

class _MinimalOnBoardingState extends State<MinimalOnBoarding> {
  final PageController _controller = PageController();

  int currentPage = 0;
  Timer? timer;

  final List<String> images = [
    'https://images.unsplash.com/photo-1519389950473-47ba0277781c',
    'https://images.unsplash.com/photo-1519389950473-47ba0277781c',
    'https://images.unsplash.com/photo-1519389950473-47ba0277781c',
  ];

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_controller.hasClients) return;

      currentPage++;

      if (currentPage >= images.length) {
        currentPage = 0;
      }

      _controller.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );

      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.network(
                    images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              );
            },
          ),
        ),

        /// Bottom Indicator
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: 10,
                width: currentPage == index ? 32 : 10,
                decoration: BoxDecoration(
                  color: AppStyle.colors.black.withAlpha(100),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
