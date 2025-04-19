import 'package:cattlehealthtracker/settings/model/data_models/settings_model.dart';
import 'package:cattlehealthtracker/settings/model/data_sources/settings_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
 
class SettingsSharedPrefsDataSource extends SettingsDataSource{
  @override
 Future<SettingsModel> getSettings() async{
   final SharedPreferences prefs = await SharedPreferences.getInstance();
   
   return SettingsModel(theme: prefs.getString("theme")?? "light", locale: prefs.getString("locale") ?? "ar", isloggedIn: prefs.getBool("isLoggedIn") ?? false);
  }

  @override
  Future<void> setIsLoggedIn(bool isLoggedIn) async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isLoggedIn", isLoggedIn);

  }

  @override
  Future<void> setLocale(String locale) async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("locale", locale);

  }

  @override
  Future<void> setTheme(String theme) async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("theme", theme);

  }

}