import 'package:equatable/equatable.dart';
import 'package:training_partner/features/settings/model/app_settings.dart';

class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsUninitialized extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final AppSettings settings;

  const SettingsLoaded(this.settings);

  @override
  List<Object> get props => [settings];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object> get props => [message];
}
