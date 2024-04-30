import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/divider_with_text.dart';
import 'package:training_partner/features/login/logic/cubits/login_cubit.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        DividerWithText(text: 'Continue with', textStyle: CustomTextStyle.bodySmallSecondary(context)),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            alignment: Alignment.center,
            elevation: 0,
            minimumSize: const Size.fromHeight(50),
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: defaultCornerShape,
          ),
          onPressed: () async => context.read<LoginCubit>().signInWithGoogle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GoogleAuthButton(
                onPressed: () {},
                style: const AuthButtonStyle(
                  iconSize: 25,
                  buttonType: AuthButtonType.icon,
                  elevation: 0,
                ),
              ),
              Text('Google account', style: CustomTextStyle.bodySecondary(context)),
            ],
          ),
        ),
      ],
    );
  }
}
