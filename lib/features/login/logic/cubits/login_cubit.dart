import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/core/resources/firebase/auth_service.dart';
import 'package:training_partner/features/login/logic/states/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginUnititialized());

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      emit(LoginInProgress());

      await AuthService().signInWithEmailAndPassword(email: email, password: password);

      emit(LoginSuccessful());
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-credential') {
        emit(LoginFailed(message: 'Invalid credentials, please try again!'));
      } else if (error.code == 'invalid-email') {
        emit(LoginFailed(message: 'Incorrect email format, please try again!'));
      } else if (error.code == 'wrong-password') {
        emit(LoginFailed(message: 'Incorrect password, please try again!'));
      } else if (error.code == 'user-not-found') {
        emit(LoginFailed(message: 'No user found with that email!'));
      } else {
        emit(LoginFailed(message: 'An error occurred. Please try again later!'));
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(LoginInProgress());

      await AuthService().signInWithGoogle();

      emit(LoginSuccessful());
    } on FirebaseAuthException catch (error) {
      if (error.message != null) {
        emit(LoginFailed(message: error.message!));
      }
    }
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    try {
      emit(LoginInProgress());

      await AuthService().createUserWithEmailAndPassword(email: email, password: password);

      emit(LoginSuccessful());
    } on FirebaseAuthException catch (error) {
      if (error.message != null) {
        emit(LoginFailed(message: error.message!));
      }
    }
  }
}
