import 'package:cattlehealthtracker/authentication/model/data_models/user_model.dart';
import 'package:cattlehealthtracker/authentication/model/data_sources/authentication_data_source.dart';

class AuthenticationApiDataSource extends AuthenticationDataSource{
  @override
  Future<UserModel> login(String username, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }
  
}