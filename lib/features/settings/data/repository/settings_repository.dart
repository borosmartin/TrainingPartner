import 'package:training_partner/core/globals/globals.dart';
import 'package:training_partner/features/settings/data/service/settings_service_local.dart';
import 'package:training_partner/features/settings/model/app_settings.dart';

class SettingsRepository {
  final SettingsServiceLocal _settingsServiceLocal;

  SettingsRepository(this._settingsServiceLocal);

  Future<void> updateSettings(String email, AppSettings settings) async {
    try {
      await fireStore.collection('settings').doc(email).set(settings.toJson());

      await _settingsServiceLocal.saveSettings(email, settings);
    } catch (e) {
      rethrow;
    }
  }

  Future<AppSettings> getSettings(String email) async {
    try {
      AppSettings settings = await fireStore.collection('settings').doc(email).get().then((doc) => AppSettings.fromJson(doc.data()!));
      await _settingsServiceLocal.saveSettings(email, settings);

      return settings;
    } catch (e) {
      try {
        return await _settingsServiceLocal.getSettings(email);
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> deleteSettings(String email) async {
    try {
      await fireStore.collection('settings').doc(email).delete();

      await _settingsServiceLocal.deleteSettings(email);
    } catch (e) {
      rethrow;
    }
  }
}
