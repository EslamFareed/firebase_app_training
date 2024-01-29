import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:firebase_app_training/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'notifications_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  String? token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    print(token);
  }

  FirebaseMessaging.onBackgroundMessage(_handler);

  FirebaseMessaging.onMessage.listen((message) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: "basic_channel",
        title: message.data["title"],
        body: message.data["body"],
        // title: message.notification!.title,
        // body: message.notification!.body,
      ),
    );
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationsScreen(),
    );
  }
}

Future<void> _handler(RemoteMessage message) async {
  // message.notification.title
  // message.notification.body

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: "basic_channel",
      title: message.data["title"],
      body: message.data["body"],
      // title: message.notification!.title,
      // body: message.notification!.body,
    ),
  );
}
