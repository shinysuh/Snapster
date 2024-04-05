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

  static String m0(nameOfTheApp) => "Log in to ${nameOfTheApp}";

  static String m1(nameOfTheApp) => "Sign Up for ${nameOfTheApp}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "alreadyHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("Already have an account?"),
        "continueWithApple":
            MessageLookupByLibrary.simpleMessage("Continue with apple"),
        "dontHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("Don\'t have an account?"),
        "logIn": MessageLookupByLibrary.simpleMessage("Log in"),
        "logInToTiktok": m0,
        "loginSubTitle": MessageLookupByLibrary.simpleMessage(
            "Manage your account, check notifications, comment on videos, and more."),
        "signUp": MessageLookupByLibrary.simpleMessage("Sign up"),
        "signUpSubtitle": MessageLookupByLibrary.simpleMessage(
            "Create a profile, follow other accounts, make your own videos, and more."),
        "signUpTitle": m1,
        "useEmailPassword":
            MessageLookupByLibrary.simpleMessage("Use email & password")
      };
}
