import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:popover/popover.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/globals/component_functions.dart';
import 'package:training_partner/core/resources/firebase/auth_service.dart';
import 'package:training_partner/core/resources/widgets/custom_input_field.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/core/resources/widgets/divider_with_text.dart';
import 'package:training_partner/features/login/components/widgets/new_password_dialog.dart';
import 'package:training_partner/features/login/logic/cubits/login_cubit.dart';
import 'package:training_partner/features/login/logic/states/login_state.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();

  bool doRemember = false;
  bool isObscure = true;
  FToast toast = FToast();

  @override
  void initState() {
    super.initState();

    context.read<LoginCubit>().getRememberedUserList();
    toast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      if (state is RememberedUsersLoaded) {
        return SafeArea(
          child: GestureDetector(
            onTap: () {
              _focusNodeEmail.unfocus();
              _focusNodePassword.unfocus();
            },
            child: Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: SizedBox(
                          height: 200,
                          child: Lottie.asset('assets/animations/dumbbells.json', repeat: false),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.waving_hand_outlined),
                            SizedBox(width: 10),
                            Text('Welcome back!', style: boldNormalBlack),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomInputField(
                        labelText: 'Email',
                        hintText: 'example@gmail.com',
                        keyboardType: TextInputType.emailAddress,
                        inputController: _controllerEmail,
                        focusNode: _focusNodeEmail,
                      ),
                      const SizedBox(height: 15),
                      CustomInputField(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        focusNode: _focusNodePassword,
                        trailing: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: IconButton(
                            icon: isObscure
                                ? Icon(Icons.visibility_rounded, color: Colors.grey.shade600)
                                : Icon(Icons.visibility_off_rounded, color: Colors.grey.shade600),
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: isObscure,
                        inputController: _controllerPassword,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 25,
                            width: 25,
                            child: Checkbox(
                              activeColor: Theme.of(context).colorScheme.tertiary,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              value: doRemember,
                              onChanged: (newValue) {
                                setState(() {
                                  doRemember = !doRemember;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text('Remember me', style: smallGrey),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => const NewPasswordDialog(),
                              );
                            },
                            child: const Text('Forgot password?', style: smallAccen),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomTitleButton(
                        label: 'Sign in',
                        onTap: _signInWithEmailAndPassword,
                      ),
                      const SizedBox(height: 50),
                      const DividerWithText(text: 'Continue with', textStyle: smallGrey),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GoogleAuthButton(
                            onPressed: _signInWithGoogle,
                            style: const AuthButtonStyle(
                              height: 70,
                              width: 70,
                              iconSize: 35,
                              buttonType: AuthButtonType.icon,
                              elevation: 0,
                            ),
                          ),
                          const SizedBox(width: 20),
                          FacebookAuthButton(
                            // todo
                            onPressed: () {},
                            style: const AuthButtonStyle(
                              height: 70,
                              width: 70,
                              iconSize: 35,
                              buttonType: AuthButtonType.icon,
                              elevation: 0,
                            ),
                          ),
                          const SizedBox(width: 20),
                          TwitterAuthButton(
                            // todo
                            onPressed: () {},
                            style: const AuthButtonStyle(
                              height: 70,
                              width: 70,
                              iconSize: 35,
                              buttonType: AuthButtonType.icon,
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 70),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account yet?", style: smallGrey),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text('Sign up', style: smallAccen),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }

  // todo valami itt nem az igazi
  Future<void> _signInWithEmailAndPassword() async {
    _focusNodeEmail.unfocus();
    _focusNodePassword.unfocus();

    if (_controllerEmail.text.isEmpty || _controllerPassword.text.isEmpty) {
      showErrorToast(toast, 'Please fill your email and password!');
    } else {
      showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        await AuthService().signInWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
        );

        if (mounted) {
          Navigator.of(context).pop();
        }
      } on FirebaseAuthException catch (error) {
        if (error.code == 'invalid-credential') {
          showErrorToast(toast, 'Invalid credentials, please try again!');
        } else if (error.code == 'invalid-email') {
          showErrorToast(toast, 'Incorrect email format, please try again!');
        } else if (error.code == 'wrong-password') {
          showErrorToast(toast, 'Incorrect password, please try again!');
        } else if (error.code == 'user-not-found') {
          showErrorToast(toast, 'No user found with that email!');
        } else {
          showErrorToast(toast, 'An error occurred. Please try again later!');
        }

        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await AuthService().signInWithGoogle();

      if (mounted) {
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (error) {
      if (error.message != null) {
        showErrorToast(toast, error.message!);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  //todo finish
  void _showRememberedUsers(BuildContext context) {
    showPopover(
      context: context,
      direction: PopoverDirection.bottom,
      width: 200,
      height: 400,
      arrowHeight: 15,
      arrowWidth: 30,
      bodyBuilder: (context) => const Column(
        children: [
          Text('example', style: smallAccen),
          Text('example', style: smallAccen),
          Text('example', style: smallAccen),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();

    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    super.dispose();
  }
}
