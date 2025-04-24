// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String signUpTitle(String nameOfTheApp) {
    return '$nameOfTheApp에 가입하세요';
  }

  @override
  String signUpTitleWithDateTime(String nameOfTheApp, DateTime when) {
    final intl.DateFormat whenDateFormat = intl.DateFormat('y / QQQ / LLLL 😆', localeName);
    final String whenString = whenDateFormat.format(when);

    return 'Sign Up for $nameOfTheApp $whenString';
  }

  @override
  String signUpSubtitle(num videoCount) {
    return '프로필 생성, 다른 계정 팔로우, 나만의 비디오 만들기 등.';
  }

  @override
  String get useEmailPassword => '이메일/비밀번호';

  @override
  String get continueWithApple => '애플 계정';

  @override
  String get continueWithGithub => '깃허브 계정';

  @override
  String get continueWithKakao => '카카오 계정';

  @override
  String get alreadyHaveAnAccount => '이미 계정이 있으신가요?';

  @override
  String get logIn => '로그인';

  @override
  String loginToSnapster(Object nameOfTheApp) {
    return '$nameOfTheApp에 로그인하세요';
  }

  @override
  String get dontHaveAnAccount => '아직 계정이 없으신가요?';

  @override
  String get signUp => '회원가입';

  @override
  String get loginSubTitle => '계정 관리, 알림 확인, 동영상에 댓글 달기 등.';

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
  String get share => '공유';

  @override
  String commentTitle(int value, num value2) {
    final intl.NumberFormat valueNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String valueString = valueNumberFormat.format(value);

    return '댓글 $valueString개';
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
  String get continueWithGoogle => '구글 계정';

  @override
  String get save => '저장';

  @override
  String get editProfile => '프로필 수정';

  @override
  String get videoDetail => '비디오 상세';

  @override
  String get title => '제목';

  @override
  String get description => '상세 정보';

  @override
  String get chooseYourInterests => 'Choose your interests';

  @override
  String get setTheVideoTitle => '비디오 제목을 입력한 후 업로드 해 주세요.';

  @override
  String get enterVideoTitle => '비디오 제목을 입력해 주세요.';

  @override
  String get yearMonthDate => 'yyyy년 M월 d일';

  @override
  String get monthDate => 'M월 d일';

  @override
  String get hourMinuteAPM => 'h:mma';

  @override
  String get conversationNotStarted => '대화가 시작되지 않았습니다';

  @override
  String get selectAProfileToStartAConversation => '대화를 시작할 상대의 프로필을 선택하세요';

  @override
  String get chooseAProfile => '프로필 선택';

  @override
  String get exitChatroom => '채팅방 나가기';

  @override
  String userHasLeftChatroom(Object username) {
    return '$username 님이 채팅방을 나갔습니다.';
  }

  @override
  String get exit => '나가기';

  @override
  String get reInvitationConfirmMsg => '상대방을 다시 초대 하시겠습니까?';

  @override
  String get deleteMessageConfirm => '메세지를 삭제 하시겠습니까?';

  @override
  String get youCanOnlyDeleteTheMessagesYouSent => '내가 보낸 메세지만 삭제 가능합니다.';

  @override
  String get noVideosToShow => '표시할 동영상이 없습니다.\n동영상을 업로드 했을 경우\n페이지를 새로고침해 주세요.';

  @override
  String get nowLoadingTheVideo => '비디오 로딩 중..';

  @override
  String get deleteProfilePicture => '프로필 사진 삭제';
}
