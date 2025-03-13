  import 'package:alertify/Screen/Addons/SplashScreen.dart';
  import 'package:firebase_core/firebase_core.dart';
  import 'package:firebase_messaging/firebase_messaging.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'Screen/Notification_and_Device_Token_Store/deviceTokenStore.dart';
  import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  DeviceTokenStore fcmTokenService = DeviceTokenStore();
  await fcmTokenService.getAndStoreFCMToken();

  // Subscribe to topic
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.subscribeToTopic('allDevices');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'RobotoSlab'),
      debugShowCheckedModeBanner: false,
      title: 'Alertify',
      home: SplashScreen(),
    );
  }
}
