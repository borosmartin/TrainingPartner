import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:training_partner/core/resources/firebase/auth_service.dart';
import 'package:training_partner/core/resources/widgets/custom_small_button.dart';
import 'package:training_partner/features/home/components/widgets/profile_widget.dart';
import 'package:training_partner/features/home/components/widgets/week_view_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User _user = AuthService().currentUser!;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 35),
        Row(
          children: [
            ProfileWidget(user: _user),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                children: [
                  CustomSmallButton(
                    label: 'Logout',
                    icon: const Icon(Icons.logout_rounded),
                    onTap: _signOut,
                  ),
                  const SizedBox(height: 35),
                  CustomSmallButton(
                    label: 'Settings',
                    icon: const Icon(Icons.settings_rounded),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const WeekViewWidget(),
      ],
    );
  }

  Future<void> _signOut() async {
    await AuthService().signOut();
  }
}
