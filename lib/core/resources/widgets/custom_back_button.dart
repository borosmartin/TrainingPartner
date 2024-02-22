import 'dart:io';

import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final Color? color;
  final Widget? dialog;

  const CustomBackButton({super.key, this.color, this.dialog});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => dialog != null ? showDialog(context: context, builder: (context) => dialog!) : Navigator.pop(context),
      icon: _getIcon(),
    );
  }

  Widget _getIcon() {
    if (Platform.isIOS) {
      return Icon(Icons.arrow_back_ios, color: color ?? Colors.black);
    } else {
      return Icon(Icons.arrow_back, color: color ?? Colors.black);
    }
  }
}
