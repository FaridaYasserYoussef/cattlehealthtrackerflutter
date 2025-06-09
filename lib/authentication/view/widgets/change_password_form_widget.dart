import 'package:cattlehealthtracker/authentication/view-model/authentication_cubit.dart';
import 'package:cattlehealthtracker/authentication/view-model/authentication_states.dart';
import 'package:cattlehealthtracker/authentication/view/widgets/custom_button.dart';
import 'package:cattlehealthtracker/authentication/view/widgets/custom_text_form_field.dart';
import 'package:cattlehealthtracker/common/app_colors.dart';
import 'package:cattlehealthtracker/common/custom_exceptions.dart';
import 'package:cattlehealthtracker/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChangePasswordFormWidget extends StatefulWidget {
  const ChangePasswordFormWidget({super.key});

  @override
  State<ChangePasswordFormWidget> createState() => _ChangePasswordFormWidgetState();
}

class _ChangePasswordFormWidgetState extends State<ChangePasswordFormWidget> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:  EdgeInsets.only(bottom: 15.h),
                child: Text(S.of(context).changePassword,style: TextStyle(fontFamily: "Tajawal", fontWeight: FontWeight.bold, fontSize: 25.sp),
                textAlign: TextAlign.center,
                ),
              ),
              CustomTextFormField(controller: newPasswordController, type: "password", hintText: S.of(context).newPassword,
              validator: (p0) {
                  if(p0!.isEmpty){
                      return S.of(context).emptyPassword;
                    }
                    if(p0.length < 8){
                      return S.of(context).passwordMinLen;
                    }
                    if(p0 == oldPasswordController.text){
                      return S.of(context).passwordMatch;
                    }
              },
              ),

              CustomTextFormField(controller: oldPasswordController, type: "password", hintText: S.of(context).oldPaswword,
              validator: (p0) {
                  if(p0!.isEmpty){
                      return S.of(context).emptyPassword;
                    }
                    if(p0.length < 8){
                      return S.of(context).passwordMinLen;
                    }
                    if(p0 == newPasswordController.text){
                      return S.of(context).passwordMatch;
                    }
              },
              ),
  
              BlocListener<AuthenticationCubit, AuthenticationStates>(listener:(context, state) async{
              if( state is LogoutLoadingState){
                    showDialog(context: context, 
                    barrierDismissible: false,
                  builder:(context) {
                    return AlertDialog(content: SingleChildScrollView(
                      child: Column(
                        children: [
                          Center(child: Text(S.of(context).loggingOut, style: TextStyle(fontFamily: "Tajawal", fontSize: 18.sp, fontWeight: FontWeight.bold),)),
                          Center(child: CircularProgressIndicator(color: AppColors.greenColor,),)
                        ],),
                    ),);
                  },);
                }

                if(state is ChangePasswordSuccessState){
                  print("change password successful");
                  await context.read<AuthenticationCubit>().logout();
                }
                
                if(state is OldPasswordIsIncorrect){
                showDialog(context: context, builder:(context) {
                  return AlertDialog(
                   content: Text(S.of(context).oldPasswordIncorrect, style: Theme.of(context).textTheme.bodyLarge,),
                   actionsAlignment: MainAxisAlignment.center,
               actions: [
                    CustomButton(
                    text: S.of(context).Continue,
                    onTap: () async{
                      Navigator.of(context).pop();
                    },
                    ),
                  ],
                  );
                },);
                }
              },
              
              child:  BlocBuilder<AuthenticationCubit, AuthenticationStates>(builder:(context, state) {
                return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: SizedBox(
                  height: 65.h,
                  width: double.infinity,
                  child: CustomButton(text: state is ChangePasswordLoading? S.of(context).Change + "...": S.of(context).Change, onTap: state is ChangePasswordLoading  || state is LogoutLoadingState? null : () async{
                    if(formKey.currentState!.validate()){

                      await context.read<AuthenticationCubit>().changePassword(oldPasswordController.text, newPasswordController.text);
                    }
                  },),
                ),
              );
              },)
          
              ),
             
              BlocBuilder<AuthenticationCubit, AuthenticationStates>(builder:(context, state) {
                return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
                child: SizedBox(
                  height: 65.h,
                  width: double.infinity,
                  child: CustomButton(text: S.of(context).cancel, bgColor: Colors.red, onTap: state is ChangePasswordLoading || state is LogoutLoadingState? null : () {
                    Navigator.of(context).pop();
                  },),
                ),
              );
              },)
            ],
          ),
        ),
      ),
    );
  }
}