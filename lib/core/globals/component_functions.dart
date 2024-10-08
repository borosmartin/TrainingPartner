import 'package:flutter/material.dart';
import 'package:training_partner/core/resources/widgets/custom_toast.dart';

void showBottomToast({required BuildContext context, required String message, required ToastType type}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: CustomToast(message: message, type: type),
    ),
  );
}
