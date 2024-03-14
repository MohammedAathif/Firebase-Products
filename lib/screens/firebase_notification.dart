import 'package:firebase_products/notifier/notification_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FireBaseNotification extends StatelessWidget {
  const FireBaseNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(),
      body: ChangeNotifierProvider(
        create: (context) => NotificationNotifier(),
        child: Consumer<NotificationNotifier>(builder: (context, notifier, _) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Repeat Notification will show notification after each minute'),
                ),
                ElevatedButton(
                    onPressed: () =>
                        notifier.notificationService.instantNotification(),
                    child: const Text('Show Notification')),
                ElevatedButton(
                  onPressed: notifier.repeatNotification,
                  child: const Text('Repeat Notification'),
                ),
                ElevatedButton(
                  onPressed: notifier.stopTimer,
                  child: const Text('Stop all Notification'),
                ),
                Visibility(
                  visible: notifier.isPressed,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                    Text('Next notification in ${notifier.time} seconds'),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
