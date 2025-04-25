import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapster_app/common/widgets/navigation/main_navigation_screen.dart';
import 'package:snapster_app/common/widgets/video_config/video_config.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/authentication/providers/auth_status_provider.dart';
import 'package:snapster_app/features/authentication/providers/http_auth_provider.dart';
import 'package:snapster_app/features/authentication/views/sign_up/sign_up_screen.dart';
import 'package:snapster_app/features/video/repositories/playback_config_repository.dart';
import 'package:snapster_app/features/video/view_models/playback_config_view_model.dart';
import 'package:snapster_app/firebase_options.dart';
import 'package:snapster_app/generated/l10n.dart';
import 'package:snapster_app/router.dart';
import 'package:uni_links/uni_links.dart';

void main() async {
  /* runApp() 호출 전에 binding 을 initialize 하기 위한 코드 */
  WidgetsFlutterBinding.ensureInitialized();

  // firebase initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 화면 전환 방지 (허락되는 방향만 지정)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  final preferences = await SharedPreferences.getInstance();
  final repository = PlaybackConfigRepository(preferences);

  /* Riverpod 사용 */
  runApp(
    ProviderScope(
      overrides: [
        playbackConfigProvider
            .overrideWith(() => PlaybackConfigViewModel(repository)),
      ],
      child: SnapsterApp(),
    ),
  );

  /* Provider 사용 시 */
  // runApp(
  //   MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(
  //         create: (context) => PlaybackConfigViewModel(repository),
  //       )
  //     ],
  //     child: const SnapsterApp(),
  //   ),
  // );
}

class SnapsterApp extends ConsumerStatefulWidget {
  SnapsterApp({super.key});

  @override
  ConsumerState<SnapsterApp> createState() => _SnapsterAppState();
}

class _SnapsterAppState extends ConsumerState<SnapsterApp> {
  late final StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  void _initDeepLinkListener() {
    _sub = uriLinkStream.listen((uri) async {
      if (uri == null) return;

      final repo = ref.read(authRepositoryProvider);
      final success = await repo.storeTokenFromUriAndRestoreAuth(uri, ref);

      // 화면 이동
      if (mounted) {
        final location =
            success ? MainNavigationScreen.homeRouteURL : SignUpScreen.routeURL;
        ref.read(routerProvider).go(location);
      }
    }, onError: (e) {
      debugPrint('❌ uriLinkStream error: $e');
    });
  }

