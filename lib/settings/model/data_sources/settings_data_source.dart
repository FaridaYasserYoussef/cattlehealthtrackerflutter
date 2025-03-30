import 'package:cattlehealthtracker/settings/model/data_models/settings_model.dart';

abstract class SettingsDataSource {
  Future<SettingsModel> getSettings();
  Future<void> setLocale(String locale);
  Future<void> setTheme(String theme);
  Future<void> setIsLoggedIn(bool isLoggedIn);
}