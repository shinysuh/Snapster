import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_en.dart';
import 'l10n_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'intl/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko')
  ];

  /// The title people see when they open the app for the first time.
  ///
  /// In en, this message translates to:
  /// **'Sign Up for {nameOfTheApp}'**
  String signUpTitle(String nameOfTheApp);

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a profile, follow other accounts, make your own {videoCount, plural, =0{no videos} =1{video} other{videos}}, and more.'**
  String signUpSubtitle(num videoCount);

  /// No description provided for @useEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Use email & password'**
  String get useEmailPassword;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with apple'**
  String get continueWithApple;

  /// No description provided for @continueWithGithub.
  ///
  /// In en, this message translates to:
  /// **'Continue with Github'**
  String get continueWithGithub;

  /// No description provided for @continueWithKakao.
  ///
  /// In en, this message translates to:
  /// **'Continue With Kakao'**
  String get continueWithKakao;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAnAccount;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @loginToSnapster.
  ///
  /// In en, this message translates to:
  /// **'Log in to {nameOfTheApp}'**
  String loginToSnapster(String nameOfTheApp);

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAnAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @loginSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your account, check notifications, comment on videos, and more.'**
  String get loginSubTitle;

  /// like count
  ///
  /// In en, this message translates to:
  /// **'{value}'**
  String likeCount(int value);

  /// comment count
  ///
  /// In en, this message translates to:
  /// **'{value}'**
  String commentCount(int value);

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'share'**
  String get share;

  /// comment counts on comment dialog
  ///
  /// In en, this message translates to:
  /// **'{value} {value2, plural, =1{comment} other{comments}}'**
  String commentTitle(int value, int value2);

  /// comment like count
  ///
  /// In en, this message translates to:
  /// **'{value}'**
  String commentLikeCount(int value);

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @videoDetail.
  ///
  /// In en, this message translates to:
  /// **'Video Detail'**
  String get videoDetail;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'description'**
  String get description;

  /// No description provided for @chooseYourInterests.
  ///
  /// In en, this message translates to:
  /// **'Choose your interests'**
  String get chooseYourInterests;

  /// No description provided for @setTheVideoTitle.
  ///
  /// In en, this message translates to:
  /// **'Please set the video title before you upload it.'**
  String get setTheVideoTitle;

  /// No description provided for @enterVideoTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter video title'**
  String get enterVideoTitle;

  /// No description provided for @yearMonthDate.
  ///
  /// In en, this message translates to:
  /// **'MMM d yyyy'**
  String get yearMonthDate;

  /// No description provided for @monthDate.
  ///
  /// In en, this message translates to:
  /// **'MMM d'**
  String get monthDate;

  /// No description provided for @hourMinuteAPM.
  ///
  /// In en, this message translates to:
  /// **'h:mma'**
  String get hourMinuteAPM;

  /// No description provided for @conversationNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Conversation Not Started'**
  String get conversationNotStarted;

  /// No description provided for @selectAProfileToStartAConversation.
  ///
  /// In en, this message translates to:
  /// **'Select a profile to start a conversation'**
  String get selectAProfileToStartAConversation;

  /// No description provided for @chooseAProfile.
  ///
  /// In en, this message translates to:
  /// **'Choose a profile'**
  String get chooseAProfile;

  /// No description provided for @exitChatroom.
  ///
  /// In en, this message translates to:
  /// **'Exit chatroom'**
  String get exitChatroom;

  /// No description provided for @userHasLeftChatroom.
  ///
  /// In en, this message translates to:
  /// **'{username} has left the chatroom.'**
  String userHasLeftChatroom(String username);

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @reInvitationConfirmMsg.
  ///
  /// In en, this message translates to:
  /// **'Do you want to invite the person back?'**
  String get reInvitationConfirmMsg;

  /// No description provided for @deleteMessageConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete the message?'**
  String get deleteMessageConfirm;

  /// No description provided for @youCanOnlyDeleteTheMessagesYouSent.
  ///
  /// In en, this message translates to:
  /// **'You can only delete the messages you sent.'**
  String get youCanOnlyDeleteTheMessagesYouSent;

  /// No description provided for @noVideosToShow.
  ///
  /// In en, this message translates to:
  /// **'No videos to show. If you\'ve uploaded any, please refresh the page.'**
  String get noVideosToShow;

  /// No description provided for @nowLoadingTheVideo.
  ///
  /// In en, this message translates to:
  /// **'Now loading the video..'**
  String get nowLoadingTheVideo;

  /// No description provided for @deleteProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Delete profile picture'**
  String get deleteProfilePicture;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ko': return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
