import 'package:cattlehealthtracker/authentication/model/data_models/role_model.dart';

class UserModel {
  String firstName;
  String lastName;
  String email;
  RoleModel role;
  String mobileNumber;
  bool twoFaEnabled;
  UserModel({required this.firstName, required this.lastName, required this.email, required this.role, required this.mobileNumber, required this.twoFaEnabled});

  UserModel.fromJson(Map<String,dynamic> json):
    firstName = json["first_name"],
    lastName= json["last_name"], 
    email =  json["email"], 
    role = RoleModel(name: json["role"],
    features: List<String>.from(json["features"])), 
    mobileNumber= json["mobile_number"], 
    twoFaEnabled = json["two_fa_enabled"];


}