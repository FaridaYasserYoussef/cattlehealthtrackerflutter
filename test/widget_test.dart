// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:cattlehealthtracker/api/api.dart';
import 'package:cattlehealthtracker/api/dio_service.dart';
import 'package:cattlehealthtracker/authentication/repository/authentication_repository.dart';
import 'package:cattlehealthtracker/authentication/view-model/authentication_cubit.dart';
import 'package:cattlehealthtracker/authentication/view-model/authentication_states.dart';
import 'package:cattlehealthtracker/authentication/view/screens/users_login_screen.dart';
import 'package:cattlehealthtracker/authentication/view/widgets/custom_button.dart';
import 'package:cattlehealthtracker/authentication/view/widgets/custom_text_form_field.dart';
import 'package:cattlehealthtracker/authentication/view/widgets/otp_form_widget.dart';
import 'package:cattlehealthtracker/common/app_colors.dart';
import 'package:cattlehealthtracker/common/app_themes.dart';
import 'package:cattlehealthtracker/common/cattle_screen.dart';
import 'package:cattlehealthtracker/common/culling_screen.dart';
import 'package:cattlehealthtracker/common/home_screen.dart';
import 'package:cattlehealthtracker/common/roles_screen.dart';
import 'package:cattlehealthtracker/common/users_screen.dart';
import 'package:cattlehealthtracker/settings/view-model/settings_cubit.dart';
import 'package:cattlehealthtracker/settings/view-model/settings_state.dart';
import 'package:cattlehealthtracker/settings/view/settings_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cattlehealthtracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cattlehealthtracker/generated/l10n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fake_async/fake_async.dart';
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
                    home: state.settingsModel.isloggedIn? HomeScreen(storage: mockStorage, scaffoldKey: scaffoldKey,): UserLoginScreen(storage: mockStorage,scaffoldKey: scaffoldKey,),
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
            home: UserLoginScreen(storage: mockStorage,scaffoldKey: scaffoldKey,),
            // home: childAll,
                  );
              }
            },),
          ),
        );
      },

    );
}

// class MockAuthRepository extends Mock implements AuthenticationRepository {}
// class MockDioService extends Mock implements DioService{}
late MockAuthenticationRepository mockRepo;
late GlobalKey<ScaffoldState> scaffoldKey;
Future<void> setupTestEnvironment({
  Map<String, Object>? mockPrefs,
}) async {
  // Reset GetIt before registering again
  await GetIt.instance.reset(); // This clears all registered instances

  // Set up SharedPreferences with optional mock data
  SharedPreferences.setMockInitialValues(mockPrefs ?? {});
   mockRepo = MockAuthenticationRepository();
   
  // Register Cubits
  GetIt.instance.registerSingleton<AuthenticationCubit>(AuthenticationCubit.test(mockRepo, MockFlutterSecureStorage()));
}

@GenerateMocks([AuthenticationRepository, FlutterSecureStorage])

