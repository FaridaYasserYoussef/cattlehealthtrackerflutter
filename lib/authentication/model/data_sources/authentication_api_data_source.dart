import 'package:cattlehealthtracker/api/api.dart';
import 'package:cattlehealthtracker/api/dio_service.dart';
import 'package:cattlehealthtracker/authentication/model/data_models/role_model.dart';
import 'package:cattlehealthtracker/authentication/model/data_models/user_model.dart';
import 'package:cattlehealthtracker/authentication/model/data_sources/authentication_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationApiDataSource extends AuthenticationDataSource{
  static DioService dioService = DioService();
  @override
  Future<UserModel?> login(String email, String password) async{
    try{
      dioService.configureDio(baseUrl: API.hostConnect);
      Response postResponse = await dioService.postRequest(API.hostConnectAuthenticationLogin,
       {
       "email":email,
       "password": password
       },null, null);

      if(postResponse.data["detail"] == "login successful"){
       UserModel user = UserModel(
        firstName: postResponse.data["user"]["first_name"], 
        lastName: postResponse.data["user"]["last_name"], 
        email: postResponse.data["user"]["email"], 
        role: RoleModel(name: postResponse.data["user"]["role"],
        features: postResponse.data["user"]["features"]), 
        mobileNumber: postResponse.data["user"]["mobile_number"], 
        twoFaEnabled: postResponse.data["user"]["two_fa_enabled"]);
        // secure storage saving logic
        final storage = FlutterSecureStorage();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool("twoFaEnabled", postResponse.data["user"]["two_fa_enabled"]);
        await storage.write(key: "email", value: postResponse.data["user"]["email"]);
        await storage.write(key: "phone", value:  postResponse.data["user"]["mobile_number"]);
        await storage.write(key: "features", value: postResponse.data["user"]["features"].toString());
        await storage.write(key: "refresh", value: postResponse.data["refresh"]);
        await storage.write(key: "access", value: postResponse.data["access"]);
 

        return user;
      }
      else if(postResponse.data["detail"] == "2fa-enabled"){
         final storage = FlutterSecureStorage();
         await storage.write(key: "email", value: postResponse.data["email"]);
      }
    }
    catch(e){
     throw Exception(e.toString());
    }
  }
  
  @override
  Future<bool?> changePassword(String oldPassword, String newPassword) async{
    try{
      dioService.configureDio(baseUrl: API.hostConnect);
      final storage = FlutterSecureStorage();
      String? accessToken  = await storage.read(key: "access");
      Response response = await dioService.postRequest(API.hostConnectAuthenticationChangePassword, {
        "old_password": oldPassword,
        "new_password": newPassword
      }, null, {
        "Authorization": "Bearer ${accessToken}"
      });
      if(response.statusCode == 200){
        return true;
      }
      else{
        throw Exception(response.data["error"]);
      }
    }catch(e){
      throw Exception(e.toString());
    }
  }
  
  @override
  Future<UserModel?> verifyOtp(String otp) async{
    try{
      dioService.configureDio(baseUrl: API.hostConnect);
      Response response = await dioService.postRequest(API.hostConnectAuthenticationOtp, 
      {
         "otp": otp
      }, null, null);
      if(response.statusCode == 200){
        UserModel user = UserModel(
          firstName: response.data["user"]["first_name"], 
        lastName: response.data["user"]["last_name"], 
        email: response.data["user"]["email"], 
        role: RoleModel(name: response.data["user"]["role"],
        features: response.data["user"]["features"]), 
        mobileNumber: response.data["user"]["mobile_number"], 
        twoFaEnabled: response.data["user"]["two_fa_enabled"]);
            final storage = FlutterSecureStorage();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool("twoFaEnabled", response.data["user"]["two_fa_enabled"]);
        await storage.write(key: "email", value: response.data["user"]["email"]);
        await storage.write(key: "phone", value:  response.data["user"]["mobile_number"]);
        await storage.write(key: "features", value: response.data["user"]["features"].toString());
        await storage.write(key: "refresh", value: response.data["refresh"]);
        await storage.write(key: "access", value: response.data["access"]);
 

        return user;


      }


    }
    catch(e){
      throw Exception(e.toString());
    }
  }
  
  @override
  Future<bool?> toggle2fa() async{
    try{
     dioService.configureDio(baseUrl: API.hostConnect);
     final storage = FlutterSecureStorage();
     String? accessToken =  await storage.read(key: "access");
     Response response = await dioService.postRequest(API.hostConnectAuthenticationToggle2fa, null, null,
      {
        "Authorization": "Bearer $accessToken"
      });
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("twoFaEnabled", response.data["value"]);
      return response.data["value"];

    }catch(e){
       throw Exception(e.toString());
    }
  }
  
  @override
  Future<bool?> resendOtp(String email) async{
    try{
     dioService.configureDio(baseUrl: API.hostConnect);
     Response response = await dioService.postRequest(API.hostConnectAuthenticationResendOtp,
      {"email": email}, null, null);
      return response.data["sent"];
    }catch(e){
      throw Exception(e.toString());
    }
  }
  

  
}