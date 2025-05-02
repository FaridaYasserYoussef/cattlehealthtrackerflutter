import 'package:cattlehealthtracker/authentication/model/data_models/user_model.dart';

abstract class AuthenticationStates {}

class AuthenticationInitialState extends AuthenticationStates{}

class AuthenticationLoadingState extends AuthenticationStates{}

class Authentication2faState extends AuthenticationStates{
  final double resendCoolDownSecondsLeft;

  Authentication2faState({required this.resendCoolDownSecondsLeft});
}

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

  class VerifyOtpErrorState extends AuthenticationStates{
      final String errorMessage;
    final double submitCoolDownSecondsEnd;

  VerifyOtpErrorState({required this.errorMessage, required this.submitCoolDownSecondsEnd});

  }

  class SurpassedAttemptsOtpErrorState extends AuthenticationStates{
          final String errorMessage;

  SurpassedAttemptsOtpErrorState({required this.errorMessage});

  }

  class ResendOtpSuccessState extends AuthenticationStates{
    final double resendCoolDownSecondsLeft;

  ResendOtpSuccessState({required this.resendCoolDownSecondsLeft});

  }

  class LogoutSuccessState extends AuthenticationStates{}
