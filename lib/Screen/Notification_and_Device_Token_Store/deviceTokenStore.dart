import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceTokenStore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> getAndStoreFCMToken() async {
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        _insertTokenIntoFirestore(token);
      } else {
        print('FCM token is null.');
      }
    } else {
      print('Permission not granted');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle notification message when the app is in the foreground
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notification message when the app is opened from a terminated state
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        // Handle notification message when the app is in the background
        print('App opened from terminated state with message: ${message.data}');

        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');
        }
      }
    });
  }

  Future<void> _insertTokenIntoFirestore(String token) async {
    String userId = token; // Replace with your user ID logic
    DocumentReference userRef =
        _firestore.collection('deviceToken').doc(userId);
    DocumentSnapshot userSnapshot = await userRef.get();

    if (!userSnapshot.exists || userSnapshot.data() == null) {
      await userRef.set({'fcmToken': token}, SetOptions(merge: true));
      print("FCM token added successfully.");
    } else {
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;
      if (userData == null || userData['fcmToken'] == null) {
        await userRef.set({'fcmToken': token}, SetOptions(merge: true));
        print("FCM token added successfully.");
      } else {
        print("FCM token already exists for the user.");
      }
    }
  }
}
