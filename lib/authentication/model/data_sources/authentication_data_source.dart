import 'package:cattlehealthtracker/authentication/model/data_models/user_model.dart';

abstract class AuthenticationDataSource{
  Future<UserModel?> login(String email, String password);
  Future<bool?> changePassword(String oldPassword, String newPassword);
  Future<UserModel?> verifyOtp(String otp);
  Future<bool?> toggle2fa();
  Future<bool?> resendOtp(String email);
  
}