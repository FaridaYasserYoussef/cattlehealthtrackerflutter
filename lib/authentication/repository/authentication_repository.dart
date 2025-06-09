import 'package:cattlehealthtracker/authentication/model/data_models/user_model.dart';
import 'package:cattlehealthtracker/authentication/model/data_sources/authentication_data_source.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationRepository {
    AuthenticationDataSource dataSource;
    FlutterSecureStorage storage;
    AuthenticationRepository({required this.dataSource, required this.storage});

    Future<Map<String,dynamic>> login(String email, String password) async{
    Map<String,dynamic> res  = await dataSource.login(email, password);
     return res;
  }

  Future<bool?> changePassword(String oldPassword, String newPassword)async{
    bool? password_changed = await dataSource.changePassword(oldPassword, newPassword);
    return password_changed;
  }


  Future<UserModel?> verifyOtp(String otp, String email) async{
   UserModel? user  = await dataSource.verifyOtp(otp, email);
     return user;
  }
  
  Future<bool?> toggle2fa() async{
  bool? current2faValue = await dataSource.toggle2fa();
  return current2faValue;
  }
  
  Future<double?> resendOtp(String email) async{
   double? otpSent = await dataSource.resendOtp(email);
   return otpSent;
  }

  Future<bool?> logout() async{
    bool? logged_out = await dataSource.logout();
    return logged_out;
  }

  Future<bool?> logoutLocally() async{
    bool? logged_out = await dataSource.logoutLocally();
    return logged_out;
  }

  Future<bool?> sendResetPasswordLink(String email) async{
    bool? emailSent = await dataSource.sendResetPasswordLink(email);
    return emailSent;
  }
  
}