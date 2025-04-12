import 'package:cattlehealthtracker/authentication/model/data_models/user_model.dart';
import 'package:cattlehealthtracker/authentication/model/data_sources/authentication_data_source.dart';

class AuthenticationRepository {
    AuthenticationDataSource dataSource;
    AuthenticationRepository({required this.dataSource});

    Future<UserModel?> login(String email, String password) async{
    UserModel? user  = await dataSource.login(email, password);
     return user;
  }

  Future<bool?> changePassword(String email, String newPassword)async{
    
  }


  Future<UserModel?> verifyOtp(String otp) {
    // TODO: implement verifyOtp
    throw UnimplementedError();
  }
  
  Future<bool> toggle2fa() {
    // TODO: implement toggleOtp
    throw UnimplementedError();
  }
  
  Future<bool> resendOtp() {
    // TODO: implement resendOtp
    throw UnimplementedError();
  }
  
}