import 'package:equatable/equatable.dart';
import 'package:training_partner/features/login/models/remembered_user.dart';

class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginUnititialized extends LoginState {}

class RememberedUserLoading extends LoginState {}

class RememberedUserSaved extends LoginState {}

class RememberedUsersLoaded extends LoginState {
  final List<RememberedUser> rememberedUsers;

  RememberedUsersLoaded(this.rememberedUsers);

  @override
  List<Object> get props => [rememberedUsers];
}

class RememberedUserError extends LoginState {
  final String message;

  RememberedUserError(this.message);

  @override
  List<Object> get props => [message];
}
