import 'package:flutter/material.dart';
import 'package:training_partner/core/resources/firebase/auth.dart';
import 'package:training_partner/features/home/components/pages/home_page.dart';
import 'package:training_partner/features/login/components/pages/login_page.dart';

class HomePageNavigator extends StatefulWidget {
  const HomePageNavigator({super.key});

  @override
  State createState() => _HomePageNavigatorState();
}

class _HomePageNavigatorState extends State<HomePageNavigator> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        });
  }
}
