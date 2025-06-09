import 'package:cattlehealthtracker/api/api.dart';
import 'package:cattlehealthtracker/api/dio_service.dart';
import 'package:cattlehealthtracker/authentication/model/data_models/role_model.dart';
import 'package:cattlehealthtracker/authentication/model/data_models/user_model.dart';
import 'package:cattlehealthtracker/authentication/model/data_sources/authentication_data_source.dart';
import 'package:cattlehealthtracker/common/custom_exceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class AuthenticationApiDataSource extends AuthenticationDataSource{
  final FlutterSecureStorage storage;
  static DioService dioService = DioService();

  AuthenticationApiDataSource({required this.storage});
  @override
  Future<Map<String, dynamic>> login(String email, String password) async{
    try{
      dioService.configureDio(baseUrl: API.hostConnect);
      Response postResponse = await dioService.postRequest(API.hostConnectAuthenticationLogin,
       {
       "email":email,
       "password": password
       },
      null
       ,  null);
       print("response is ");
      print(postResponse.data);
      if(postResponse.data["detail"] == "login successful"){
        print("logins successful");
      //  UserModel user = UserModel(
      //   firstName: postResponse.data["user"]["first_name"], 
      //   lastName: postResponse.data["user"]["last_name"], 
      //   email: postResponse.data["user"]["email"], 
      //   role: RoleModel(name: postResponse.data["user"]["role"],
      //   features: List<String>.from(postResponse.data["user"]["features"])), 
      //   mobileNumber: postResponse.data["user"]["mobile_number"], 
      //   twoFaEnabled: postResponse.data["user"]["two_fa_enabled"]);
        // secure storage saving logic
        final storage = FlutterSecureStorage();
        SharedPreferences prefs = await SharedPreferences.getInstance();
       await prefs.setBool("isLoggedIn", true);
        await prefs.setBool("twoFaEnabled", postResponse.data["user"]["two_fa_enabled"]);
        await storage.write(key: "email", value: postResponse.data["user"]["email"]);
        await storage.write(key: "phone", value:  postResponse.data["user"]["mobile_number"]);
        await storage.write(key: "features", value: jsonEncode(postResponse.data["user"]["features"]));
        await storage.write(key: "refresh", value: postResponse.data["refresh"]);
        await storage.write(key: "access", value: postResponse.data["access"]);
 

        
      }
      else if(postResponse.data["detail"] == "2fa-enabled"){
         final storage = FlutterSecureStorage();
         await storage.write(key: "email", value: postResponse.data["email"]);


      }
      return postResponse.data;
    }
    catch(e){
     throw Exception(e.toString());
    }
  }
  
  @override
  Future<bool?> changePassword(String oldPassword, String newPassword) async{
    // try{
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
      else if(response.statusCode == 400){
        print("old password issue");
        throw OldPasswordIncorrect(errorMessage: "incorrect old password");
        
      }
      else{
        throw Exception(response.data["error"]);
      }
    // }catch(e){
    //   throw Exception(e.toString());
    // }
  }
  
  @override
  Future<UserModel?> verifyOtp(String otp, String email) async{
    // try{
      dioService.configureDio(baseUrl: API.hostConnect);
      Response response = await dioService.postRequest(API.hostConnectAuthenticationOtp, 
      {
         "otp": otp,
         "email": email
      }, null, null);
      print(response.data);
      if(response.statusCode == 200){
        UserModel user = UserModel(
          firstName: response.data["user"]["first_name"], 
        lastName: response.data["user"]["last_name"], 
        email: response.data["user"]["email"], 
        role: RoleModel(name: response.data["user"]["role"],
        features: List<String>.from(response.data["user"]["features"])), 
        mobileNumber: response.data["user"]["mobile_number"], 
        twoFaEnabled: response.data["user"]["two_fa_enabled"]);
            final storage = FlutterSecureStorage();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isLoggedIn", true);
        await prefs.setBool("twoFaEnabled", response.data["user"]["two_fa_enabled"]);
        await storage.write(key: "email", value: response.data["user"]["email"]);
        await storage.write(key: "phone", value:  response.data["user"]["mobile_number"]);
        await storage.write(key: "features", value: jsonEncode(response.data["user"]["features"]));
        await storage.write(key: "refresh", value: response.data["refresh"]);
        await storage.write(key: "access", value: response.data["access"]);
 

        return user;


      }
     else if(response.statusCode != 200){

     if (response.data["detail"] == "incorrect otp"){
      print("incorrect trigerred");
        throw IncorrectOtpAfterVerification(errorMessage: "Incorrect OTP", submitCoolDownEnd: response.data["otp_verify_cooldown"]);

      }
     
     else if(response.data["detail"] == "incorrect otp, surpassed otp trials"){
       throw OtpAttemptsSurpassed(errorMessage: "too many OTP attempts");
     }
     else if(response.data["detail"] == "OTP not set ask for an otp resend"){
        throw OtpNotSet(errorMessage: "OTP is expired ask for a resend");
     }
     else{
      throw(Exception());
     }

     }

      

      


    // }
    // catch(e){

    //   throw Exception(e.toString());
    // }
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
  Future<double?> resendOtp(String email) async{
    try{
     dioService.configureDio(baseUrl: API.hostConnect);
     Response response = await dioService.postRequest(API.hostConnectAuthenticationResendOtp,
      {"email": email}, null, null);
      return response.data["otp_resend_cool_down"];
    }catch(e){
      throw Exception(e.toString());
    }
  }
  
  @override
  Future<bool?> logout() async{
    try{
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: "access");
      String? refreshToken = await storage.read(key: "refresh");
      print("refresh token sent is ${refreshToken}");
      dioService.configureDio(baseUrl: API.hostConnect);
      Response response = await dioService.postRequest(API.hostConnectAuthenticationLogout,
    {
      "refresh": refreshToken
    },
        null, {
          "Authorization": "Bearer $accessToken"
        });

        if(response.statusCode == 500){
          print("errorrr is ${response.data}");
        }


      if(response.statusCode ==  200){
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isLoggedIn", false);
        await prefs.remove("twoFaEnabled");
        await storage.delete(key: "email");
        await storage.delete(key: "phone");
        await storage.delete(key: "features");
        await storage.delete(key: "refresh");
        await storage.delete(key: "access");
        return true;

      }

    }catch(e){
      throw Exception(e.toString());
    }

  }
  
  @override
  Future<bool?> logoutLocally() async{
       try{
        // final storage = FlutterSecureStorage();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isLoggedIn", false);
        await prefs.remove("twoFaEnabled");
        await storage.delete(key: "email");
        await storage.delete(key: "phone");
        await storage.delete(key: "features");
        await storage.delete(key: "refresh");
        await storage.delete(key: "access");
        return true;


    }catch(e){
      throw Exception(e.toString());
    }
  }
  
  @override
  Future<bool?> sendResetPasswordLink(String email) async{
   dioService.configureDio(baseUrl: API.hostConnect);
   Response response = await dioService.postRequest(API.hostConnectAuthenticationSendResetLink, 
      {
         "email": email
      }, null, null);

      if(response.statusCode == 200){
        return true;
      }
     
     if(response.statusCode == 400){
      if(response.data["error"] == "failed to send email"){
        throw FailedToSendPasswordResetEmail(errorMessage: "failed to send email");

      }else if(response.data["error"] == "user not found"){
        throw PasswordResetEmailAddressNotFound(errorMessage: "user not found");
      }
     }

  }

  

}