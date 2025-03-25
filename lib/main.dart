import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiktok_clone/common/widgets/video_config/video_config.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/video/repositories/playback_config_repository.dart';
import 'package:tiktok_clone/features/video/view_models/playback_config_view_model.dart';
import 'package:tiktok_clone/firebase_options.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // firebase initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  final preferences = await SharedPreferences.getInstance();
  final repository = PlaybackConfigRepository(preferences);

  /* Riverpod */
  runApp(
    ProviderScope(
      overrides: [
        playbackConfigProvider.overrideWith(
          () => PlaybackConfigViewModel(repository),
        ),
      ],
      child: TikTokApp(),
    ),
  );
}

class TikTokApp extends ConsumerWidget {
  TikTokApp({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder(
      valueListenable: screenModeConfig,
      builder: (context, value, child) => MaterialApp.router(
        routerConfig: ref.watch(routerProvider),
        title: 'TikTok Clone',
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ko'),
        ],
        debugShowCheckedModeBanner: false,
        themeMode: value,
        theme: ThemeData(
          primaryColor: const Color(0xFFE9435A),
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          textTheme: Typography.blackMountainView,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFFE9435A),
            selectionColor: Color(0xFFFAA9B3),
          ),
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
          primaryColor: const Color(0xFFE9435A),
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          textTheme: Typography.whiteMountainView,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFFE9435A),
            selectionColor: Color(0xFFFAA9B3),
          ),
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
      ),
    );
  }
}
