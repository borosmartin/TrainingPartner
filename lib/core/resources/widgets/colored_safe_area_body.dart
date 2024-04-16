import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColoredSafeAreaBody extends StatelessWidget {
  final Color safeAreaColor;
  final Widget child;
  final bool isLightTheme;

  const ColoredSafeAreaBody({super.key, required this.safeAreaColor, required this.child, required this.isLightTheme});

  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle style = isLightTheme ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: style.copyWith(statusBarColor: safeAreaColor),
      child: SafeArea(
        child: child,
      ),
    );
  }
}
