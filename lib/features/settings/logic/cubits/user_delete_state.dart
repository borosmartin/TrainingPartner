import 'package:equatable/equatable.dart';

class UserDeleteState extends Equatable {
  const UserDeleteState();

  @override
  List<Object> get props => [];
}

class UserDeleteUninitialized extends UserDeleteState {}

class UserDeleteLoading extends UserDeleteState {}

class UserDeleteSuccess extends UserDeleteState {}

class UserDeleteError extends UserDeleteState {
  final String message;

  const UserDeleteError({required this.message});

  @override
  List<Object> get props => [message];
}
