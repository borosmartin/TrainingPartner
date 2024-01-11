import 'package:flutter/material.dart';
import 'package:training_partner/core/resources/widgets/header.dart';
import 'package:training_partner/core/resources/widgets/traning_bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        bottomNavigationBar: BottomNavBar(currentIndex: _selectedIndex, onTap: onItemTapped),
        body: _getBodyContent(),
      ),
    );
  }

  Widget _getBodyContent() {
    return const Column(
      children: [
        Header(),
      ],
    );
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
