import 'package:cattlehealthtracker/common/app_images.dart';
import 'package:cattlehealthtracker/generated/l10n.dart';
import 'package:cattlehealthtracker/settings/view-model/settings_cubit.dart';
import 'package:cattlehealthtracker/settings/view-model/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  @override
  Widget build(BuildContext context) {
   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
     
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
                  DropdownMenuItem(child: Text("en"), value: "en",),
                  DropdownMenuItem(child: Text("ar"), value: "ar",)
        
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
                  child: Image.asset(Theme.of(context).brightness == Brightness.dark ? AppImages.logo_dark : AppImages.logo_light,
                  width: 180.w,
                  height: 180.h,
                  ),
                )
              ],
             ),
           )
          ),
        );

  }
}