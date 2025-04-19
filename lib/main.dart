import 'package:cattlehealthtracker/authentication/view-model/authentication_cubit.dart';
import 'package:cattlehealthtracker/authentication/view-model/authentication_states.dart';
import 'package:cattlehealthtracker/authentication/view/screens/users_login_screen.dart';
import 'package:cattlehealthtracker/common/app_colors.dart';
import 'package:cattlehealthtracker/common/app_themes.dart';
import 'package:cattlehealthtracker/common/home_screen.dart';
import 'package:cattlehealthtracker/settings/view-model/settings_cubit.dart';
import 'package:cattlehealthtracker/settings/view-model/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'package:get_it/get_it.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  final settingsCubit = SettingsCubit();
  await settingsCubit.getSettings();
  GetIt.instance.registerSingleton<AuthenticationCubit>(AuthenticationCubit());
  runApp( MyApp(settingsCubit: settingsCubit,));
}

class MyApp extends StatelessWidget {
  final SettingsCubit settingsCubit;
   MyApp({required this.settingsCubit, super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child){
        return MultiBlocProvider(
          providers: [
            BlocProvider<SettingsCubit>.value(value: settingsCubit,),
            BlocProvider<AuthenticationCubit>(create:(context) => GetIt.instance<AuthenticationCubit>(),)
          ],
          child: BlocListener<AuthenticationCubit, AuthenticationStates>(
            listenWhen: (previous, current) => current is LogoutSuccessState || current is AuthenticationErrorState,
            listener: (context, state) {
               if (state is LogoutSuccessState) {
                print("main logout Listener");
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const UserLoginScreen()),
              (_) => false,
            );
            Fluttertoast.showToast(
              msg: S.of(context).logoutSuccess,
              backgroundColor: AppColors.greenColor,
            );
          }
            },
            child: BlocBuilder<SettingsCubit, SettingsState>(
              buildWhen: (previous, current) => previous != current,
              builder:(context, state) {
                
                if(state is SettingsSuccessState){
                  print("Is Logged in value ${state.settingsModel.isloggedIn}");
                    return MaterialApp(
                      navigatorKey: navigatorKey,
                      locale: Locale(state.settingsModel.locale),
                      localizationsDelegates: [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                    debugShowCheckedModeBanner: false,
                    title: 'Flutter Demo',
                    // theme: ThemeData.dark(),
                    theme: state.settingsModel.theme == "dark"? AppThemes.darkTheme: AppThemes.lightTheme,
                    home: state.settingsModel.isloggedIn? HomeScreen(): UserLoginScreen(),
                  );
                }
              else{
                return MaterialApp(
                  navigatorKey: navigatorKey,
                localizationsDelegates: [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            home: UserLoginScreen(),
                  );
              }
            },),
          ),
        );
      },

    );
  }
}



