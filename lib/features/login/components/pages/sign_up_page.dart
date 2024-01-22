import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/globals/component_functions.dart';
import 'package:training_partner/core/resources/firebase/auth_service.dart';
import 'package:training_partner/core/resources/widgets/custom_input_field.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/core/resources/widgets/divider_with_text.dart';

class SignUpPage extends StatefulWidget {
  final Function()? onTap;
  const SignUpPage({super.key, this.onTap});

  @override
  State createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerPasswordConfirm = TextEditingController();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodePasswordConfirm = FocusNode();

  bool isObscure = true;
  FToast toast = FToast();

  @override
  void initState() {
    super.initState();
    toast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          _focusNodeEmail.unfocus();
          _focusNodePassword.unfocus();
          _focusNodePasswordConfirm.unfocus();
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
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
                        Icon(Icons.person_outline),
                        SizedBox(width: 10),
                        Text('Create a new account:', style: boldNormalBlack),
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
                  const SizedBox(height: 15),
                  CustomInputField(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm your password',
                    focusNode: _focusNodePasswordConfirm,
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
                    inputController: _controllerPasswordConfirm,
                  ),
                  const SizedBox(height: 40),
                  CustomTitleButton(
                    label: 'Sign up',
                    onTap: _createUserWithEmailAndPassword,
                  ),
                  const SizedBox(height: 30),
                  const DividerWithText(text: 'Continue with', textStyle: smallGrey),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?", style: smallGrey),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text('Sign in', style: smallAccen),
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

  Future<void> _createUserWithEmailAndPassword() async {
    _focusNodeEmail.unfocus();
    _focusNodePassword.unfocus();
    _focusNodePasswordConfirm.unfocus();

    try {
      if (_controllerEmail.text.isEmpty || _controllerPassword.text.isEmpty || _controllerPasswordConfirm.text.isEmpty) {
        showErrorToast(toast, 'Please fill all the fields!');
      } else if (_controllerPassword.text != _controllerPasswordConfirm.text) {
        showErrorToast(toast, 'Passwords do not match!');
      } else if (_controllerPassword.text.length < 6) {
        showErrorToast(toast, 'Password must be at least 6 characters!');
      } else {
        showDialog(
          context: context,
          builder: (context) => const Center(child: CircularProgressIndicator()),
        );

        await AuthService().createUserWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
        );

        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (error) {
      if (error.message != null) {
        showErrorToast(toast, error.message!);
      }

      Navigator.of(context).pop();
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await AuthService().signInWithGoogle();

      Navigator.of(context).pop();
    } on FirebaseAuthException catch (error) {
      if (error.message != null) {
        showErrorToast(toast, error.message!);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerPasswordConfirm.dispose();

    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    _focusNodePasswordConfirm.dispose();
    super.dispose();
  }
}
