import 'package:cattlehealthtracker/authentication/view-model/authentication_cubit.dart';
import 'package:cattlehealthtracker/authentication/view-model/authentication_states.dart';
import 'package:cattlehealthtracker/authentication/view/widgets/change_password_form_widget.dart';
import 'package:cattlehealthtracker/authentication/view/widgets/custom_button.dart';
import 'package:cattlehealthtracker/common/app_colors.dart';
import 'package:cattlehealthtracker/generated/l10n.dart';
import 'package:cattlehealthtracker/settings/view-model/settings_cubit.dart';
import 'package:cattlehealthtracker/settings/view-model/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

    late bool last2Fa;

  Future<List<String>>? getSettings() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String theme = prefs.getString("theme") ?? "light";
    String locale = prefs.getString("locale") ?? "ar";
    String two_fa = prefs.getBool("twoFaEnabled") == null? "false": prefs.getBool("twoFaEnabled") == true? "true": "false";
    List<String> result = [theme, locale, two_fa];
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSettings(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          last2Fa = snapshot.data![2] == "false"? false: true;
          return SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text(S.of(context).darkMode, style: Theme.of(context).textTheme.bodyMedium,),
                   BlocBuilder<SettingsCubit, SettingsState>(
                     builder: (context, state) {
                      String currentTheme;
                      if (state is SettingsSuccessState){
                        currentTheme = state.settingsModel.theme;
                      }else{
                      currentTheme = snapshot.data![0];
                      }
                       return Switch(
                        key: const Key('darkModeSwitch'),
                        // thumbColor: WidgetStateProperty.all(AppColors.greenColor),
                        // trackColor: WidgetStateProperty.all(Colors.grey),
                        activeColor: AppColors.greenColor,
            
                        value: currentTheme == "dark"? true: false, 
                        onChanged: (val)async{
                        if(val == true){
                          await context.read<SettingsCubit>().setTheme("dark");
                          
                        }
                        else{
                          await context.read<SettingsCubit>().setTheme("light");
                        }
                       });
            
                      
            
                     }
                   )
                 ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text(S.of(context).locale, style: Theme.of(context).textTheme.bodyMedium),
                   BlocBuilder<SettingsCubit, SettingsState>(
                     builder: (context, state) {
                      String currentLocale;
                      if(state is SettingsSuccessState){
                        currentLocale = state.settingsModel.locale;
                      }else{
                        currentLocale = snapshot.data![1];
                      }
                         return DropdownButton<String>(
                        value: currentLocale,
                        items: [
                          DropdownMenuItem(child: Text("ar"), value: "ar",),
                          DropdownMenuItem(child: Text("en"), value: "en",)
                        ], 
                        onChanged:(value) async{
                          await context.read<SettingsCubit>().setLocale(value!);
                        },);
              
                     }
                   )
                 ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text(S.of(context).twofa, style: Theme.of(context).textTheme.bodyMedium),
                   BlocBuilder<AuthenticationCubit, AuthenticationStates>(
                     builder: (context, state) {
                      bool current_two_fa_state;

                      if (state is Toggle2faSuccessState){
                        current_two_fa_state = state.twoFaEnabled;
                        last2Fa = current_two_fa_state;
                      }
                      else{
                      current_two_fa_state = last2Fa;
                      }

                      if(state is AuthenticationLoadingState){
                        return CircularProgressIndicator(color: AppColors.greenColor,);
                      }

                       return Switch(
                            key: const Key('toggle2faSwitch'),
                            activeColor: AppColors.greenColor,
                            value: current_two_fa_state, 
                            onChanged: (val)async{
                          await context.read<AuthenticationCubit>().toggle2fa();
                       });
            
                      
            
                     }
                   )
                 ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Text(S.of(context).changePassword, style: Theme.of(context).textTheme.bodyMedium),
                      CustomButton(text:  S.of(context).Change, onTap: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context, builder:(context) {
                          return AlertDialog(
                            content: ChangePasswordFormWidget(),
                           
                          );
                        },);
                      },)

                ],)
                    
              ],),
          ),);
        }else{
          return Center(child: CircularProgressIndicator(
            color: AppColors.greenColor,
          ),);
        }
      }
    );
  }
}