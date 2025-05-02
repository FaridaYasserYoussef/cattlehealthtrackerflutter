import 'package:cattlehealthtracker/authentication/model/data_models/user_model.dart';
import 'package:cattlehealthtracker/authentication/repository/authentication_repository.dart';
import 'package:cattlehealthtracker/authentication/view-model/authentication_states.dart';
import 'package:cattlehealthtracker/common/custom_exceptions.dart';
import 'package:cattlehealthtracker/common/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthenticationCubit extends Cubit<AuthenticationStates>{
    AuthenticationRepository repository;

  AuthenticationCubit(): repository = AuthenticationRepository(dataSource: ServiceLocator.authenticationDataSource), super(AuthenticationInitialState());
  

  Future<void> login(String email, String password) async{
    try{
      emit(AuthenticationLoadingState());
      Map<String,dynamic> result = await repository.login(email, password);
      if(result["detail"] == "login successful"){
        // construct user from userModel fromJson
        UserModel user = UserModel.fromJson(result["user"]);
        emit(LoginSuccessState(user: user));

      }else{
        emit(Authentication2faState(resendCoolDownSecondsLeft: result['resend_cooldown']));
      }
      

    }catch(e){
      emit(AuthenticationErrorState(errorMessage: e.toString()));
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.red);
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
        if( e is IncorrectOtpAfterVerification){
          emit(VerifyOtpErrorState(errorMessage: e.errorMessage, submitCoolDownSecondsEnd: e.submitCoolDownEnd));
        }
        if (e is OtpAttemptsSurpassed){
          emit(SurpassedAttemptsOtpErrorState(errorMessage: e.errorMessage));
        }
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
        double? resendCoolDownSecondsLeft =  await repository.resendOtp(email);
        emit(ResendOtpSuccessState(resendCoolDownSecondsLeft: resendCoolDownSecondsLeft!));
       }catch(e){
        emit(AuthenticationErrorState(errorMessage: e.toString()));
       }

     }

      Future<void> logout() async{
       try{
        emit(AuthenticationLoadingState());
        await repository.logout();
        emit(LogoutSuccessState());
       }catch(e){
        emit(AuthenticationErrorState(errorMessage: e.toString()));
       }

     }

     Future<void> logoutLocally() async{
       try{
        emit(AuthenticationLoadingState());
        await repository.logoutLocally();
        emit(LogoutSuccessState());
       }catch(e){
        emit(AuthenticationErrorState(errorMessage: e.toString()));
       }

     }
  
}