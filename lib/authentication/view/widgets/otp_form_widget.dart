import 'dart:async';

import 'package:cattlehealthtracker/authentication/view-model/authentication_cubit.dart';
import 'package:cattlehealthtracker/authentication/view-model/authentication_states.dart';
import 'package:cattlehealthtracker/authentication/view/widgets/custom_button.dart';
import 'package:cattlehealthtracker/authentication/view/widgets/otp_text_field.dart';
import 'package:cattlehealthtracker/common/custom_exceptions.dart';
import 'package:cattlehealthtracker/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
int submitAfter = 0;
 Timer? resendTimer;
 Timer? submitTimer;
 final FocusNode firstTextFieldFocusNode = FocusNode();
// AuthenticationCubit authCubit  = GetIt.instance<AuthenticationCubit>();

 @override
  void dispose() {
    firstTextFieldFocusNode.dispose();
    super.dispose();
  }
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
              textDirection: TextDirection.ltr,
              children: List.generate(6, (index){
                return OtpTextField(
                  focusNode: index == 0? firstTextFieldFocusNode: null,
              placeholder: index.toString(),
              controller: controllerList[index],
              onChanged:(p0) {
                  if(p0.length == 1 && index < 5){
                    FocusScope.of(context).nextFocus();
                  } else if(p0.length == 0 && index > 0){
                    FocusScope.of(context).previousFocus();
                  }
              },
             );
              }),
            
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
       

              if(resendTimer!.isActive || state is OtpResendLoadingState){
                 return Padding(
                   padding:  EdgeInsets.only(bottom: 10.h),
                   child: SizedBox(
                  height: 65.h,

                    width: double.infinity,
                    child: CustomButton(text: resendAfter == 0?
                                          (
                                            state is OtpResendLoadingState?
                                              S.of(context).resend + "...":
                                              S.of(context).resend
                                          ) 
                                        
                                        :
                                        S.of(context).resendAfter + " ${resendAfter}")),
                 );
              }
              return Padding(
                   padding:  EdgeInsets.only(bottom: 10.h),
                child: SizedBox(
                  height: 65.h,
                  width: double.infinity,
                  child: CustomButton(text:S.of(context).resend, onTap: state is OtpSubmitLoadingState || state is OtpResendLoadingState? null : () async{
                    // setState(() {
                    //   resendAfter = 10;
                    // });
                    startResendTimer();
                    // await authCubit.resendOtp(widget.email); // to do
                    await context.read<AuthenticationCubit>().resendOtp(widget.email);
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
                showDialog(context: context, builder:(context) {
                  return AlertDialog(
                    actionsAlignment: MainAxisAlignment.center,
                  content: Text(S.of(context).OTPAttemptsExceeded, style: Theme.of(context).textTheme.bodyLarge,),
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
          
           if(state is  VerifyOtpErrorState){
          double currentTime = DateTime.now().millisecondsSinceEpoch /1000;
          double submitCoolDownTime =  state.submitCoolDownSecondsEnd;
          double submitCoolDownEnds = submitCoolDownTime - currentTime;
          int submitCoolDownEndsInt = submitCoolDownEnds.floor();
          
          if(submitCoolDownEndsInt > 0){
          
            setState(() {
              submitAfter = submitCoolDownEndsInt;

              if(submitTimer == null ){
                  startSubmitTimer();
              }else if(!submitTimer!.isActive){
                  startSubmitTimer();
              }
              

            });

          }

           showDialog(context: context, builder:(context) {
                  return AlertDialog(
                    actionsAlignment: MainAxisAlignment.center,
                  content: Text(S.of(context).incorrectOTP, style: Theme.of(context).textTheme.bodyLarge,),
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
          child:  BlocBuilder<AuthenticationCubit, AuthenticationStates>(
            builder: (context, state) {
             if(state is OtpSubmitLoadingState){
              // print("state is ${state}");
              return Padding(
                   padding:  EdgeInsets.only(bottom: 10.h),
                child: SizedBox(
                  height: 65.h,
                  width: double.infinity,
                  child: CustomButton(text: S.of(context).verifyOtp + "...")),
              );
          
             }

             if (state is VerifyOtpErrorState){
              print("state is ${VerifyOtpErrorState}");
              
                return Padding(
                   padding:  EdgeInsets.only(bottom: 10.h),
                child: SizedBox(
                  height: 65.h,
                  width: double.infinity,
                  child: submitAfter > 0? CustomButton(text:S.of(context).verifyAfter + " ${submitAfter}"):
                  CustomButton(text: S.of(context).verifyOtp,
                  onTap: ()async{
                  String otpString = "";
                  for(TextEditingController controller in controllerList){
                    if(controller.text == ""){
                      Fluttertoast.showToast(msg: S.of(context).emptyOTP);
                      return;
                    }
                     otpString = otpString + controller.text;

                  }
                  for(TextEditingController controller in controllerList){
                     controller.text = "";
                     
                  }
                  FocusScope.of(context).requestFocus(firstTextFieldFocusNode);
                  print(otpString);
                  // submitAfter = 10;
                  // startSubmitTimer();
                  // await authCubit.verifyOtp(otpString);
                  await context.read<AuthenticationCubit>().verifyOtp(otpString, widget.email);
                 }
                  )
                  ),
              );
             }
             print("state is ${state}");
             return Padding(
                   padding:  EdgeInsets.only(bottom: 10.h),
               child: SizedBox(
                height: 65.h,
          
                width: double.infinity,
                 child: CustomButton(text: S.of(context).verifyOtp, onTap: state is OtpResendLoadingState? null : ()async{
                  String otpString = "";
                  for(TextEditingController controller in controllerList){
                    if(controller.text == ""){
                      Fluttertoast.showToast(msg: S.of(context).emptyOTP,
                      backgroundColor: Colors.red
                      );
                      return;
                    }
                     otpString = otpString + controller.text;

                  }
                  for(TextEditingController controller in controllerList){
                     controller.text = "";
                     
                  }
                  FocusScope.of(context).requestFocus(firstTextFieldFocusNode);
                  print(otpString);
                  await context.read<AuthenticationCubit>().verifyOtp(otpString, widget.email);
                 },),
               ),
             );
          
          
            }
          ),
          
          ),

          BlocBuilder<AuthenticationCubit, AuthenticationStates>(builder:(context, state) {
            return Padding(
                   padding:  EdgeInsets.only(bottom: 10.h),
            child: SizedBox(
              height: 65.h,
              width: double.infinity,
              child: CustomButton(text: S.of(context).cancel, bgColor: Colors.red,
              onTap:state is OtpResendLoadingState || state is OtpSubmitLoadingState? null: () {
                // call back function from login that resets all textfields
                widget.afterCancellationCallBack();
                Navigator.of(context).pop();
              } ,
              
              ),
            ),
          );
          },)
                 
          ,
          
       
      ],
    );
  }
}