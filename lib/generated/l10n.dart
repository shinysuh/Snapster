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
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
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
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Sign Up for {nameOfTheApp}`
  String signUpTitle(String nameOfTheApp) {
    return Intl.message(
      'Sign Up for $nameOfTheApp',
      name: 'signUpTitle',
      desc: 'The title people see when they open the app for the first time.',
      args: [nameOfTheApp],
    );
  }

  /// `Sign Up for {nameOfTheApp} {when}`
  String signUpTitleWithDateTime(String nameOfTheApp, DateTime when) {
    final DateFormat whenDateFormat =
        DateFormat('y / QQQ / LLLL 😆', Intl.getCurrentLocale());
    final String whenString = whenDateFormat.format(when);

    return Intl.message(
      'Sign Up for $nameOfTheApp $whenString',
      name: 'signUpTitleWithDateTime',
      desc: 'The title people see when they open the app for the first time.',
      args: [nameOfTheApp, whenString],
    );
  }

  /// `Create a profile, follow other accounts, make your own {videoCount, plural, =0{no videos} =1{video} other{videos}}, and more.`
  String signUpSubtitle(num videoCount) {
    return Intl.message(
      'Create a profile, follow other accounts, make your own ${Intl.plural(videoCount, zero: 'no videos', one: 'video', other: 'videos')}, and more.',
      name: 'signUpSubtitle',
      desc: '',
      args: [videoCount],
    );
  }

  /// `Use email & password`
  String get useEmailPassword {
    return Intl.message(
      'Use email & password',
      name: 'useEmailPassword',
      desc: '',
      args: [],
    );
  }

  /// `Continue with apple`
  String get continueWithApple {
    return Intl.message(
      'Continue with apple',
      name: 'continueWithApple',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Github`
  String get continueWithGithub {
    return Intl.message(
      'Continue with Github',
      name: 'continueWithGithub',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAnAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Log in {gender, select, male{Sir} female{Madam} other{Human}}`
  String logIn(String gender) {
    return Intl.message(
      'Log in ${Intl.gender(gender, male: 'Sir', female: 'Madam', other: 'Human')}',
      name: 'logIn',
      desc: '',
      args: [gender],
    );
  }

  /// `Log in to {nameOfTheApp}`
  String logInToTiktok(Object nameOfTheApp) {
    return Intl.message(
      'Log in to $nameOfTheApp',
      name: 'logInToTiktok',
      desc: '',
      args: [nameOfTheApp],
    );
  }

  /// `Don't have an account?`
  String get dontHaveAnAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signUp {
    return Intl.message(
      'Sign up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Manage your account, check notifications, comment on videos, and more.`
  String get loginSubTitle {
    return Intl.message(
      'Manage your account, check notifications, comment on videos, and more.',
      name: 'loginSubTitle',
      desc: '',
      args: [],
    );
  }

  /// `{value}`
  String likeCount(int value) {
    final NumberFormat valueNumberFormat = NumberFormat.compact(
      locale: Intl.getCurrentLocale(),
    );
    final String valueString = valueNumberFormat.format(value);

    return Intl.message(
      '$valueString',
      name: 'likeCount',
      desc: 'like count',
      args: [valueString],
    );
  }

  /// `{value}`
  String commentCount(int value) {
    final NumberFormat valueNumberFormat = NumberFormat.compact(
      locale: Intl.getCurrentLocale(),
    );
    final String valueString = valueNumberFormat.format(value);

    return Intl.message(
      '$valueString',
      name: 'commentCount',
      desc: 'comment count',
      args: [valueString],
    );
  }

  /// `share`
  String get share {
    return Intl.message(
      'share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `{value} {value2, plural, =1{comment} other{comments}}`
  String commentTitle(int value, num value2) {
    final NumberFormat valueNumberFormat = NumberFormat.compact(
      locale: Intl.getCurrentLocale(),
    );
    final String valueString = valueNumberFormat.format(value);

    return Intl.message(
      '$valueString ${Intl.plural(value2, one: 'comment', other: 'comments')}',
      name: 'commentTitle',
      desc: 'comment counts on comment dialog',
      args: [valueString, value2],
    );
  }

  /// `{value}`
  String commentLikeCount(int value) {
    final NumberFormat valueNumberFormat = NumberFormat.compact(
      locale: Intl.getCurrentLocale(),
    );
    final String valueString = valueNumberFormat.format(value);

    return Intl.message(
      '$valueString',
      name: 'commentLikeCount',
      desc: 'comment like count',
      args: [valueString],
    );
  }

  /// `Continue with Google`
  String get continueWithGoogle {
    return Intl.message(
      'Continue with Google',
      name: 'continueWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Video Detail`
  String get videoDetail {
    return Intl.message(
      'Video Detail',
      name: 'videoDetail',
      desc: '',
      args: [],
    );
  }

  /// `title`
  String get title {
    return Intl.message(
      'title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `description`
  String get description {
    return Intl.message(
      'description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Choose your interests`
  String get chooseYourInterests {
    return Intl.message(
      'Choose your interests',
      name: 'chooseYourInterests',
      desc: '',
      args: [],
    );
  }

  /// `Please set the video title before you upload it.`
  String get setTheVideoTitle {
    return Intl.message(
      'Please set the video title before you upload it.',
      name: 'setTheVideoTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter video title`
  String get enterVideoTitle {
    return Intl.message(
      'Enter video title',
      name: 'enterVideoTitle',
      desc: '',
      args: [],
    );
  }

  /// `MMM d yyyy`
  String get yearMonthDate {
    return Intl.message(
      'MMM d yyyy',
      name: 'yearMonthDate',
      desc: 'Format for year, month, and day.',
      args: [],
    );
  }

  /// `MMM d`
  String get monthDate {
    return Intl.message(
      'MMM d',
      name: 'monthDate',
      desc: 'Format for month and day.',
      args: [],
    );
  }

  /// `h:ma`
  String get hourMinuteAPM {
    return Intl.message(
      'h:ma',
      name: 'hourMinuteAPM',
      desc: 'Format for hour and minute with AM/PM.',
      args: [],
    );
  }

  /// `Conversation Not Started`
  String get conversationNotStarted {
    return Intl.message(
      'Conversation Not Started',
      name: 'conversationNotStarted',
      desc: '',
      args: [],
    );
  }

  /// `Select a profile to start a conversation`
  String get selectAProfileToStartAConversation {
    return Intl.message(
      'Select a profile to start a conversation',
      name: 'selectAProfileToStartAConversation',
      desc: '',
      args: [],
    );
  }

  /// `Choose a profile`
  String get chooseAProfile {
    return Intl.message(
      'Choose a profile',
      name: 'chooseAProfile',
      desc: '',
      args: [],
    );
  }

  /// `Leave Chatroom`
  String get leaveChatroom {
    return Intl.message(
      'Leave Chatroom',
      name: 'leaveChatroom',
      desc: '',
      args: [],
    );
  }

  /// `{username} has left the chatroom.`
  String userHasLeftChatroom(Object username) {
    return Intl.message(
      '$username has left the chatroom.',
      name: 'userHasLeftChatroom',
      desc: '',
      args: [username],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ko'),
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
