import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            AwesomeNotifications().createNotification(
              content: NotificationContent(
                id: 1,
                channelKey: "basic_channel",
                title: "This is example",
                body: "Just to try it out",
              ),
            );
          },
          child: const Text("Send Notifications"),
        ),
      ),
    );
  }
}
