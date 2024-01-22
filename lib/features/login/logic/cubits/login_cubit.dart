import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/features/login/data/repository/login_repository.dart';
import 'package:training_partner/features/login/logic/states/login_state.dart';
import 'package:training_partner/features/login/models/remembered_user.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository loginRepository;

  LoginCubit(this.loginRepository) : super(LoginUnititialized());

  Future<void> rememberUser(RememberedUser user) async {
    try {
      emit(RememberedUserLoading());

      await loginRepository.rememberUser(user);

      emit(RememberedUserSaved());
    } catch (e) {
      emit(RememberedUserError(e.toString()));
    }
  }

  Future<void> getRememberedUserList() async {
    try {
      emit(RememberedUserLoading());

      List<RememberedUser> users = await loginRepository.getRememberedUserList();

      emit(RememberedUsersLoaded(users));
    } catch (e) {
      emit(RememberedUserError(e.toString()));
    }
  }
}
