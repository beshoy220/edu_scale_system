import 'package:edu_scale/global_auth_manager/presentation/pages/on_boarding_page.dart';
import 'package:edu_scale/core/themes/themes.dart';
import 'package:flutter/material.dart';

/// First screen the user sees: pick the app language.
/// Navigates to [OnboardingScreen] on "Next".
class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  // Index of the selected language: 0 = English, 1 = Arabic.
  int _selectedIndex = 0;

  final List<String> _languages = const ['English', 'Arabic'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.colors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              // Globe icon at the top
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                child: Icon(
                  Icons.language,
                  size: 48,
                  color: AppStyle.colors.black,
                ),
              ),
              const SizedBox(height: 16),

              Text('Language', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                'Please specify the language that you want\nthe app to work with.',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Language options list
              ...List.generate(_languages.length, (index) {
                final isSelected = _selectedIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _LanguageOptionTile(
                    label: _languages[index],
                    isSelected: isSelected,
                    onTap: () => setState(() => _selectedIndex = index),
                  ),
                );
              }),

              const Spacer(),

              // Bottom "Next" button
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text('Next'),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const OnBoardingPage(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A single selectable language row (globe icon + label).
class _LanguageOptionTile extends StatelessWidget {
  const _LanguageOptionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppStyle.colors.black.withAlpha(20)
              : AppStyle.colors.grey,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppStyle.colors.black : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.language, size: 22, color: AppStyle.colors.black),
            const SizedBox(width: 12),
            Text(label),
          ],
        ),
      ),
    );
  }
}
