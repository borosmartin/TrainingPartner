import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/core/globals/globals.dart';
import 'package:training_partner/features/settings/data/repository/settings_repository.dart';
import 'package:training_partner/features/settings/logic/states/settings_state.dart';
import 'package:training_partner/features/settings/model/app_settings.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _settingsRepository;

  SettingsCubit(this._settingsRepository) : super(SettingsUninitialized());

  Future<void> getSettings() async {
    try {
      emit(SettingsLoading());

      final settings = await _settingsRepository.getSettings(currentUser.email!);

      emit(SettingsLoaded(settings));
    } catch (error, stackTrace) {
      emit(SettingsError('Error: $error, stackTrace: $stackTrace'));
    }
  }

  Future<void> updateSettings(AppSettings settings) async {
    try {
      emit(SettingsLoading());

      await _settingsRepository.updateSettings(currentUser.email!, settings);

      emit(SettingsLoaded(settings));
    } catch (error, stackTrace) {
      emit(SettingsError('Error: $error, stackTrace: $stackTrace'));
    }
  }
}
