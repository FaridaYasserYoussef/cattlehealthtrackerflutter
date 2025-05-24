// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "Continue": MessageLookupByLibrary.simpleMessage("Continue"),
    "OTPAttemptsExceeded": MessageLookupByLibrary.simpleMessage(
      "You exceeded your 4 OTP Attempts",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cattle": MessageLookupByLibrary.simpleMessage("Cattle"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "confirmLogout": MessageLookupByLibrary.simpleMessage("Confirm logout"),
    "culling": MessageLookupByLibrary.simpleMessage("Culling"),
    "darkMode": MessageLookupByLibrary.simpleMessage("Dark mode"),
    "dashboard": MessageLookupByLibrary.simpleMessage("Dashboard"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "emailAt": MessageLookupByLibrary.simpleMessage("Email must contain @"),
    "emailDotCom": MessageLookupByLibrary.simpleMessage(
      "Email must end with .com",
    ),
    "emptyEmail": MessageLookupByLibrary.simpleMessage("Email can\'t be empty"),
    "emptyOTP": MessageLookupByLibrary.simpleMessage("OTP must be 6 digits"),
    "emptyPassword": MessageLookupByLibrary.simpleMessage(
      "Password can\'t be empty",
    ),
    "incorrectOTP": MessageLookupByLibrary.simpleMessage(
      "You entered an incorrect OTP",
    ),
    "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
    "locale": MessageLookupByLibrary.simpleMessage("Language"),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "loginSuccess": MessageLookupByLibrary.simpleMessage("Login Successful"),
    "logout": MessageLookupByLibrary.simpleMessage("Logout"),
    "logoutSuccess": MessageLookupByLibrary.simpleMessage("Logout Successful"),
    "logs": MessageLookupByLibrary.simpleMessage("Logs"),
    "medicines": MessageLookupByLibrary.simpleMessage("Medicines"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordMinLen": MessageLookupByLibrary.simpleMessage(
      "Password is at least 8 characters",
    ),
    "resend": MessageLookupByLibrary.simpleMessage("Resend"),
    "resendAfter": MessageLookupByLibrary.simpleMessage("Resend after"),
    "roles": MessageLookupByLibrary.simpleMessage("Roles"),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "twofa": MessageLookupByLibrary.simpleMessage("2F Authentication"),
    "users": MessageLookupByLibrary.simpleMessage("Users"),
    "verifyAfter": MessageLookupByLibrary.simpleMessage("Verify after"),
    "verifyOtp": MessageLookupByLibrary.simpleMessage("Verify"),
  };
}
