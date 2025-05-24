

import 'dart:io';

import 'package:cattlehealthtracker/api/api.dart';
import 'package:cattlehealthtracker/api/dio_service.dart';
import 'package:cattlehealthtracker/authentication/view-model/authentication_cubit.dart';
import 'package:cattlehealthtracker/authentication/view-model/authentication_states.dart';
import 'package:cattlehealthtracker/authentication/view/screens/users_login_screen.dart';
import 'package:cattlehealthtracker/authentication/view/widgets/custom_button.dart';
import 'package:cattlehealthtracker/common/app_colors.dart';
import 'package:cattlehealthtracker/common/app_themes.dart';
import 'package:cattlehealthtracker/common/home_screen.dart';
import 'package:cattlehealthtracker/generated/l10n.dart';
import 'package:cattlehealthtracker/main.dart';
import 'package:cattlehealthtracker/settings/view-model/settings_cubit.dart';
import 'package:cattlehealthtracker/settings/view-model/settings_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widget_test.dart';
import 'widget_test.mocks.dart';



Future<Widget> createLocalizedTestWidget(MockFlutterSecureStorage mockStorage, GlobalKey<ScaffoldState> scaffoldKey)async{
  final settingsCubit = SettingsCubit();
  await settingsCubit.getSettings();

  // GetIt.instance.registerSingleton<AuthenticationCubit>(AuthenticationCubit());
  return  ScreenUtilInit(
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
              MaterialPageRoute(builder: (_) =>  UserLoginScreen(storage: mockStorage, scaffoldKey: scaffoldKey,)),
              (_) => false,
            );
            // Fluttertoast.showToast(
            //   msg: S.of(context).logoutSuccess,
            //   backgroundColor: AppColors.greenColor,
            // );
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
                    home: state.settingsModel.isloggedIn? HomeScreen(storage: mockStorage, scaffoldKey: scaffoldKey,): UserLoginScreen(storage: mockStorage ,scaffoldKey: scaffoldKey,),
                    // home: childAll
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
            home: UserLoginScreen(storage: mockStorage, scaffoldKey: scaffoldKey,),
            // home: childAll,
                  );
              }
            },),
          ),
        );
      },

    );
}


late GlobalKey<ScaffoldState> scaffoldKey;

Future<void> setupTestEnvironment({
  Map<String, Object>? mockPrefs,
   required FlutterSecureStorage mockStorage

}) async {
  // Reset GetIt before registering again
  await GetIt.instance.reset(); // This clears all registered instances

  // Set up SharedPreferences with optional mock data
  SharedPreferences.setMockInitialValues(mockPrefs ?? {});
  //  mockRepo = MockAuthenticationRepository();
   
  // Register Cubits
  GetIt.instance.registerSingleton<AuthenticationCubit>(AuthenticationCubit(storage: mockStorage));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context);
  }
}


void main(){
late Dio dio;
 late DioService dioService;
 late DioAdapter dioAdapter;
  MockFlutterSecureStorage mockStorage = MockFlutterSecureStorage();




  group("DioService Tests", (){
 setUp(()async{
  

 
  await mockStorage.write(key: "email", value: "faridarunshercode@gmail.com");
    await mockStorage.write(key: "phone", value: "+201012226477");
    await mockStorage.write(key: "features", value: '["Dashboard", "Users", "Cattle", "Culling", "Logs", "Medicines", "Settings", "Roles"]');
    await mockStorage.write(key: "refresh", value: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MDAzOTM5NCwiaWF0IjoxNzQ3NDQ3Mzk0LCJqdGkiOiJkMjFlN2QwYzY5OGQ0NzY0OTQwZmY3YmZlODYwY2Y3OCIsInVzZXJfaWQiOjR9.X0429P0DeFW8rbA6HUFi867D3-j-TH6qvUAF5DTpxvc");
    await mockStorage.write(key: "access",value: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzQ3NDQ3Njk0LCJpYXQiOjE3NDc0NDczOTQsImp0aSI6IjY5NzVjMWM4ODJhMzRiNTg5OWM4NjY2YTk5YTRiM2NmIiwidXNlcl9pZCI6NH0.CgqdW87WyurSk6JwxzboWVijhbESQnWm0QdUgrcfNrg");

  await setupTestEnvironment(mockPrefs: {
      'isLoggedIn': true,
      'locale': 'en',
      'theme': 'dark',
      'twoFaEnabled': false
    },
    mockStorage: mockStorage
    );

    HttpOverrides.global = MyHttpOverrides();
 });



 testWidgets("Refresh Token expired integration test", (tester) async{
  await tester.runAsync(()async{
  
  dioService = DioService();
  dioService.configureDio(
    baseUrl: "https://example.com", 
  );
  dio = dioService.getDioInstance();
  dioAdapter = DioAdapter(dio: dio);
  dio.httpClientAdapter = dioAdapter;
  when(mockStorage.read(key: "features")).thenAnswer((_) async =>'["Dashboard", "Users", "Cattle", "Culling", "Logs", "Medicines", "Settings", "Roles"]');
  scaffoldKey = GlobalKey<ScaffoldState>();

final widget = await createLocalizedTestWidget(mockStorage, scaffoldKey);
 await tester.pumpWidget(widget);
 expect(find.byType(HomeScreen), findsOneWidget);
dioAdapter.onPost(
  "endPoint/MeshMawgooda",
  (server)=> server.reply(401, {"error": "Refresh token expired"})
);
try{
  await dio.post("endPoint/MeshMawgooda");
} on DioException catch (e) {
 await tester.pumpAndSettle();
 expect(find.widgetWithText(CustomButton, "Login"), findsOneWidget);
}


  });

 });

 });
}