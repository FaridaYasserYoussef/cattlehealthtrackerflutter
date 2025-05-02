import 'dart:async';

import 'package:cattlehealthtracker/authentication/view-model/authentication_cubit.dart';
import 'package:cattlehealthtracker/authentication/view-model/authentication_states.dart';
import 'package:cattlehealthtracker/authentication/view/widgets/custom_button.dart';
import 'package:cattlehealthtracker/authentication/view/widgets/otp_text_field.dart';
import 'package:cattlehealthtracker/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';


class OtpFormWidget extends StatefulWidget {
  const OtpFormWidget({super.key, required this.afterCancellationCallBack, required this.email});
  final void Function() afterCancellationCallBack;
  final String email;
  @override
  State<OtpFormWidget> createState() => _OtpFormWidgetState();
}

class _OtpFormWidgetState extends State<OtpFormWidget> {
List<TextEditingController> controllerList = List.generate(6, (val)=>TextEditingController());
bool sendClickedBefore  = false;
int resendAfter= 10;
bool resendDisabled = true;
bool submitDisabled = false;
int submitAfter = 10;
 Timer? resendTimer;
 Timer? submitTimer;
AuthenticationCubit authCubit  = GetIt.instance<AuthenticationCubit>();
@override
  void initState() {
    // TODO: implement initState
    
    startResendTimer();
    super.initState();
  }
void startResendTimer(){
  resendTimer = Timer.periodic(Duration(seconds: 1), (timer){
    if(resendAfter == 0){
      setState(() {
        resendDisabled = false;
        resendTimer!.cancel();  
      });
    }else{
      setState(() {
        resendAfter--;
      });
    }
  });
}

void startSubmitTimer(){
  submitTimer = Timer.periodic(Duration(seconds: 1), (timer){
    if(submitAfter == 0){
      setState(() {
        submitDisabled = false;
        submitTimer!.cancel();
      });
    }else{
      setState(() {
        submitAfter--;
      });
    }

  });
}

  @override
Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Directionality(
            textDirection:TextDirection.ltr,
            child: Row(
              // textDirection: TextDirection.ltr,
              children: [
              // the textfields go here
             OtpTextField(
              placeholder: "0",
              controller: controllerList[0],
              onChanged:(p0) {
                  if(p0.length == 1){
                    FocusScope.of(context).nextFocus();
                  }
              },
             ),
            
            OtpTextField(
              placeholder: "1",
              controller: controllerList[1],
              onChanged:(p0) {
                  if(p0.length == 1){
                    FocusScope.of(context).nextFocus();
                  }
              },
             ),
            
              OtpTextField(
                placeholder: "2",
              controller: controllerList[2],
              onChanged:(p0) {
                  if(p0.length == 1){
                    FocusScope.of(context).nextFocus();
                  }
              },
             ),
             
               OtpTextField(
                placeholder: "3",
              controller: controllerList[3],
              onChanged:(p0) {
                  if(p0.length == 1){
                    FocusScope.of(context).nextFocus();
                  }
              },
             ),
            
            OtpTextField(
              placeholder: "4",
              controller: controllerList[4],
              onChanged:(p0) {
                  if(p0.length == 1){
                    FocusScope.of(context).nextFocus();
                  }
              },
             ),
            
            
               OtpTextField(
                placeholder: "5",
              controller: controllerList[5],
              onChanged:(p0) {
                  if(p0.length == 1){
                    FocusScope.of(context).nextFocus();
                  }
              },
             ),
            
            ],
            
            ),
          ),
        ),
    
   
            BlocListener<AuthenticationCubit, AuthenticationStates>(listener:(context, state) {
              if(state is ResendOtpSuccessState){
                double currentTime = DateTime.now().millisecondsSinceEpoch / 1000;
                double secondsLeft = state.resendCoolDownSecondsLeft - currentTime;
                int resendCoolDownSecondsLeftInt = secondsLeft.floor();
                if(resendCoolDownSecondsLeftInt > 0){
                  setState(() {
                    resendAfter = resendCoolDownSecondsLeftInt;
                    if(!resendTimer!.isActive){
                      startResendTimer();
                    }
                  });
                }
              }
                      
            },
            child: BlocBuilder<AuthenticationCubit, AuthenticationStates>(builder:(context, state) {
              if(resendTimer!.isActive || state is AuthenticationLoadingState){
                 return Padding(
                   padding:  EdgeInsets.only(bottom: 10.h),
                   child: SizedBox(
                  height: 65.h,

                    width: double.infinity,
                    child: CustomButton(text:S.of(context).resendAfter + " ${resendAfter}")),
                 );
              }
              return Padding(
                   padding:  EdgeInsets.only(bottom: 10.h),
                child: SizedBox(
                  height: 65.h,
                  width: double.infinity,
                  child: CustomButton(text:S.of(context).resend, onTap: () async{
                    startResendTimer();
                    await authCubit.resendOtp(widget.email); // to do
                  },),
                ),
              );
              
            },),
            ),
            
          
          BlocListener<AuthenticationCubit, AuthenticationStates>(listener:(context, state) {
            // if state is SurPassed attempts pop
           if(state is SurpassedAttemptsOtpErrorState){
            // call back function from login that resets all textfields
            widget.afterCancellationCallBack();
            Navigator.of(context).pop();
           }
          
           if(state is  VerifyOtpErrorState){
          double currentTime = DateTime.now().millisecondsSinceEpoch /1000;
          double submitCoolDownTime =  state.submitCoolDownSecondsEnd;
          double submitCoolDownEnds = submitCoolDownTime - currentTime;
          int submitCoolDownEndsInt = submitCoolDownEnds.floor();
          
          if(submitCoolDownEndsInt > 0){
          
            setState(() {
              submitAfter = submitCoolDownEndsInt;
              if(submitTimer == null || !submitTimer!.isActive){
                startSubmitTimer();
              }
            });
          }
          
          
           }
          
          },
          child:  BlocBuilder<AuthenticationCubit, AuthenticationStates>(
            builder: (context, state) {
             if(state is AuthenticationLoadingState || (submitTimer != null && submitTimer!.isActive) ){
              return Padding(
                   padding:  EdgeInsets.only(bottom: 10.h),
                child: SizedBox(
                  height: 65.h,
                  width: double.infinity,
                  child: CustomButton(text: S.of(context).verifyAfter + " ${submitAfter}")),
              );
          
             }
             return Padding(
                   padding:  EdgeInsets.only(bottom: 10.h),
               child: SizedBox(
                height: 65.h,
          
                width: double.infinity,
                 child: CustomButton(text: S.of(context).verifyOtp, onTap: ()async{
                  String otpString = "";
                  for(TextEditingController controller in controllerList){
                     otpString = otpString + controller.text;
                  }
                  startSubmitTimer();
                  await authCubit.verifyOtp(otpString);
                 },),
               ),
             );
          
          
            }
          ),
          
          ),
                 
          Padding(
                   padding:  EdgeInsets.only(bottom: 10.h),
            child: SizedBox(
              height: 65.h,
              width: double.infinity,
              child: CustomButton(text: S.of(context).cancel, bgColor: Colors.red,
              onTap:() {
                // call back function from login that resets all textfields
                widget.afterCancellationCallBack();
                Navigator.of(context).pop();
              } ,
              
              ),
            ),
          ),
          
       
      ],
    );
  }
}