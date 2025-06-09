import 'package:cattlehealthtracker/authentication/model/data_models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthenticationDataSource{
  Future<Map<String, dynamic>> login(String email, String password);
  Future<bool?> changePassword(String oldPassword, String newPassword);
  Future<UserModel?> verifyOtp(String otp, String email);
  Future<bool?> toggle2fa();
  Future<double?> resendOtp(String email);
  Future<bool?> logout();
  Future<bool?> logoutLocally();
  Future<bool?> sendResetPasswordLink(String email);
}