import 'package:cattlehealthtracker/authentication/model/data_models/user_model.dart';

abstract class AuthenticationDataSource{
  Future<Map<String, dynamic>> login(String email, String password);
  Future<bool?> changePassword(String oldPassword, String newPassword);
  Future<UserModel?> verifyOtp(String otp);
  Future<bool?> toggle2fa();
  Future<double?> resendOtp(String email);
  Future<bool?> logout();
  Future<bool?> logoutLocally();
  
}