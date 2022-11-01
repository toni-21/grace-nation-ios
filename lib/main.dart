import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/core/providers/audio_provider.dart';
import 'package:grace_nation/core/providers/auth_provider.dart';
import 'package:grace_nation/core/providers/theme_provider.dart';
import 'package:grace_nation/core/providers/user_states.dart';
import 'package:grace_nation/router/audio_player_handler.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/pages/downloads/audio_player.dart';
import 'router/routes.dart';

import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

late AudioHandler _audioHandler;
final _audioProvider = AudioProvider();
ThemeProvider themeChangeProvider = ThemeProvider();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = LoginState(await SharedPreferences.getInstance());
  state.checkLoggedIn();
  usePathUrlStrategy();
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  _audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(_audioProvider),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.example.grace_nation.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    ),
  );

  // Plugin must be initialized before using
  themeChangeProvider.darkTheme =
      await themeChangeProvider.darkThemePreference.getTheme();

  runApp(MyApp(loginState: state));
}

class MyApp extends StatefulWidget {
  final LoginState loginState;
  const MyApp({Key? key, required this.loginState}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final _appProvider = AppProvider();
  final _authProvider = AuthProvider();

  @override
  void initState() {
    AudioService.notificationClicked.listen((event) {
      print('---AUDIO NOTIFICATION Clicked EVENT is $event ---');
      if (event) {
        // goToNowPlaying();
        if (navigatorKey.currentState != null && _audioProvider.isPlaying) {
          navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (BuildContext context) => AudioPlayerWidget(),
            ),
          );
        }
      }
    });
    super.initState();
  }

  void goToNowPlaying() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(audioClickKey, true);
  }

  @override
  void dispose() {
    if (mounted) _audioHandler.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>(
            create: (BuildContext context) => _appProvider),
        ChangeNotifierProvider<AuthProvider>(
            create: (BuildContext context) => _authProvider),
        ChangeNotifierProvider<AudioProvider>(
            create: (BuildContext context) => _audioProvider),
        ChangeNotifierProvider<ThemeProvider>(
            lazy: false, create: (BuildContext context) => themeChangeProvider),
        ChangeNotifierProvider<LoginState>(
          lazy: false,
          create: (BuildContext createContext) => widget.loginState,
        ),
        Provider<MyRouter>(
          lazy: false,
          create: (BuildContext createContext) =>
              MyRouter(widget.loginState, navigatorKey),
        )
      ],
      child: Builder(
        builder: (BuildContext context) {
          final router = Provider.of<MyRouter>(context, listen: false).router;
          Provider.of<AuthProvider>(context, listen: false).setAuth();
          Provider.of<AppProvider>(context, listen: false)
              .setAudioHandler(_audioHandler);
          return MaterialApp.router(
            routeInformationProvider: router.routeInformationProvider,
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
            debugShowCheckedModeBanner: false,

            title: 'Navigation App',
            theme: Styles.themeData(
                Provider.of<ThemeProvider>(context).darkTheme, context),
            // ThemeData(
            //   primarySwatch: Colors.blue,
            //   textTheme:
            //       GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
            // ),
          );
        },
      ),
    );
  }
}
