import 'package:cattlehealthtracker/settings/model/data_models/settings_model.dart';

abstract class SettingsState {}

class SettingsInitialState extends SettingsState{

}

class SettingsLoadingState extends SettingsState{

}


class SettingsSuccessState extends SettingsState{
    SettingsModel settingsModel;
    SettingsSuccessState({required this.settingsModel});
}

class SettingsErrorState extends SettingsState{
  String errorMessage;
  SettingsErrorState({required this.errorMessage});
}

