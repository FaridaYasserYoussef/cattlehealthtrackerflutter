import 'package:cattlehealthtracker/settings/model/data_models/settings_model.dart';
import 'package:cattlehealthtracker/settings/model/data_sources/settings_data_source.dart';

class SettingsRepository {
  SettingsDataSource dataSource;
  SettingsRepository({required this.dataSource});

  Future<SettingsModel> getSettings()async{
    SettingsModel settingsModel = await dataSource.getSettings();
    return settingsModel;

  }

  Future<void> setLocale(String locale) async{
    await dataSource.setLocale(locale);
  }

  Future<void> setTheme(String theme)async{
     await dataSource.setTheme(theme);
  }

  Future<void> setIsLoggedIn(bool isLoggedIn) async{
    await dataSource.setIsLoggedIn(isLoggedIn);
  }

}