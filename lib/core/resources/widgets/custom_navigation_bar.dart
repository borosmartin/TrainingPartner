import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/constants/component_constants.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({Key? key, required this.currentIndex, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // todo color not working
    TextStyle unselected = CustomTextStyle.getCustomTextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.grey.shade600,
    );

    TextStyle selected = CustomTextStyle.getCustomTextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.tertiary,
    );

    Color unselectedIconColor = Theme.of(context).brightness == Brightness.light ? Colors.grey.shade600 : secondaryTextColors[1];

    Color selectedIconColor = Theme.of(context).colorScheme.tertiary;

    return SnakeNavigationBar.color(
      currentIndex: currentIndex,
      onTap: onTap,
      behaviour: SnakeBarBehaviour.floating,
      snakeShape: SnakeShape.indicator,
      elevation: 3,
      backgroundColor: Theme.of(context).cardColor,
      selectedItemColor: Theme.of(context).colorScheme.tertiary,
      height: 60,
      snakeViewColor: Theme.of(context).colorScheme.tertiary,
      unselectedItemColor: Theme.of(context).colorScheme.secondary,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: selected,
      unselectedLabelStyle: unselected,
      items: [
        BottomNavigationBarItem(
          label: "Home",
          icon: currentIndex == 0
              ? Icon(PhosphorIconsFill.house, size: 25, color: selectedIconColor)
              : Icon(PhosphorIconsBold.house, size: 25, color: unselectedIconColor),
        ),
        BottomNavigationBarItem(
          label: "Statistics",
          icon: currentIndex == 1
              ? Icon(PhosphorIconsFill.chartBar, size: 25, color: selectedIconColor)
              : Icon(PhosphorIconsBold.chartBar, size: 25, color: unselectedIconColor),
        ),
        BottomNavigationBarItem(
          label: "Journal",
          icon: currentIndex == 2
              ? Icon(PhosphorIconsFill.bookOpen, size: 25, color: selectedIconColor)
              : Icon(PhosphorIconsBold.bookOpen, size: 25, color: unselectedIconColor),
        ),
        BottomNavigationBarItem(
          label: "Exercises",
          icon: currentIndex == 3
              ? Icon(PhosphorIconsFill.barbell, size: 25, color: selectedIconColor)
              : Icon(PhosphorIconsBold.barbell, size: 25, color: unselectedIconColor),
        ),
      ],
    );
  }
}
