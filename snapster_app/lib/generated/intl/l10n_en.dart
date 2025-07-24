// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String signUpTitle(String nameOfTheApp) {
    return 'Sign Up for $nameOfTheApp';
  }

  @override
  String signUpSubtitle(num videoCount) {
    String _temp0 = intl.Intl.pluralLogic(
      videoCount,
      locale: localeName,
      other: 'videos',
      one: 'video',
      zero: 'no videos',
    );
    return 'Create a profile, follow other accounts, make your own $_temp0, and more.';
  }

  @override
  String get useEmailPassword => 'Use email & password';

  @override
  String get continueWithApple => 'Continue with apple';

  @override
  String get continueWithGithub => 'Continue with Github';

  @override
  String get continueWithKakao => 'Continue With Kakao';

  @override
  String get alreadyHaveAnAccount => 'Already have an account?';

  @override
  String get logIn => 'Log in';

  @override
  String loginToSnapster(String nameOfTheApp) {
    return 'Log in to $nameOfTheApp';
  }

  @override
  String get dontHaveAnAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign up';

  @override
  String get loginSubTitle => 'Manage your account, check notifications, comment on videos, and more.';

  @override
  String likeCount(int value) {
    final intl.NumberFormat valueNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String valueString = valueNumberFormat.format(value);

    return '$valueString';
  }

  @override
  String commentCount(int value) {
    final intl.NumberFormat valueNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String valueString = valueNumberFormat.format(value);

    return '$valueString';
  }

  @override
  String get share => 'share';

  @override
  String commentTitle(int value, int value2) {
    final intl.NumberFormat valueNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String valueString = valueNumberFormat.format(value);

    String _temp0 = intl.Intl.pluralLogic(
      value2,
      locale: localeName,
      other: 'comments',
      one: 'comment',
    );
    return '$valueString $_temp0';
  }

  @override
  String commentLikeCount(int value) {
    final intl.NumberFormat valueNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String valueString = valueNumberFormat.format(value);

    return '$valueString';
  }

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get save => 'Save';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get videoDetail => 'Video Detail';

  @override
  String get title => 'title';

  @override
  String get description => 'description';

  @override
  String get chooseYourInterests => 'Choose your interests';

  @override
  String get setTheVideoTitle => 'Please set the video title before you upload it.';

  @override
  String get enterVideoTitle => 'Enter video title';

  @override
  String get yearMonthDate => 'MMM d yyyy';

  @override
  String get monthDate => 'MMM d';

  @override
  String get hourMinuteAPM => 'h:mma';

  @override
  String get conversationNotStarted => 'Conversation Not Started';

  @override
  String get selectAProfileToStartAConversation => 'Select a profile to start a conversation';

  @override
  String get chooseAProfile => 'Choose a profile';

  @override
  String get exitChatroom => 'Exit chatroom';

  @override
  String userHasLeftChatroom(String username) {
    return '$username has left the chatroom.';
  }

  @override
  String get exit => 'Exit';

  @override
  String get reInvitationConfirmMsg => 'Do you want to invite the person back?';

  @override
  String get deleteMessageConfirm => 'Do you want to delete the message?';

  @override
  String get youCanOnlyDeleteTheMessagesYouSent => 'You can only delete the messages you sent.';

  @override
  String get noVideosToShow => 'No videos to show. If you\'ve uploaded any, please refresh the page.';

  @override
  String get nowLoadingTheVideo => 'Now loading the video..';

  @override
  String get deleteProfilePicture => 'Delete profile picture';
}
