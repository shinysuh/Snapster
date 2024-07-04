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

  static String m0(value) => "${value}";

  static String m1(value) => "${value}";

  static String m2(value, value2) =>
      "${value} ${Intl.plural(value2, one: 'comment', other: 'comments')}";

  static String m3(value) => "${value}";

  static String m4(gender) =>
      "Log in ${Intl.gender(gender, female: 'Madam', male: 'Sir', other: 'Human')}";

  static String m5(nameOfTheApp) => "Log in to ${nameOfTheApp}";

  static String m6(videoCount) =>
      "Create a profile, follow other accounts, make your own ${Intl.plural(videoCount, zero: 'no videos', one: 'video', other: 'videos')}, and more.";

  static String m7(nameOfTheApp) => "Sign Up for ${nameOfTheApp}";

  static String m8(nameOfTheApp, when) => "Sign Up for ${nameOfTheApp} ${when}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "alreadyHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("Already have an account?"),
        "chooseYourInterests":
            MessageLookupByLibrary.simpleMessage("Choose your interests"),
        "commentCount": m0,
        "commentLikeCount": m1,
        "commentTitle": m2,
        "continueWithApple":
            MessageLookupByLibrary.simpleMessage("Continue with apple"),
        "continueWithGithub":
            MessageLookupByLibrary.simpleMessage("Continue with Github"),
        "continueWithGoogle":
            MessageLookupByLibrary.simpleMessage("Continue with Google"),
        "conversationNotStarted":
            MessageLookupByLibrary.simpleMessage("Conversation Not Started"),
        "description": MessageLookupByLibrary.simpleMessage("description"),
        "dontHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("Don\'t have an account?"),
        "editProfile": MessageLookupByLibrary.simpleMessage("Edit Profile"),
        "enterVideoTitle":
            MessageLookupByLibrary.simpleMessage("Enter video title"),
        "hourMinuteAPM": MessageLookupByLibrary.simpleMessage("h:ma"),
        "likeCount": m3,
        "logIn": m4,
        "logInToTiktok": m5,
        "loginSubTitle": MessageLookupByLibrary.simpleMessage(
            "Manage your account, check notifications, comment on videos, and more."),
        "monthDate": MessageLookupByLibrary.simpleMessage("MMM d"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "selectAProfileToStartAConversation":
            MessageLookupByLibrary.simpleMessage(
                "Select a profile to start a conversation"),
        "setTheVideoTitle": MessageLookupByLibrary.simpleMessage(
            "Please set the video title before you upload it."),
        "share": MessageLookupByLibrary.simpleMessage("share"),
        "signUp": MessageLookupByLibrary.simpleMessage("Sign up"),
        "signUpSubtitle": m6,
        "signUpTitle": m7,
        "signUpTitleWithDateTime": m8,
        "title": MessageLookupByLibrary.simpleMessage("title"),
        "useEmailPassword":
            MessageLookupByLibrary.simpleMessage("Use email & password"),
        "videoDetail": MessageLookupByLibrary.simpleMessage("Video Detail"),
        "yearMonthDate": MessageLookupByLibrary.simpleMessage("MMM d yyyy")
      };
}
