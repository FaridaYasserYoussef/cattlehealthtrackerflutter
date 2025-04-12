import 'package:cattlehealthtracker/authentication/model/data_models/user_model.dart';

abstract class AuthenticationStates {}

class AuthenticationInitialState extends AuthenticationStates{}

class AuthenticationLoadingState extends AuthenticationStates{}

class Authentication2faState extends AuthenticationStates{}

class AuthenticationSuccessState extends AuthenticationStates{
  final UserModel user;

  AuthenticationSuccessState({required this.user});

}

class AuthenticationErrorState extends AuthenticationStates{
  final String errorMessage;

  AuthenticationErrorState({required this.errorMessage});
}
