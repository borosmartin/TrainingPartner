import 'package:fluttertoast/fluttertoast.dart';
import 'package:training_partner/core/resources/widgets/custom_toast.dart';

void showErrorToast(FToast toast, String message) {
  toast.showToast(
    child: CustomToast(message: message, type: ToastType.error),
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 3),
  );
}

void showSuccessToast(FToast toast, String message) {
  toast.showToast(
    child: CustomToast(message: message, type: ToastType.success),
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 3),
  );
}

void showWarningToast(FToast toast, String message) {
  toast.showToast(
    child: CustomToast(message: message, type: ToastType.warning),
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 3),
  );
}
