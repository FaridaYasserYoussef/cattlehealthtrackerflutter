// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Continue`
  String get Continue {
    return Intl.message('Continue', name: 'Continue', desc: '', args: []);
  }

  /// `Change`
  String get Change {
    return Intl.message('Change', name: 'Change', desc: '', args: []);
  }

  /// `New`
  String get newPassword {
    return Intl.message('New', name: 'newPassword', desc: '', args: []);
  }

  /// `Old`
  String get oldPaswword {
    return Intl.message('Old', name: 'oldPaswword', desc: '', args: []);
  }

  /// `Logging out...`
  String get loggingOut {
    return Intl.message(
      'Logging out...',
      name: 'loggingOut',
      desc: '',
      args: [],
    );
  }

  /// `Old password is wrong`
  String get oldPasswordIncorrect {
    return Intl.message(
      'Old password is wrong',
      name: 'oldPasswordIncorrect',
      desc: '',
      args: [],
    );
  }

  /// `Passwords can't match`
  String get passwordMatch {
    return Intl.message(
      'Passwords can\'t match',
      name: 'passwordMatch',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Email can't be empty`
  String get emptyEmail {
    return Intl.message(
      'Email can\'t be empty',
      name: 'emptyEmail',
      desc: '',
      args: [],
    );
  }

  /// `OTP must be 6 digits`
  String get emptyOTP {
    return Intl.message(
      'OTP must be 6 digits',
      name: 'emptyOTP',
      desc: '',
      args: [],
    );
  }

  /// `An OTP has been sent to your email.`
  String get OTPFormMessage {
    return Intl.message(
      'An OTP has been sent to your email.',
      name: 'OTPFormMessage',
      desc: '',
      args: [],
    );
  }

  /// `Your OTP has expired. Please request a new one and enter the new OTP`
  String get OtpExpiration {
    return Intl.message(
      'Your OTP has expired. Please request a new one and enter the new OTP',
      name: 'OtpExpiration',
      desc: '',
      args: [],
    );
  }

  /// `You entered an incorrect OTP`
  String get incorrectOTP {
    return Intl.message(
      'You entered an incorrect OTP',
      name: 'incorrectOTP',
      desc: '',
      args: [],
    );
  }

  /// `You exceeded your 4 OTP Attempts`
  String get OTPAttemptsExceeded {
    return Intl.message(
      'You exceeded your 4 OTP Attempts',
      name: 'OTPAttemptsExceeded',
      desc: '',
      args: [],
    );
  }

  /// `Email must contain @`
  String get emailAt {
    return Intl.message(
      'Email must contain @',
      name: 'emailAt',
      desc: '',
      args: [],
    );
  }

  /// `Email must end with .com`
  String get emailDotCom {
    return Intl.message(
      'Email must end with .com',
      name: 'emailDotCom',
      desc: '',
      args: [],
    );
  }

  /// `Password can't be empty`
  String get emptyPassword {
    return Intl.message(
      'Password can\'t be empty',
      name: 'emptyPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password is at least 8 characters`
  String get passwordMinLen {
    return Intl.message(
      'Password is at least 8 characters',
      name: 'passwordMinLen',
      desc: '',
      args: [],
    );
  }

  /// `Login Successful`
  String get loginSuccess {
    return Intl.message(
      'Login Successful',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Logout Successful`
  String get logoutSuccess {
    return Intl.message(
      'Logout Successful',
      name: 'logoutSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Confirm logout`
  String get confirmLogout {
    return Intl.message(
      'Confirm logout',
      name: 'confirmLogout',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Dashboard`
  String get dashboard {
    return Intl.message('Dashboard', name: 'dashboard', desc: '', args: []);
  }

  /// `Users`
  String get users {
    return Intl.message('Users', name: 'users', desc: '', args: []);
  }

  /// `Cattle`
  String get cattle {
    return Intl.message('Cattle', name: 'cattle', desc: '', args: []);
  }

  /// `Culling`
  String get culling {
    return Intl.message('Culling', name: 'culling', desc: '', args: []);
  }

  /// `Logs`
  String get logs {
    return Intl.message('Logs', name: 'logs', desc: '', args: []);
  }

  /// `Medicines`
  String get medicines {
    return Intl.message('Medicines', name: 'medicines', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Roles`
  String get roles {
    return Intl.message('Roles', name: 'roles', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Dark mode`
  String get darkMode {
    return Intl.message('Dark mode', name: 'darkMode', desc: '', args: []);
  }

  /// `Language`
  String get locale {
    return Intl.message('Language', name: 'locale', desc: '', args: []);
  }

  /// `2F Authentication`
  String get twofa {
    return Intl.message('2F Authentication', name: 'twofa', desc: '', args: []);
  }

  /// `Verify`
  String get verifyOtp {
    return Intl.message('Verify', name: 'verifyOtp', desc: '', args: []);
  }

  /// `Verify after`
  String get verifyAfter {
    return Intl.message(
      'Verify after',
      name: 'verifyAfter',
      desc: '',
      args: [],
    );
  }

  /// `Resend after`
  String get resendAfter {
    return Intl.message(
      'Resend after',
      name: 'resendAfter',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get resend {
    return Intl.message('Resend', name: 'resend', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
