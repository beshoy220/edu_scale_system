import 'package:edu_scale/global_auth_manager/data/models/updated_user_model.dart';
import 'package:edu_scale/global_auth_manager/presentation/providers/sign_in_provider.dart';
import 'package:edu_scale/core/supabase_service/supabase_auth_service.dart';
import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/parent/home_base/presentation/pages/parent_home_base.dart';
import 'package:edu_scale/student/home_base/presentation/pages/student_home_base.dart';
import 'package:edu_scale/teacher/home_base/presentation/pages/teacher_home_base.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// This widget is catastrophic and needs to be refactored ASAP
// But it works well to be honest
class SignInWidget extends StatefulWidget {
  final String role;
  const SignInWidget({super.key, required this.role});

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  List<String> gender = ['choose gender', 'male', 'female'];

  String? selectedGender;
  DateTime selectedDate = DateTime.now();

  int currentStep = 0;

  UpdatedUserModel? userDataAfterSignIn;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      if (selectedGender == null ||
          selectedGender == 'choose gender' ||
          selectedDate.year == DateTime.now().year) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please make sure to choose gender and your birthday date',
            ),
            backgroundColor: AppStyle.colors.red,
          ),
        );
      } else {
        final provider = context.read<SignInProvider>();

        final success = await provider.signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (success) {
          if (!mounted) return;
          final provider = context.read<SignInProvider>();

          final userData = await provider.updateUserData(
            SupabaseAuthService().currentUser!.id,
            selectedGender!,
            selectedDate,
          );

          debugPrint('Data: $userData');

          setState(() {
            currentStep = 1;
            userDataAfterSignIn = userData!;
          });
        } else if (provider.error != null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(provider.error.toString()),
              backgroundColor: AppStyle.colors.red,
            ),
          );
        }
      }
    }
  }

  void _handleCachingSignInAccount() {
    final provider = context.read<SignInProvider>();

    // Save accout to the AccountManager (to cache its data)
    provider.saveCacheAccount(userDataAfterSignIn!, _passwordController.text);
    setState(() {
      currentStep = 2;
    });

    // print(userDataAfterSignIn);
  }

  void _handleNavigation() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            SupabaseAuthService().currentUser!.appMetadata['role'] == 'student'
            ? StudentHomeBase()
            : SupabaseAuthService().currentUser!.appMetadata['role'] == 'parent'
            ? ParentHomeBase()
            : TeacherHomeBase(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome ${widget.role}!',
                style: AppStyle.theme.primaryTextTheme.titleMedium?.copyWith(
                  color: AppStyle.colors.brown,
                ),
              ),

              Text(
                'Please fill and check the following feild carefully',
                style: AppStyle.theme.primaryTextTheme.bodySmall?.copyWith(
                  color: AppStyle.colors.brown,
                ),
              ),

              SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(3, (index) {
                  return Container(
                    width: (MediaQuery.of(context).size.width - 48) / 3,
                    height: 4,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: index <= currentStep
                          ? AppStyle.colors.brown
                          : AppStyle.colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              SizedBox(height: 24),

              (currentStep == 0)
                  ? Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            onFieldSubmitted: (_) => _handleSignIn(),
                            decoration: InputDecoration(
                              hintText: 'Enter your email..',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: 'Enter your password..',
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
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 8),
                          DropdownMenu<String>(
                            width: 200,
                            enableFilter: false,
                            requestFocusOnTap: false,
                            initialSelection: gender.first,
                            dropdownMenuEntries: gender
                                .map(
                                  (gender) => DropdownMenuEntry(
                                    value: gender,
                                    label: gender,
                                  ),
                                )
                                .toList(),
                            onSelected: (selected) {
                              setState(() {
                                selectedGender = selected;
                                // print(selectedGender);
                              });
                            },
                          ),

                          SizedBox(height: 8),
                          InkWell(
                            onTap: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(1940),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  selectedDate = pickedDate;
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppStyle.colors.grey,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              child: Text(
                                (selectedDate.year == DateTime.now().year)
                                    ? 'Birthday date'
                                    : '${selectedDate.toLocal().year} - ${selectedDate.toLocal().month} - ${selectedDate.toLocal().day}',
                              ),
                            ),
                          ),

                          SizedBox(height: 24),
                        ],
                      ),
                    )
                  : (currentStep == 1)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'User Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Text('Role: ${userDataAfterSignIn!.role}'),
                        Text('Name: ${userDataAfterSignIn!.name}'),
                        Text('Email: ${userDataAfterSignIn!.email}'),
                        if (userDataAfterSignIn!.phone != null)
                          Text('Phone: ${userDataAfterSignIn!.phone}'),
                        if (userDataAfterSignIn!.gender != null)
                          Text('Gender: ${userDataAfterSignIn!.gender}'),
                        if (userDataAfterSignIn!.birthday != null)
                          Text(
                            'Birthday: ${userDataAfterSignIn!.birthday!.year} -  ${userDataAfterSignIn!.birthday!.month} -  ${userDataAfterSignIn!.birthday!.day}',
                          ),
                        SizedBox(height: 12),
                        Text(
                          'Please, If you found any missed or wrong info contact your school IT',
                          style: TextStyle(color: AppStyle.colors.red),
                        ),
                      ],
                    )
                  : Text('Whooh, We are directing to home page now.....!'),
            ],
          ),
        ),
        Align(
          alignment: AlignmentGeometry.bottomCenter,
          child: SizedBox(
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: () {
                if (currentStep == 0) {
                  _handleSignIn();
                } else if (currentStep == 1) {
                  _handleCachingSignInAccount();
                } else {
                  _handleNavigation();
                }
              },
              child: Text('Next'),
            ),
          ),
        ),
      ],
    );
  }
}
