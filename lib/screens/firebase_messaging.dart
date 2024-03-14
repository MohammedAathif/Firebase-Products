import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMessagingScreen extends StatefulWidget {
  const FirebaseMessagingScreen({super.key});

  @override
  State<FirebaseMessagingScreen> createState() => _FirebaseMessagingScreenState();
}

class _FirebaseMessagingScreenState extends State<FirebaseMessagingScreen> {

  late FirebaseMessaging messaging;


  @override
  void initState() {
    super.initState();
    print('in initstate');
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print(value);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message received");
      print(event.notification!.body);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Notification"),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });

  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Firebase Messaging')),
      body: const Center(
        child: Text(
          'Firebase Messaging',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
