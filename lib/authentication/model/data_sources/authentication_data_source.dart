import 'package:cattlehealthtracker/authentication/model/data_models/user_model.dart';

abstract class AuthenticationDataSource{
  Future<UserModel> login(String username, String password);
}