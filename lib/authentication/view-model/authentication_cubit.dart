import 'package:cattlehealthtracker/authentication/model/data_models/user_model.dart';
import 'package:cattlehealthtracker/authentication/repository/authentication_repository.dart';
import 'package:cattlehealthtracker/authentication/view-model/authentication_states.dart';
import 'package:cattlehealthtracker/common/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationCubit extends Cubit<AuthenticationStates>{
    AuthenticationRepository repository;

  AuthenticationCubit(): repository = AuthenticationRepository(dataSource: ServiceLocator.authenticationDataSource), super(AuthenticationInitialState());
  

  Future<void> login(String email, String password) async{
    try{
      emit(AuthenticationLoadingState());
      UserModel? user = await repository.login(email, password);
      emit(LoginSuccessState(user: user!));

    }catch(e){
      emit(AuthenticationErrorState(errorMessage: e.toString()));
    }
  }

    Future<void> changePassword(String oldPassword, String newPassword)async{
      try{
         emit(AuthenticationLoadingState());
         await repository.changePassword(oldPassword, newPassword);
         emit(ChangePasswordSuccessState());
      }catch(e){
        emit(AuthenticationErrorState(errorMessage:e.toString()));
      }
    }
    Future<void> verifyOtp(String otp) async{
      try{
      emit(AuthenticationLoadingState());
      UserModel? user = await repository.verifyOtp(otp);
      emit(VerifyOtpSuccessState(user: user!));
      }catch(e){
        emit(AuthenticationErrorState(errorMessage: e.toString()));
      }
    }
     Future<void> toggle2fa() async{
      try{
       emit(AuthenticationLoadingState());
       bool? twoFaEnabled = await repository.toggle2fa();
       emit(Toggle2faSuccessState(twoFaEnabled: twoFaEnabled!));
      }catch(e){
        emit(AuthenticationErrorState(errorMessage: e.toString()));
      }

     }
     
     Future<void> resendOtp(String email) async{
       try{
        emit(AuthenticationLoadingState());
        await repository.resendOtp(email);
        emit(ResendOtpSuccessState());
       }catch(e){
        emit(AuthenticationErrorState(errorMessage: e.toString()));
       }

     }
  
}