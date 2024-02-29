import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:training_partner/core/globals/component_functions.dart';
import 'package:training_partner/core/resources/firebase/auth_service.dart';
import 'package:training_partner/core/resources/widgets/custom_navigation_bar.dart';
import 'package:training_partner/features/exercises/components/pages/exercise_type_page.dart';
import 'package:training_partner/features/home/components/pages/home_page.dart';
import 'package:training_partner/features/journal/components/pages/journal_page.dart';
import 'package:training_partner/features/login/components/widgets/login_signup_navigator.dart';
import 'package:training_partner/features/statistics/components/pages/statistics_page.dart';

class HomePageNavigator extends StatefulWidget {
  const HomePageNavigator({super.key});

  @override
  State createState() => _HomePageNavigatorState();
}

class _HomePageNavigatorState extends State<HomePageNavigator> {
  int _selectedIndex = 0;
  late PageController _pageController;
  var pages = [
    const HomePage(),
    const StatisticsPage(),
    const JournalPage(),
    const ExerciseTypePage(),
  ];

  // todo load every data than pass it to the pages
  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    colorSafeArea(color: Theme.of(context).colorScheme.background);

    return StreamBuilder<User?>(
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: Scaffold(
                bottomNavigationBar: CustomBottomNavigationBar(currentIndex: _selectedIndex, onTap: onItemTapped),
                body: PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    return pages[index];
                  },
                ),
              ),
            );
          } else {
            return const LoginSignupNavigator();
          }
        });
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
