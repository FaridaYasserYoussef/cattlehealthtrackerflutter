import 'package:cattlehealthtracker/authentication/model/data_models/role_model.dart';

class UserModel {
  String firstName;
  String lastName;
  String email;
  RoleModel role;
  UserModel({required this.firstName, required this.lastName, required this.email, required this.role});
}