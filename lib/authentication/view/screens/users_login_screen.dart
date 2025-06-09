import 'package:cattlehealthtracker/authentication/view-model/authentication_cubit.dart';
import 'package:cattlehealthtracker/authentication/view-model/authentication_states.dart';
import 'package:cattlehealthtracker/authentication/view/widgets/custom_button.dart';
import 'package:cattlehealthtracker/authentication/view/widgets/custom_text_form_field.dart';
import 'package:cattlehealthtracker/authentication/view/widgets/otp_form_widget.dart';
import 'package:cattlehealthtracker/authentication/view/widgets/send_reset_password_link_form.dart';
import 'package:cattlehealthtracker/common/app_colors.dart';
import 'package:cattlehealthtracker/common/app_images.dart';
import 'package:cattlehealthtracker/common/home_screen.dart';
import 'package:cattlehealthtracker/generated/l10n.dart';
import 'package:cattlehealthtracker/settings/view-model/settings_cubit.dart';
import 'package:cattlehealthtracker/settings/view-model/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserLoginScreen extends StatefulWidget {
  FlutterSecureStorage storage;
  GlobalKey<ScaffoldState> scaffoldKey;
   UserLoginScreen({required this.storage, required this.scaffoldKey ,super.key});
  
  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
   TextEditingController emailController = TextEditingController();
   TextEditingController passwordController = TextEditingController();

        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              actions: [
                BlocBuilder<SettingsCubit, SettingsState>(builder:(context, state) {
                 if(state is SettingsLoadingState){
                  return CircularProgressIndicator();
                 }
                 else if(state is SettingsErrorState){
                  return Text(state.errorMessage);
                 }
                 else if(state is SettingsSuccessState){
                  return  DropdownButton<String>(
                    items: [
                  DropdownMenuItem(child: Text("en", style: TextStyle(fontFamily: "Tajawal"),), value: "en",),
                  DropdownMenuItem(child: Text("ar", style: TextStyle(fontFamily: "Tajawal"),), value: "ar",)
                  
                ], onChanged:(value) async{
                  await context.read<SettingsCubit>().setLocale(value!);
                },
                value: state.settingsModel.locale,
                );
                 }
                 return SizedBox.shrink();
          
                },)
                
              ],
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
           body: Form(
            key: formKey,
             child: SingleChildScrollView(
               child: Column(
                
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Padding(
                      padding:  EdgeInsets.only(top: 20.h),
                      child: Text(S.of(context).login,style: Theme.of(context).textTheme.titleLarge,),
                    ),
                  ),
                    
                  Center(
                    child: Padding(
                      padding:  EdgeInsets.symmetric(vertical: 30.h),
                      child: Image.asset(Theme.of(context).brightness == Brightness.dark ? AppImages.logo_dark : AppImages.logo_light,
                      width: 180.w,
                      height: 180.h,
                      ),
                    ),
                  ),
                         
                  CustomTextFormField(controller: emailController, 
                  type: "text", 
                  hintText: S.of(context).email,
                  validator:(p0) {
                    if(p0!.isEmpty){
                      return S.of(context).emptyEmail;
                    }
                    if(!p0.contains("@")){
                      return S.of(context).emailAt;
                    }
                    if(!p0.endsWith(".com")){
                      return S.of(context).emailDotCom;
                    }
                  },
                  ),
                  CustomTextFormField(controller: passwordController, type: "password", hintText: S.of(context).password,
                  validator: (p0) {
                    if(p0!.isEmpty){
                      return S.of(context).emptyPassword;
                    }
                    if(p0.length < 8){
                      return S.of(context).passwordMinLen;
                    }
                  },
                  ),
                  
                  
           
                  BlocListener<AuthenticationCubit, AuthenticationStates>(
                    listener:(context, state) {
                    if(state is LoginSuccessState || state is VerifyOtpSuccessState){
                      Fluttertoast.showToast(msg: S.of(context).loginSuccess, backgroundColor: AppColors.greenColor, );
                      print("login is successful");
                      if (state is LoginSuccessState){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) => HomeScreen(storage: widget.storage, scaffoldKey: widget.scaffoldKey,),));

                      }
                      else if(state is VerifyOtpSuccessState){
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen(storage: widget.storage, scaffoldKey: widget.scaffoldKey,)), (route)=>false);
                      }
                    }
                    else if(state is AuthenticationErrorState){
                      Fluttertoast.showToast(msg: state.errorMessage, backgroundColor: Colors.red, );
                    }else if(state is Authentication2faState){
                      showDialog(
                        barrierDismissible: false,
                        context: context, builder:(context) {

                        return AlertDialog(
                         content: OtpFormWidget(afterCancellationCallBack:() {
                           emailController.clear();
                           passwordController.clear();
                         }, email: emailController.text,),
                        );
                      },);
                    }
                  },
                  child: BlocBuilder<AuthenticationCubit, AuthenticationStates>(builder:(context, state) {
                    if(state is AuthenticationLoadingState){
                      return CustomButton(text: S.of(context).loading, onTap: null,);
                    }
                    return CustomButton(text: S.of(context).login, onTap: () async{
                      if(formKey.currentState!.validate()){
                        await context.read<AuthenticationCubit>().login(emailController.text, passwordController.text);
                      }
                    },);
                  },),
                  ),

                  TextButton(onPressed: (){
                    showDialog(
                      barrierDismissible: false,
                      context: context, builder:(context) {
                      return AlertDialog(
                        content: SendResetPasswordLinkForm(),

                      );
                    },);
                  },
                   child: Text(S.of(context).forgetPassword, 
                   style: TextStyle(fontFamily: "Tajawal", 
                   fontSize: 18.sp, 
                   fontWeight: FontWeight.bold, 
                   color: AppColors.greenColor,)))
                ],
               ),
             ),
           )
          ),
        );

  }
}