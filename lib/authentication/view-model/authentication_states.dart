import 'package:cattlehealthtracker/authentication/model/data_models/user_model.dart';

abstract class AuthenticationStates {}

class AuthenticationInitialState extends AuthenticationStates{}

class AuthenticationLoadingState extends AuthenticationStates{}

class Authentication2faState extends AuthenticationStates{}

class LoginSuccessState extends AuthenticationStates{
  final UserModel user;

  LoginSuccessState({required this.user});

}

class AuthenticationErrorState extends AuthenticationStates{
  final String errorMessage;

  AuthenticationErrorState({required this.errorMessage});


}


  class ChangePasswordSuccessState extends AuthenticationStates{}

  class Toggle2faSuccessState extends AuthenticationStates{
   final bool twoFaEnabled;

  Toggle2faSuccessState({required this.twoFaEnabled});

  }

  class VerifyOtpSuccessState extends AuthenticationStates{
      final UserModel user;

  VerifyOtpSuccessState({required this.user});
  }

  class ResendOtpSuccessState extends AuthenticationStates{}
