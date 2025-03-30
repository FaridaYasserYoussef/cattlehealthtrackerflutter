import 'package:cattlehealthtracker/common/service_locator.dart';
import 'package:cattlehealthtracker/settings/model/data_models/settings_model.dart';
import 'package:cattlehealthtracker/settings/repository/settings_repository.dart';
import 'package:cattlehealthtracker/settings/view-model/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<SettingsState>{
  SettingsRepository settingsRepository;
  SettingsCubit():settingsRepository = SettingsRepository(dataSource: ServiceLocator.settingsDataSource), super(SettingsInitialState());

 Future<void> getSettings()async{
    try{
     emit(SettingsLoadingState());
    SettingsModel settingsModel =  await settingsRepository.getSettings();
    emit(SettingsSuccessState(settingsModel: settingsModel));
    }catch(e){
      emit(SettingsErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> setLocale(String locale) async{
       try{
     emit(SettingsLoadingState());
     await settingsRepository.setLocale(locale);
    SettingsModel settingsModel =  await settingsRepository.getSettings();
    emit(SettingsSuccessState(settingsModel: settingsModel));
    }catch(e){
      emit(SettingsErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> setTheme(String theme) async{
        try{
     emit(SettingsLoadingState());
     await settingsRepository.setTheme(theme);
    SettingsModel settingsModel =  await settingsRepository.getSettings();
    emit(SettingsSuccessState(settingsModel: settingsModel));
    }catch(e){
      emit(SettingsErrorState(errorMessage: e.toString()));
    }
  }
Future<void> setIsLoggedIn(bool isLoggedIn) async{
       try{
     emit(SettingsLoadingState());
     await settingsRepository.setIsLoggedIn(isLoggedIn);
    SettingsModel settingsModel =  await settingsRepository.getSettings();
    emit(SettingsSuccessState(settingsModel: settingsModel));
    }catch(e){
      emit(SettingsErrorState(errorMessage: e.toString()));
    }
}

}