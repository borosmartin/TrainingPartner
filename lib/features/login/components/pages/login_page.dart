import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/globals/component_functions.dart';
import 'package:training_partner/core/resources/widgets/custom_input_field.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/core/resources/widgets/divider_with_text.dart';
import 'package:training_partner/features/login/components/widgets/password_reset_dialog.dart';
import 'package:training_partner/features/login/logic/cubits/login_cubit.dart';
import 'package:training_partner/features/login/logic/states/login_state.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool isObscure = true;
  FToast toast = FToast();

  @override
  void initState() {
    super.initState();

    toast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginFailed) {
          showErrorToast(toast, state.message);
        } else if (state is LoginInProgress) {
          showDialog(
            context: context,
            builder: (context) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is LoginSuccessful) {
          Navigator.of(context).pop();
        }
      },
      child: _getBodyContent(),
    );
  }

  Widget _getBodyContent() {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          _emailFocusNode.unfocus();
          _passwordFocusNode.unfocus();
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
                    inputController: _emailController,
                    focusNode: _emailFocusNode,
                  ),
                  const SizedBox(height: 15),
                  CustomInputField(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    focusNode: _passwordFocusNode,
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
                    inputController: _passwordController,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => const PasswordResetDialog(),
                          );
                        },
                        child: const Text('Forgot password?', style: smallAccent),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomTitleButton(
                    label: 'Sign in',
                    onTap: () => _signInWithEmailAndPassword(),
                  ),
                  const SizedBox(height: 50),
                  const DividerWithText(text: 'Continue with', textStyle: smallGrey),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GoogleAuthButton(
                        onPressed: () async => context.read<LoginCubit>().signInWithGoogle(),
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
                        child: const Text('Sign up', style: smallAccent),
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
  }

  void _signInWithEmailAndPassword() {
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showErrorToast(toast, 'Please fill your email and password!');
    } else {
      context.read<LoginCubit>().signInWithEmailAndPassword(_emailController.text, _passwordController.text);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
