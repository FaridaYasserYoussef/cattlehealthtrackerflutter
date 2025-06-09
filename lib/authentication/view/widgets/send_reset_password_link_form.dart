import 'package:cattlehealthtracker/authentication/view-model/authentication_cubit.dart';
import 'package:cattlehealthtracker/authentication/view-model/authentication_states.dart';
import 'package:cattlehealthtracker/authentication/view/widgets/custom_button.dart';
import 'package:cattlehealthtracker/authentication/view/widgets/custom_text_form_field.dart';
import 'package:cattlehealthtracker/common/app_colors.dart';
import 'package:cattlehealthtracker/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SendResetPasswordLinkForm extends StatefulWidget {
  const SendResetPasswordLinkForm({super.key});

  @override
  State<SendResetPasswordLinkForm> createState() => _SendResetPasswordLinkFormState();
}

class _SendResetPasswordLinkFormState extends State<SendResetPasswordLinkForm> {
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(children: [
          Text(S.of(context).sendResetPaswordLink, style: TextStyle(
            fontFamily: "Tajawal",
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.greenColor
          ),
          textAlign: TextAlign.center,
          ),
        
        CustomTextFormField(controller: emailController, type: "text", hintText: S.of(context).email,
        validator: (p0) {
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
        BlocListener<AuthenticationCubit, AuthenticationStates>(listener:(context, state) {
         if(state is SendPasswordResetLinkSuccessState){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: S.of(context).emailSent);
         }

         if(state is SendPasswordResetLinkUserNotFoundErrorState){

            showDialog(context: context, builder:(context) {
              return AlertDialog(
                content: Text(S.of(context).emailNotFound, style: Theme.of(context).textTheme.bodyLarge,),
              actions: [
                CustomButton(text: S.of(context).Continue,
                onTap: () {
                  Navigator.pop(context);
                },
                )
              ],
              actionsAlignment: MainAxisAlignment.center,
              );
            },
            
            );

         }

         if(state is SendPasswordResetLinkFailedToSendEmailState){
            showDialog(context: context, builder:(context) {
              return AlertDialog(
                content: Text(S.of(context).failedToSendEmail, style: Theme.of(context).textTheme.bodyLarge,),
                actions: [
                CustomButton(text: S.of(context).Continue,
                onTap: () {
                  Navigator.pop(context);
                },
                )

                ],
              actionsAlignment: MainAxisAlignment.center,

              );
            },);
         }
          
        },
        
        child: BlocBuilder<AuthenticationCubit, AuthenticationStates>(builder:(context, state) {
          return CustomButton(text: S.of(context).send, 
           onTap: state is SendPasswordResetLinkLoadingState? null: ()async{
            if(formKey.currentState!.validate()){
            await context.read<AuthenticationCubit>().sendResetPasswordLink(emailController.text);

            }
          },
          );
          
        },),
        ),
        
        BlocBuilder<AuthenticationCubit, AuthenticationStates>(builder:(context, state) {
          return CustomButton(text: S.of(context).cancel, bgColor: Colors.red,
          onTap: state is SendPasswordResetLinkLoadingState? null: (){
            Navigator.pop(context);
          },
          );
        },)
        ],),
      ),

    );
  }
}