void _onErrorIgnoreOverflowErrors(
  FlutterErrorDetails details, {
  bool forceReport = false,
}) {
  final exception = details.exception;

  // Check if this is a RenderFlex overflow by examining the exception message directly
  final isOverflowError = exception.toString().contains('A RenderFlex overflowed by');

  if (isOverflowError) {
    debugPrint('Ignored a RenderFlex overflow error.');
    return;
  }

  // Pass through other errors
  FlutterError.dumpErrorToConsole(details, forceReport: forceReport);
}
void main() {
 MockFlutterSecureStorage mockStorage = MockFlutterSecureStorage();

group("Login mock apis tests", (){
  setUp(() async{
    await setupTestEnvironment(mockPrefs: {
      'isLoggedIn': false,
      'locale': 'en',
      'theme': 'dark',
      'twoFaEnabled': false
    });    
   
    });
testWidgets("Login Successful", (tester)async{

when(mockRepo.login("valid@email.com", "correctPassword"))
    .thenAnswer((_) async => {
    "detail": "login successful",
    "user": {
        "first_name": "Farah",
        "last_name": "Yasser Youssef",
        "mobile_number": "+201012226477",
        "email": "faridarunshercode@gmail.com",
        "two_fa_enabled": false,
        "role": "admin",
        "features": [
            "Dashboard",
            "Users",
            "Cattle",
            "Culling",
            "Logs",
            "Medicines",
            "Settings",
            "Roles"
        ]
    },
    "refresh": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MDAzOTM5NCwiaWF0IjoxNzQ3NDQ3Mzk0LCJqdGkiOiJkMjFlN2QwYzY5OGQ0NzY0OTQwZmY3YmZlODYwY2Y3OCIsInVzZXJfaWQiOjR9.X0429P0DeFW8rbA6HUFi867D3-j-TH6qvUAF5DTpxvc",
    "access": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzQ3NDQ3Njk0LCJpYXQiOjE3NDc0NDczOTQsImp0aSI6IjY5NzVjMWM4ODJhMzRiNTg5OWM4NjY2YTk5YTRiM2NmIiwidXNlcl9pZCI6NH0.CgqdW87WyurSk6JwxzboWVijhbESQnWm0QdUgrcfNrg"
});
when(mockStorage.read(key: "features")).thenAnswer((_) async => '["Dashboard", "Users", "Cattle", "Culling", "Logs", "Medicines", "Settings", "Roles"]');
scaffoldKey = GlobalKey<ScaffoldState>();
final widget = await createLocalizedTestWidget(mockStorage, scaffoldKey);
 await tester.pumpWidget(widget);
 await tester.pumpAndSettle();
 await tester.enterText(find.widgetWithText(CustomTextFormField, "Email"), "valid@email.com");
 await tester.enterText(find.widgetWithText(CustomTextFormField, "Password"), "correctPassword");
 await tester.tap(find.widgetWithText(CustomButton, "Login"));
 await tester.pumpAndSettle(); 
expect(find.byType(HomeScreen), findsOneWidget);


});

testWidgets("Login Failed", (tester)async{
when(mockRepo.login("fofo@gmail.com", "fiha2003")).thenThrow(Exception("failed to login"));
scaffoldKey = GlobalKey<ScaffoldState>();
 final widget = await createLocalizedTestWidget(mockStorage, scaffoldKey);
 await tester.pumpWidget(widget);
 await tester.pumpAndSettle();
 await tester.enterText(find.widgetWithText(CustomTextFormField, "Email"), "fofo@gmail.com");
 await tester.enterText(find.widgetWithText(CustomTextFormField, "Password"), "fiha2003");
 await tester.tap(find.widgetWithText(CustomButton, "Login"));
 await tester.pump();
 expect(find.widgetWithText(CustomButton, "Login"), findsOneWidget);
});

});



  group("Login UI tests", (){
    setUp(() async{
    await setupTestEnvironment(mockPrefs: {
      'isLoggedIn': false,
      'locale': 'en',
      'theme': 'dark',
      'twoFaEnabled': false
    });
    });
testWidgets("test the presence of textfields and login button", (tester)async{
scaffoldKey = GlobalKey<ScaffoldState>();

final widget = await createLocalizedTestWidget(mockStorage, scaffoldKey);
await tester.pumpWidget(widget);
await tester.pumpAndSettle();
expect(find.text("Email"), findsOneWidget);
expect(find.text("Password"), findsOneWidget);
expect(find.widgetWithText(CustomButton, "Login"), findsOneWidget);
});

testWidgets("test email verification without @", (tester) async{
scaffoldKey = GlobalKey<ScaffoldState>();

final widget = await createLocalizedTestWidget(mockStorage, scaffoldKey);
await tester.pumpWidget(widget);
await tester.pumpAndSettle();
await tester.enterText(find.widgetWithText(CustomTextFormField, "Email"), "farida.yasser");
await tester.tap(find.widgetWithText(CustomButton, "Login"));
await tester.pump();
expect(find.text("Email must contain @"), findsOneWidget);
});
testWidgets("test email verification without .com", (tester) async{
  scaffoldKey = GlobalKey<ScaffoldState>();

final widget = await createLocalizedTestWidget(mockStorage, scaffoldKey);
await tester.pumpWidget(widget);
await tester.pumpAndSettle();
await tester.enterText(find.widgetWithText(CustomTextFormField, "Email"), "farida.yasser510@gmail");
await tester.tap(find.widgetWithText(CustomButton, "Login"));
await tester.pump();
expect(find.text("Email must end with .com"), findsOneWidget);
});

testWidgets("test email verification empty", (tester) async{
  scaffoldKey = GlobalKey<ScaffoldState>();

final widget = await createLocalizedTestWidget(mockStorage, scaffoldKey);
await tester.pumpWidget(widget);
await tester.pumpAndSettle();
await tester.enterText(find.widgetWithText(CustomTextFormField, "Email"), "");
await tester.tap(find.widgetWithText(CustomButton, "Login"));
await tester.pump();
expect(find.text("Email can't be empty"), findsOneWidget);
});

testWidgets("test password verification empty", (tester) async{
  scaffoldKey = GlobalKey<ScaffoldState>();

final widget = await createLocalizedTestWidget(mockStorage, scaffoldKey);
await tester.pumpWidget(widget);
await tester.pumpAndSettle();
await tester.enterText(find.widgetWithText(CustomTextFormField, "Password"), "");
await tester.tap(find.widgetWithText(CustomButton, "Login"));
await tester.pump();
expect(find.text("Password can't be empty"), findsOneWidget);
});

testWidgets("test password verification less than 8 chars", (tester) async{
  scaffoldKey = GlobalKey<ScaffoldState>();

final widget = await createLocalizedTestWidget(mockStorage, scaffoldKey);
await tester.pumpWidget(widget);
await tester.pumpAndSettle();
await tester.enterText(find.widgetWithText(CustomTextFormField, "Password"), "abcd567");
await tester.tap(find.widgetWithText(CustomButton, "Login"));
await tester.pump();
expect(find.text("Password is at least 8 characters"), findsOneWidget);
});
  });




group("Settings page tests", (){
  setUp(() async{
    await setupTestEnvironment(mockPrefs: {
      'isLoggedIn': true,
      'locale': 'en',
      'theme': 'light',
      'twoFaEnabled': false
    });
   
    });

testWidgets("Localization testing", (tester)async{
FlutterError.onError = _onErrorIgnoreOverflowErrors;
tester.view.devicePixelRatio = 2.0;
tester.view.physicalSize = const Size(720, 1600);
    when(mockStorage.read(key: "features")).thenAnswer((_) async => '["Dashboard", "Users", "Cattle", "Culling", "Logs", "Medicines", "Settings", "Roles"]');
    scaffoldKey = GlobalKey<ScaffoldState>();
      final widget = await createLocalizedTestWidget(mockStorage, scaffoldKey);
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      scaffoldKey.currentState!.openDrawer();
      await tester.pumpAndSettle();  
      await tester.drag(find.byType(Drawer), Offset(0, -400));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(Container, "Settings"));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(Row, "اللغة"), findsNothing);
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DropdownMenuItem<String>, "ar"));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(Row, "اللغة"), findsOneWidget);
      expect(find.widgetWithText(DropdownButton<String>, "ar"), findsOneWidget);
      expect(find.widgetWithText(DropdownButton<String>, "en"), findsNothing);
    });

  testWidgets("Theme testing", (tester)async{
    FlutterError.onError = _onErrorIgnoreOverflowErrors;
    tester.view.devicePixelRatio = 2.0;
    tester.view.physicalSize = const Size(720, 1600);
    when(mockStorage.read(key: "features")).thenAnswer((_) async => '["Dashboard", "Users", "Cattle", "Culling", "Logs", "Medicines", "Settings", "Roles"]');
    scaffoldKey = GlobalKey<ScaffoldState>();
    final widget = await createLocalizedTestWidget(mockStorage, scaffoldKey);
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
    scaffoldKey.currentState!.openDrawer();
    await tester.pumpAndSettle();
    final drawer = tester.widget<Drawer>(find.byType(Drawer));
    expect(drawer.backgroundColor, equals(AppColors.backgroundColorLight));
    await tester.tap(find.widgetWithText(Container, "Settings"));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('darkModeSwitch')));
    await tester.pumpAndSettle();
    scaffoldKey.currentState!.openDrawer();
    await tester.pumpAndSettle();
    final drawerAfter = tester.widget<Drawer>(find.byType(Drawer));
    expect(drawerAfter.backgroundColor, equals(AppColors.backgroundColorDark));
    });




  testWidgets("Toggle 2fa successful test", (tester)async{
   FlutterError.onError = _onErrorIgnoreOverflowErrors;
    tester.view.devicePixelRatio = 2.0;
    tester.view.physicalSize = const Size(720, 1600);
   scaffoldKey =  GlobalKey<ScaffoldState>();
   when(mockRepo.toggle2fa()).thenAnswer((_) async => true);
   when(mockStorage.read(key: "features")).thenAnswer((_) async => '["Dashboard", "Users", "Cattle", "Culling", "Logs", "Medicines", "Settings", "Roles"]');
   final widget = await createLocalizedTestWidget(mockStorage, scaffoldKey);
   await tester.pumpWidget(widget);
   await tester.pumpAndSettle();
   scaffoldKey.currentState!.openDrawer();
   await tester.pumpAndSettle();
   await tester.tap(find.widgetWithText(Container, "Settings"));
   await tester.pumpAndSettle();
   await tester.tap(find.byKey(const Key('toggle2faSwitch')));
   await tester.pumpAndSettle();
   final twoFaSwitch = tester.widget<Switch>(find.byKey(const Key('toggle2faSwitch')));
   expect(twoFaSwitch.value, isTrue);

    });

  testWidgets("toggle 2fa failed test", (tester)async{
    FlutterError.onError = _onErrorIgnoreOverflowErrors;
    tester.view.devicePixelRatio = 2.0;
    tester.view.physicalSize = const Size(720, 1600);
    scaffoldKey = GlobalKey<ScaffoldState>();
    when(mockRepo.toggle2fa()).thenAnswer((_) async =>false);
    when(mockStorage.read(key: "features")).thenAnswer((_) async => '["Dashboard", "Users", "Cattle", "Culling", "Logs", "Medicines", "Settings", "Roles"]');
    final widget = await createLocalizedTestWidget(mockStorage, scaffoldKey);
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
    scaffoldKey.currentState!.openDrawer();
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(Container, "Settings"));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('toggle2faSwitch')));
    await tester.pumpAndSettle();
    final twoFaSwitch = tester.widget<Switch>(find.byKey(const Key('toggle2faSwitch')));
    expect(twoFaSwitch.value, isFalse);
  });
  testWidgets("change password test", (tester)async{});
});


