import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginUnititialized extends LoginState {}

class LoginInProgress extends LoginState {}

class LoginSuccessful extends LoginState {}

class LoginFailed extends LoginState {
  final String message;
  LoginFailed({required this.message});
}
