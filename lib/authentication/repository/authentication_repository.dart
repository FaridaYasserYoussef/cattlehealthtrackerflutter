import 'package:cattlehealthtracker/authentication/model/data_models/user_model.dart';
import 'package:cattlehealthtracker/authentication/model/data_sources/authentication_data_source.dart';

class AuthenticationRepository {
    AuthenticationDataSource dataSource;
    AuthenticationRepository({required this.dataSource});

    Future<Map<String,dynamic>> login(String email, String password) async{
    Map<String,dynamic> res  = await dataSource.login(email, password);
     return res;
  }

  Future<bool?> changePassword(String oldPassword, String newPassword)async{
    bool? password_changed = await dataSource.changePassword(oldPassword, newPassword);
    return password_changed;
  }


  Future<UserModel?> verifyOtp(String otp) async{
   UserModel? user  = await dataSource.verifyOtp(otp);
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
  
}