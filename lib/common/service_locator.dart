import 'package:cattlehealthtracker/authentication/model/data_sources/authentication_api_data_source.dart';
import 'package:cattlehealthtracker/authentication/model/data_sources/authentication_data_source.dart';
import 'package:cattlehealthtracker/settings/model/data_sources/settings_data_source.dart';
import 'package:cattlehealthtracker/settings/model/data_sources/settings_shared_prefs_data_source.dart';

class ServiceLocator {
  static AuthenticationDataSource authenticationDataSource = AuthenticationApiDataSource();
  static SettingsDataSource settingsDataSource = SettingsSharedPrefsDataSource();
}