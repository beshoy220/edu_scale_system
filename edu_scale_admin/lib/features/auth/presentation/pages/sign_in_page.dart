import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/core/themes/themes.dart';
import 'package:edu_scale_admin/features/auth/data/data_sources/cache/cache.dart';
import 'package:edu_scale_admin/features/auth/data/data_sources/remote/get_school_status.dart';
import 'package:edu_scale_admin/features/auth/presentation/pages/set_school_page.dart';
import 'package:edu_scale_admin/features/dashboard_base/presentation/pages/dashboard_base_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sign_in_provider.dart';

// This Screen Does not follow same patterns like in others and i think we may need to refactor it.
// Refactor notes:
// 1] Too much logic in UI to handel!
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Color.fromARGB(255, 69, 10, 10),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 30),
        action: SnackBarAction(
          label: 'Dismiss'.tr(),
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<SignInProvider>();

      final success = await provider.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).clearSnackBars();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Checking school environment....'.tr())),
        );

        String email = _emailController.text;

        // Check if the school setted up before (active school)
        final schoolData = await GetSchoolStatus.get(email);
        bool isSchoolActive = schoolData['status'] == 'active';

        // Set cache ressources
        Cache.setSchoolId(schoolData['id'].toString());
        Cache.setSchoolDomain(schoolData['school_domain']);

        if (!mounted) return;
        ScaffoldMessenger.of(context).clearSnackBars();

        if (isSchoolActive) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => DashboardBasePage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => SetSchoolPage()),
          );
        }
      } else if (provider.errorMessage != null) {
        _showErrorSnackBar(provider.errorMessage!);
        provider.resetError();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 1200;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 450,
          vertical: 24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 132),
              Text(
                'Welcome Admin'.tr(),
                style: AppStyle.theme.primaryTextTheme.titleMedium,
              ),
              Text('Sign in to continue!'.tr()),
              const SizedBox(height: 32),

              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                // textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Enter your email..'.tr(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email'.tr();
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email'.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _handleSignIn(),
                decoration: InputDecoration(
                  hintText: 'Enter your password..'.tr(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password'.tr();
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters'.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Sign In Button
              Consumer<SignInProvider>(
                builder: (context, provider, child) {
                  return SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: provider.isLoading ? null : _handleSignIn,
                      child: provider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              'Sign In'.tr(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
