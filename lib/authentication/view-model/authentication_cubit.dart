import 'package:cattlehealthtracker/authentication/model/data_models/user_model.dart';
import 'package:cattlehealthtracker/authentication/repository/authentication_repository.dart';
import 'package:cattlehealthtracker/authentication/view-model/authentication_states.dart';
import 'package:cattlehealthtracker/common/custom_exceptions.dart';
import 'package:cattlehealthtracker/common/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthenticationCubit extends Cubit<AuthenticationStates>{
    AuthenticationRepository repository;
    FlutterSecureStorage storage;
  AuthenticationCubit({required this.storage}): repository = AuthenticationRepository(dataSource: ServiceLocator.getAuthenticationDataSource(storage), storage: storage), super(AuthenticationInitialState());
  AuthenticationCubit.test(this.repository, this.storage): super(AuthenticationInitialState());
  
  Future<void> login(String email, String password) async{
    try{
      emit(AuthenticationLoadingState());
      Map<String,dynamic> result = await repository.login(email, password);
      if(result["detail"] == "login successful"){
        // construct user from userModel fromJson
        print("login is successful clause");
        UserModel user = UserModel.fromJson(result["user"]);
        emit(LoginSuccessState(user: user));
        print("success state emitted");

      }else if(result["detail"] == "2fa-enabled"){
        print("2fa state emitted");
        emit(Authentication2faState(resendCoolDownSecondsLeft: result['resend_cooldown']));
      }
      

    }catch(e){
      print("error state emitted");
      print(e.toString());
      emit(AuthenticationErrorState(errorMessage: e.toString()));
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.red);
    }
  }

    Future<void> changePassword(String oldPassword, String newPassword)async{
      try{
         emit(ChangePasswordLoading());
         await repository.changePassword(oldPassword, newPassword);
         emit(ChangePasswordSuccessState());
      }catch(e){
        if(e is OldPasswordIncorrect){
          emit(OldPasswordIsIncorrect());
        }
        emit(AuthenticationErrorState(errorMessage:e.toString()));
      }
    }
    Future<void> verifyOtp(String otp, String email) async{
      try{
      emit(OtpSubmitLoadingState());
      UserModel? user = await repository.verifyOtp(otp, email);
      emit(VerifyOtpSuccessState(user: user!));
      }catch(e){
        if( e is IncorrectOtpAfterVerification){
          print("the otp is incorrect");
          emit(VerifyOtpErrorState(errorMessage: e.errorMessage, submitCoolDownSecondsEnd: e.submitCoolDownEnd));
        }
        else if (e is OtpAttemptsSurpassed){
          print("you surpassed surpassed your 3 OTP attempsts");
          emit(SurpassedAttemptsOtpErrorState(errorMessage: e.errorMessage));
        }
        else if(e is OtpNotSet){
         emit(OtpExpiredState());
        }
        else{
        emit(AuthenticationErrorState(errorMessage: e.toString()));

        }
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
        emit(OtpResendLoadingState());
        double? resendCoolDownSecondsLeft =  await repository.resendOtp(email);
        emit(ResendOtpSuccessState(resendCoolDownSecondsLeft: resendCoolDownSecondsLeft!));
       }catch(e){
        emit(AuthenticationErrorState(errorMessage: e.toString()));
       }

     }

      Future<void> logout() async{
       try{
        emit(LogoutLoadingState());
        await repository.logout();
        emit(LogoutSuccessState());
       }catch(e){
        emit(AuthenticationErrorState(errorMessage: e.toString()));
       }

     }

     Future<void> logoutLocally() async{
       try{
        emit(LogoutLoadingState());
        await repository.logoutLocally();
        emit(LogoutSuccessState());
       }catch(e){
        print("in logout locally error cubit");
        print(e.toString());
        emit(AuthenticationErrorState(errorMessage: e.toString()));
       }

     }
  
}