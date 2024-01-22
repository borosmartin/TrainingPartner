import 'package:training_partner/features/login/data/service/login_local_service.dart';
import 'package:training_partner/features/login/models/remembered_user.dart';
import 'package:training_partner/features/login/models/user.dart';

class LoginRepository {
  final LoginLocalService _loginLocalService;

  LoginRepository(this._loginLocalService);

  Future<void> rememberUser(RememberedUser user) => _loginLocalService.rememberUser(user);

  Future<List<RememberedUser>> getRememberedUserList() => _loginLocalService.getRememberedUserList();

  Future<void> saveUserData(UserData userData) => _loginLocalService.saveUserData(userData);

  Future<UserData> getUserData(String email, String id) => _loginLocalService.getUserData(email, id);
}