  final lightTextTheme = GoogleFonts.itimTextTheme(
    const TextTheme(
      headlineLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 40,
      ),
    ),
  );

  final darkTextTheme = GoogleFonts.itimTextTheme(
    ThemeData(brightness: Brightness.dark).textTheme,
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // locale 강제 지정
    // S.load(const Locale('en'));
    return ValueListenableBuilder(
      valueListenable: screenModeConfig,
      builder: (context, value, child) => MaterialApp.router(
        routerConfig: ref.watch(routerProvider),
        title: 'Snapster',
        localizationsDelegates: const [
          // flutter intl -> l10n
          S.delegate,
          // flutter 위젯 기본 번역 (AppLocalizations 에 포함됨)
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          // supportedLocales => 지원 언어 목록 (IANA Language Registry 참고)
          Locale('en'),
          Locale('ko'),
        ],
        debugShowCheckedModeBanner: false,
        // themeMode => light / dark 명시할 경우, 해당 모드 강제 가능 / ThemeMode.system 시스템(폰) 설정 따르기
        // themeMode: ThemeMode.system,
        themeMode: value,
        /* FlexThemeData (flex-color-scheme) : 전반적 색상 테마 적용 패키지 */
        // theme: FlexThemeData.light(scheme: FlexScheme.mandyRed),
        // darkTheme: FlexThemeData.dart(scheme: FlexScheme.mandyRed),
        theme: ThemeData(
          // useMaterial3: false,
          primaryColor: const Color(0xFFE9435A),
          brightness: Brightness.light,
          // brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          // textTheme: lightTextTheme,
          textTheme: Typography.blackMountainView,
          /* material design 2 -> the type system 에서 원하는 폰트 코드 사용 가능 */
          // textTheme: TextTheme(
          //   displayLarge: GoogleFonts.openSans(
          //       fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5),
          //   displayMedium: GoogleFonts.openSans(
          //       fontSize: 60, fontWeight: FontWeight.w300, letterSpacing: -0.5),
          //   displaySmall:
          //       GoogleFonts.openSans(fontSize: 48, fontWeight: FontWeight.w400),
          //   headlineMedium: GoogleFonts.openSans(
          //       fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
          //   headlineSmall:
          //       GoogleFonts.openSans(fontSize: 24, fontWeight: FontWeight.w400),
          //   titleLarge: GoogleFonts.openSans(
          //       fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
          //   titleMedium: GoogleFonts.openSans(
          //       fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
          //   titleSmall: GoogleFonts.openSans(
          //       fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
          //   bodyLarge: GoogleFonts.roboto(
          //       fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
          //   bodyMedium: GoogleFonts.roboto(
          //       fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
          //   labelLarge: GoogleFonts.roboto(
          //       fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
          //   bodySmall: GoogleFonts.roboto(
          //       fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
          //   labelSmall: GoogleFonts.roboto(
          //       fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
          // ),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFFE9435A),
            selectionColor: Color(0xFFFAA9B3),
          ),
          // iconTheme: IconThemeData(
          //   color: Colors.grey.shade900,
          // ),
          appBarTheme: const AppBarTheme(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: Sizes.size18,
              fontWeight: FontWeight.w700,
            ),
          ),
          tabBarTheme: TabBarTheme(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey.shade500,
            indicatorColor: Colors.black,
          ),
          listTileTheme: const ListTileThemeData(
            iconColor: Colors.black,
          ),
          bottomAppBarTheme: BottomAppBarTheme(
            shadowColor: Colors.black,
            surfaceTintColor: Colors.grey.shade50,
          ),
        ),
        darkTheme: ThemeData(
          // useMaterial3: false,
          primaryColor: const Color(0xFFE9435A),
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          // textTheme: darkTextTheme,
          textTheme: Typography.whiteMountainView,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFFE9435A),
            selectionColor: Color(0xFFFAA9B3),
          ),
          // iconTheme: IconThemeData(
          //   color: Colors.grey.shade400,
          // ),
          appBarTheme: AppBarTheme(
            foregroundColor: Colors.white,
            backgroundColor: Colors.grey.shade900,
            surfaceTintColor: Colors.grey.shade900,
            elevation: 0,
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: Sizes.size18,
              fontWeight: FontWeight.w700,
            ),
            actionsIconTheme: IconThemeData(
              color: Colors.grey.shade100,
            ),
            iconTheme: IconThemeData(
              color: Colors.grey.shade100,
            ),
          ),
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.grey.shade900,
            shadowColor: Colors.black,
            surfaceTintColor: Colors.grey.shade900,
          ),
          tabBarTheme: TabBarTheme(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey.shade600,
            indicatorColor: Colors.white,
          ),
        ),
        // home: const SettingsScreen(),
        // home: const SignUpScreen(),
        // home: const MainNavigationScreen(),
        // home: const LayoutBuilderCodeLab(),
      ),
    );
  }
}

// class LayoutBuilderCodeLab extends StatelessWidget {
//   const LayoutBuilderCodeLab({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: SizedBox(
//         width: size.width / 2,
//         child: LayoutBuilder(
//           builder: (context, constraints) => Container(
//             width: constraints.maxWidth,
//             height: constraints.maxHeight,
//             color: Colors.teal,
//             child: Center(
//               child: Text(
//                 '${size.width} / ${constraints.maxWidth}',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 98,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
