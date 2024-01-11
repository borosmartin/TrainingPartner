import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const BottomNavBar({Key? key, required this.currentIndex, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
        BottomNavigationBarItem(label: "Journal", icon: Icon(Icons.menu_book_rounded)),
        BottomNavigationBarItem(label: "Workoutplans", icon: Icon(Icons.list)),
        BottomNavigationBarItem(label: "Statistics", icon: Icon(Icons.pie_chart)),
      ],
    );
  }
}
