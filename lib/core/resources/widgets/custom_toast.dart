import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/utils/text_util.dart';

enum ToastType { success, error, warning }

class CustomToast extends StatelessWidget {
  final String message;
  final ToastType type;
  const CustomToast({super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: defaultBorderRadius,
          color: _getBackgroundColor(),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _getIcon(),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                message,
                style: TextUtil.getCustomTextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case ToastType.success:
        return Colors.green;
      case ToastType.error:
        return Colors.red;
      case ToastType.warning:
        return Colors.orange;
      default:
        return Colors.black;
    }
  }

  Icon _getIcon() {
    switch (type) {
      case ToastType.success:
        return const Icon(Icons.check, color: Colors.white);
      case ToastType.error:
        return const Icon(Icons.error, color: Colors.white);
      case ToastType.warning:
        return const Icon(Icons.warning, color: Colors.white);
      default:
        return const Icon(Icons.info, color: Colors.white);
    }
  }
}
