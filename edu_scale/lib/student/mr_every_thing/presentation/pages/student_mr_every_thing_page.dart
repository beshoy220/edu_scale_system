import 'dart:math';

import 'package:edu_scale/core/themes/themes.dart';
import 'package:flutter/material.dart';

class StudentMrEveryThingPage extends StatefulWidget {
  const StudentMrEveryThingPage({super.key});

  @override
  State<StudentMrEveryThingPage> createState() =>
      _StudentMrEveryThingPageState();
}

class _StudentMrEveryThingPageState extends State<StudentMrEveryThingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  final shortcuts = const [
    (Icons.assignment_rounded, 'Assignment'),
    (Icons.quiz_rounded, 'Quiz'),
    (Icons.bar_chart_rounded, 'Attendance'),
    (Icons.auto_graph_rounded, 'Grades'),
    (Icons.add, 'More'),
  ];

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

  void openMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppStyle.colors.surface,
      showDragHandle: true,
      builder: (_) {
        return GridView.builder(
          padding: const EdgeInsets.all(20),
          shrinkWrap: true,
          itemCount: shortcuts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 1.4,
          ),
          itemBuilder: (_, i) {
            final item = shortcuts[i];

            return Container(
              decoration: BoxDecoration(
                color: AppStyle.colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.$1, color: AppStyle.colors.blue, size: 32),
                  const SizedBox(height: 10),
                  Text(item.$2),
                ],
              ),
            );
          },
        );
      },
    );
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
          title: const Text('Mr. EveryThing'),
        ),
        body: Stack(
          children: [
            // Positioned(
            //   top: 20,
            //   right: -20,
            //   child: IgnorePointer(
            //     child: Opacity(
            //       opacity: .08,
            //       child: Image.asset('assets/pics/shape_.png', width: 220),
            //     ),
            //   ),
            // ),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 25),

                        AnimatedBuilder(
                          animation: controller,
                          builder: (_, child) {
                            return Transform.translate(
                              offset: Offset(
                                0,
                                sin(controller.value * pi * 2) * 8,
                              ),
                              child: child,
                            );
                          },
                          child: Image.asset(
                            'assets/pics/happy_ropot_2.png',
                            width: 200,
                            height: 200,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          'Meet Mr. Everything',
                          style: Theme.of(context).primaryTextTheme.titleMedium,
                        ),

                        const SizedBox(height: 8),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            'Your personal AI tutor. Soon I\'ll solve assignments, explain quizzes, analyze attendance, answer math questions and much more.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).primaryTextTheme.bodyMedium
                                ?.copyWith(color: Colors.black54),
                          ),
                        ),

                        const SizedBox(height: 25),

                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.all(18),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Text(
                            '👋 Hi!\n\nI\'m getting ready. Soon you\'ll be able to:\n\n'
                            '• Solve assignments\n'
                            '• Explain quizzes\n'
                            '• Analyze attendance\n'
                            '• Generate charts\n'
                            '• Answer any school question\n'
                            '• And much more!',
                          ),
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: shortcuts.length,
                            itemBuilder: (_, i) {
                              final item = shortcuts[i];

                              return Container(
                                width: 90,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.04),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(item.$1, color: AppStyle.colors.blue),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.$2,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),

                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Row(
                      children: [
                        IconButton.filledTonal(
                          onPressed: openMenu,
                          icon: const Icon(Icons.add),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Ask Mr. Everything...',
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        IconButton.filled(
                          onPressed: () {},
                          icon: const Icon(Icons.send),
                        ),
                      ],
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