group("OTP tests", (){
    setUp(() async{
    await setupTestEnvironment(mockPrefs: {
      'isLoggedIn': false,
      'locale': 'en',
      'theme': 'dark',
      'twoFaEnabled': true
    });
    });
  
  testWidgets("OTP pop-up appears", (tester)async{
    await tester.runAsync(()async{
    FlutterError.onError = _onErrorIgnoreOverflowErrors;
    tester.view.devicePixelRatio = 2.0;
    tester.view.physicalSize = const Size(720, 1600);
    when(mockRepo.login("farida.yasser510@gmail.com", "Dida2003")).thenAnswer((_) async => {"detail":  "2fa-enabled","user_authenticated": true, "email": "farida.yasser510@gmail.com", "resend_cooldown": (DateTime.now().millisecondsSinceEpoch / 1000) + 10});
    scaffoldKey = GlobalKey<ScaffoldState>();
    final widget = await createLocalizedTestWidget(mockStorage, scaffoldKey);
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(CustomTextFormField, "Email"), "farida.yasser510@gmail.com");
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(CustomTextFormField, "Password"), "Dida2003");
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CustomButton, "Login"));
    await tester.pump();
    expect(find.byType(OtpFormWidget), findsOneWidget);
    });


    
  });


  testWidgets("verify OTP fails", (tester)async{
    
  });

  testWidgets("verify OTP succeeds", (tester)async{});

  testWidgets("resend UI change", (tester)async{});

});

}
