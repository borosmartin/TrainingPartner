import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:training_partner/core/constants/component_constants.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({Key? key, required this.currentIndex, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SnakeNavigationBar.color(
      currentIndex: currentIndex,
      onTap: onTap,
      behaviour: SnakeBarBehaviour.floating,
      snakeShape: SnakeShape.circle,
      shape: defaultCornerShape,
      padding: const EdgeInsets.all(15),
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.primary,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      snakeViewColor: Theme.of(context).colorScheme.tertiary,
      unselectedItemColor: Colors.black45,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        // todo find icon with outline
        BottomNavigationBarItem(
          label: "Exercises",
          icon: currentIndex == 0 ? const Icon(Icons.fitness_center, size: 25) : const Icon(Icons.fitness_center_outlined, size: 25),
        ),
        BottomNavigationBarItem(
          label: "Workout",
          icon: currentIndex == 1 ? const Icon(Icons.play_arrow, size: 30) : const Icon(Icons.play_arrow_outlined, size: 30),
        ),
        BottomNavigationBarItem(
          label: "Home",
          icon: currentIndex == 2 ? const Icon(Icons.home, size: 25) : const Icon(Icons.home_outlined, size: 25),
        ),
        BottomNavigationBarItem(
          label: "Statistics",
          icon: currentIndex == 3 ? const Icon(Icons.pie_chart, size: 25) : const Icon(Icons.pie_chart_outline, size: 25),
        ),
        // todo find icon with outline
        BottomNavigationBarItem(
          label: "Journal",
          icon: currentIndex == 4 ? const Icon(Icons.menu_book_rounded, size: 25) : const Icon(Icons.menu_book_outlined, size: 25),
        ),
      ],
    );
  }
}
