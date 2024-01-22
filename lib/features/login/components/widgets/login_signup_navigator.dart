import 'package:flutter/material.dart';
import 'package:training_partner/features/login/components/pages/login_page.dart';
import 'package:training_partner/features/login/components/pages/sign_up_page.dart';

class LoginSignupNavigator extends StatefulWidget {
  const LoginSignupNavigator({super.key});

  @override
  State<LoginSignupNavigator> createState() => _LoginSignupNavigatorState();
}

class _LoginSignupNavigatorState extends State<LoginSignupNavigator> {
  bool showLoginPage = true;

  @override
  Widget build(BuildContext context) {
    return showLoginPage ? LoginPage(onTap: _changePage) : SignUpPage(onTap: _changePage);
  }

  void _changePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
}
