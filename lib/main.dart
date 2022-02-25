import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:novelkaizen/src/pages/login_page.dart';
import 'package:novelkaizen/src/pages/signup_page.dart';
import 'package:novelkaizen/src/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:novelkaizen/src/pages/home_page.dart';
import 'package:novelkaizen/src/providers/main_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:developer' as developer;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  developer.log('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'novelkaizen',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
        'novel_kaizen_notification_channel', // id
        'Novel Kaizen Notification Channel', // title
        description:
            'This channel is used for important notifications.', // description
        importance: Importance.high);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => MainProvider()),
  ], child: Phoenix(child: const MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _getTokenFCM();

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      developer.log('A new onMessageOpenedApp event was published!');
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);
    return FutureBuilder<bool>(
        future: mainProvider.initPrefs(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SizedBox.square(
                dimension: 150.0, child: Text("Ha ocurrido un error!!"));
          }

          if (snapshot.hasData) {
            return ScreenUtilInit(
              designSize: const Size(360, 690),
              builder: () => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'NOVEL KAIZEN',
                theme: AppTheme.themeData(mainProvider.mode),
                routes: {
                  "/login": (context) => const LoginPage(),
                  "/signup": (context) => const SignUpPage(),
                },
                home: mainProvider.token == ""
                    ? const LoginPage()
                    : JwtDecoder.isExpired(mainProvider.token)
                        ? const LoginPage()
                        : const HomePage(),
              ),
            );
          }

          return const SizedBox.square(
              dimension: 50.0, child: CircularProgressIndicator());
        });
  }

  _getTokenFCM() async {
    String? token = await FirebaseMessaging.instance.getToken();
    developer.log(token!);
  }
}
