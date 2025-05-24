import 'package:cattlehealthtracker/authentication/model/data_sources/authentication_api_data_source.dart';
import 'package:cattlehealthtracker/authentication/model/data_sources/authentication_data_source.dart';
import 'package:cattlehealthtracker/settings/model/data_sources/settings_data_source.dart';
import 'package:cattlehealthtracker/settings/model/data_sources/settings_shared_prefs_data_source.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ServiceLocator {
  static AuthenticationDataSource getAuthenticationDataSource(FlutterSecureStorage? storage){
  return AuthenticationApiDataSource(storage: storage!);
  }
  static SettingsDataSource settingsDataSource = SettingsSharedPrefsDataSource();
}