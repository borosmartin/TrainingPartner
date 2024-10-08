import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/globals/component_functions.dart';
import 'package:training_partner/core/resources/firebase/auth_service.dart';
import 'package:training_partner/core/resources/widgets/custom_input_field.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/core/resources/widgets/custom_toast.dart';

class PasswordResetDialog extends StatefulWidget {
  const PasswordResetDialog({super.key});

  @override
  State<PasswordResetDialog> createState() => _PasswordResetDialogState();
}

class _PasswordResetDialogState extends State<PasswordResetDialog> {
  final FocusNode _focusNodeEmail = FocusNode();

  final TextEditingController _controllerEmail = TextEditingController();

  FToast toast = FToast();

  @override
  void initState() {
    super.initState();

    toast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNodeEmail.unfocus(),
      child: Dialog(
        elevation: 0,
        shape: defaultCornerShape,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.mail_lock_rounded),
                    const SizedBox(width: 10),
                    Text('Password reset', style: CustomTextStyle.subtitlePrimary(context)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Here you can provide your email adress, and we will send you a link to reset your password:',
                  style: CustomTextStyle.bodySmallSecondary(context),
                ),
                const SizedBox(height: 20),
                CustomInputField(
                  labelText: 'Email',
                  inputController: _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'example@gmail.com',
                  focusNode: _focusNodeEmail,
                ),
                const SizedBox(height: 20),
                CustomTitleButton(
                  label: 'Request',
                  onTap: _controllerEmail.text.isEmpty
                      ? () async {
                          _focusNodeEmail.unfocus();
                          await Future.delayed(const Duration(milliseconds: 200));
                          if (mounted) {
                            showBottomToast(
                              context: context,
                              message: 'Please enter your email!',
                              type: ToastType.error,
                            );
                          }
                        }
                      : _sendPasswordResetEmail,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendPasswordResetEmail() async {
    _focusNodeEmail.unfocus();

    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await AuthService().sendPasswordResetEmail(email: _controllerEmail.text.trim());

      if (mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();

        showBottomToast(
          context: context,
          message: 'Password reset email sent!',
          type: ToastType.success,
        );
      }
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        if (error.code == 'user-not-found') {
          showBottomToast(
            context: context,
            message: 'No user found with the given email.',
            type: ToastType.error,
          );
        } else if (error.code == 'invalid-email') {
          showBottomToast(
            context: context,
            message: 'Invalid email format.',
            type: ToastType.error,
          );
        } else {
          showBottomToast(
            context: context,
            message: 'An error occurred. Please try again later.',
            type: ToastType.error,
          );
        }

        Navigator.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _focusNodeEmail.dispose();
    _controllerEmail.dispose();
  }
}
