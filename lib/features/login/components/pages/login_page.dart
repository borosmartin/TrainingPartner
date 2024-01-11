import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:training_partner/core/resources/firebase/auth.dart';
import 'package:training_partner/core/resources/widgets/input_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // TODO handle errors
  String? errormassage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(
                height: 150,
                child: Icon(Icons.lock_open, size: 90),
              ),
              InputField(
                labelText: 'Email',
                hintText: 'Enter your email',
                inputController: _controllerEmail,
              ),
              InputField(
                labelText: 'Password',
                hintText: 'Enter your password',
                inputController: _controllerPassword,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: ElevatedButton(
                  onPressed: isLogin ? _signInWithEmailAndPassword : _createUserWithEmailAndPassword,
                  child: Text(isLogin ? 'LOGIN' : 'REGISTER'),
                ),
              ),
              TextButton(
                onPressed: () => setState(() {
                  isLogin = !isLogin;
                }),
                child: Text(isLogin ? 'Register instead' : 'Login instead'),
              ),
              GoogleAuthButton(
                onPressed: _signInWithGoogle,
                style: const AuthButtonStyle(
                  buttonType: AuthButtonType.icon,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errormassage = e.message;
      });
    }
  }

  Future<void> _createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errormassage = e.message;
      });
    }
  }

  // TODO fix, nem megy második login után
  Future<void> _signInWithGoogle() async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();

      await Auth().signInWithProvider(authProvider: googleAuthProvider);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errormassage = e.message;
      });
    }
  }
}
