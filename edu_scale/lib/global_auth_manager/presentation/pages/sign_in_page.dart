import 'package:edu_scale/global_auth_manager/presentation/widgets/choose_role_widget.dart';
import 'package:edu_scale/global_auth_manager/presentation/widgets/sign_in_widget.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool doesUserChoosedRole = false;
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: doesUserChoosedRole
              ? selectedRole != null
                    ? SignInWidget(role: selectedRole as String)
                    : Text(
                        'Opps, During choosing user\'s role something went wrong!\nPlease try again later or contact your school IT',
                      )
              : ChooseRoleWidget(
                  onRoleSelected: (role) {
                    setState(() {
                      selectedRole = role;
                      doesUserChoosedRole = true;
                    });
                  },
                ),
        ),
      ),
    );
  }
}
