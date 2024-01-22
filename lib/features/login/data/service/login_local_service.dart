import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:training_partner/features/login/models/remembered_user.dart';
import 'package:training_partner/features/login/models/user.dart';

class LoginLocalService {
  static const String userDataBoxKey = 'UserData';
  static const String rememberedUsersBoxKey = 'RememberedUsers';

  // todo for later use
  Future<void> saveUserData(UserData userData) async {
    String id = userData.id;
    String email = userData.email;
    String userDataKey = 'UserDataKey-$email-$id';

    final box = await Hive.openBox(userDataBoxKey);

    final encryptedPassword = _getEncrypter().encrypt(userData.password).base64;
    final encryptedUserData = userData.copyWith(password: encryptedPassword);

    await box.put(userDataKey, encryptedUserData);
  }

  // todo for later use
  Future<UserData> getUserData(String email, String id) async {
    String userDataKey = 'UserDataKey-$email-$id';

    final box = await Hive.openBox(userDataBoxKey);
    final boxValue = box.get(userDataKey);

    if (boxValue != null) {
      final enryptedUserData = UserData.fromJson(Map<String, dynamic>.from(boxValue));
      final decryptedPassword = _getEncrypter().decrypt64(enryptedUserData.password);

      return enryptedUserData.copyWith(password: decryptedPassword);
    }

    throw Exception('There has been an error retrieving local user data');
  }

  Future<void> rememberUser(RememberedUser rememberedUser) async {
    String rememberedUserKey = 'RememberedUser-${rememberedUser.email}';

    final box = await Hive.openBox(rememberedUsersBoxKey);

    final encryptedPassword = _getEncrypter().encrypt(rememberedUser.password).base64;

    await box.putAll(<String, dynamic>{
      rememberedUserKey: rememberedUser.copyWith(password: encryptedPassword).toJson(),
    });
  }

  Future<List<RememberedUser>> getRememberedUserList() async {
    final box = await Hive.openBox(rememberedUsersBoxKey);

    final List<RememberedUser> encryptedRememberedUsers = box.values.map((e) => RememberedUser.fromJson(Map<String, dynamic>.from(e))).toList();
    final List<RememberedUser> rememberedUsers =
        encryptedRememberedUsers.map((user) => user.copyWith(password: _getEncrypter().decrypt64(user.password))).toList();

    return rememberedUsers;
  }

  Encrypter _getEncrypter() {
    String secretKey = dotenv.get('SECRET_KEY');
    final Key key = Key.fromUtf8(secretKey);

    return Encrypter(Fernet(key));
  }
}
