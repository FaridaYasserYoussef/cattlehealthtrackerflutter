import 'package:cattlehealthtracker/authentication/view/screens/users_login_screen.dart';
import 'package:cattlehealthtracker/common/app_themes.dart';
import 'package:cattlehealthtracker/common/home_screen.dart';
import 'package:cattlehealthtracker/settings/view-model/settings_cubit.dart';
import 'package:cattlehealthtracker/settings/view-model/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
void main()  {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child){
        return BlocProvider<SettingsCubit>(create:(context) => SettingsCubit()..getSettings(),
        child: BlocBuilder<SettingsCubit, SettingsState>(
          buildWhen: (previous, current) => previous != current,
          builder:(context, state) {
            if(state is SettingsSuccessState){
                return MaterialApp(
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
          return MaterialApp(
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
        },),
        );
      },

    );
  }
}



