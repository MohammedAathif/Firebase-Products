import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // static final NotificationService notificationService = NotificationService._internal();
  //
  // factory NotificationService() {
  //   return notificationService;
  // }
  //
  // NotificationService._internal();

  AndroidNotificationDetails androidPlatformChannelSpecifics =
      const AndroidNotificationDetails(
    'channel_10', //Required for Android 8.0 or after
    'Flutter', //Required for Android 8.0 or after
    channelDescription: 'New Notification', //Required for Android 8.0 or after
    importance: Importance.max,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher'
  );


  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    print('init call');
    tz.initializeTimeZones();

    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;

        print("notifications title: ${notification?.title}");
        print("notifications body: ${notification?.body}");

        initLocalNotifications();
        showNotification(message);

    });
  }

  initLocalNotifications() async {
    print('init local ');
    const AndroidInitializationSettings androidInitialization = AndroidInitializationSettings('@mipmap/ic_launcher');

    // final IOSInitializationSettings initializationSettingsIOS =
    // IOSInitializationSettings(
    //   requestSoundPermission: false,
    //   requestBadgePermission: false,
    //   requestAlertPermission: false,
    //   onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    // );

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidInitialization,
      // iOS: initializationSettingsIOS
      macOS: null,
    );

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse val) {
        try {
          print('data ${val.payload}');
          // OpenFilex.open(val.payload);
          if(val.payload != 'path') {
            //Navigator.push(context, MaterialPageRoute(builder: (context) => const NewScreen()));
          }
        } catch (e) {
          print('exception $e');
        }
      },
    );
  }

  Future<void> showNotification(RemoteMessage message) async {

    print('show notification');

    //if(Platform.isAndroid) {
      AndroidNotificationChannel channel = AndroidNotificationChannel(
        message.notification?.android?.channelId.toString() ?? '',
        message.notification?.android?.channelId.toString() ?? '',
        importance: Importance.max,
        showBadge: true,
      );

      AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
        channelDescription: 'your channel description',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
        //  icon: largeIconPath
      );

      NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

      Future.delayed(Duration.zero, () {
        flutterLocalNotificationsPlugin.show(
            0,
            message.notification?.title.toString(),
            message.notification?.body.toString(),
            notificationDetails);
      });

    //}
    // else if(Platform.isIOS) {
    //   const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);
    //
    //   NotificationDetails notificationDetails = const NotificationDetails(iOS: darwinNotificationDetails);
    //
    //   Future.delayed(Duration.zero, () {
    //     _flutterLocalNotificationsPlugin.show(
    //         0,
    //         message.notification.title.toString(),
    //         message.notification.body.toString(),
    //         notificationDetails);
    //   });
    // }
  }

  callNotification() async {
    print('call notify');
    final indianTimeZone = tz.getLocation('Asia/Kolkata');
    var tzDateTime = tz.TZDateTime.now(indianTimeZone).add(const Duration(seconds: 5));
    print('time $tzDateTime');

    try {
      print('in try data');
      await flutterLocalNotificationsPlugin.zonedSchedule(
          57,
          'title_zone',
          'Schedule_notify',
          tzDateTime,
          NotificationDetails(android: androidPlatformChannelSpecifics),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
    } on PlatformException catch (e) {
      print('Platform Exception: ${e.message}');
      // Handle the exception or show a user-friendly error message
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  instantNotification() async {
    // // await flutterLocalNotificationsPlugin.show(1, 'instant', 'Notify',
    // //     NotificationDetails(android: androidPlatformChannelSpecifics),
    // //     payload: 'Instant Data');
    // flutterLocalNotificationsPlugin.show(
    //     0, 'File Downloaded', 'fileName',  NotificationDetails(android: androidPlatformChannelSpecifics),
    //     payload: 'path');
    // Future.delayed(Duration(seconds: 5)).then((value) {
    //   flutterLocalNotificationsPlugin.show(
    //       0, 'File ', 'fileNames',  NotificationDetails(android: androidPlatformChannelSpecifics),
    //       payload: 'path');
    // });
    int notificationId = 0;

    // final Directory appDir =  Directory('/storage/emulated/0/Download');
    //    // : await getApplicationDocumentsDirectory();
    //
    // String tempPath = appDir.path;
    //
    // final String fileName =
    //     '${DateTime
    //         .now()
    //         .microsecondsSinceEpoch}-statement.pdf';
    //
    // File file = File('$tempPath/$fileName');

    for (int progress = 10; progress <= 100; progress += 10) {
      await Future.delayed(const Duration(seconds: 1));

      // Update the existing notification with the new progress value
      flutterLocalNotificationsPlugin.show(
        notificationId,
        'File Download',
        'Downloading... $progress%',
        NotificationDetails(
          android: AndroidNotificationDetails(
            'channel_0', // Your channel ID
            'Download Channel', // Your channel name
            channelDescription: 'Channel for file download progress',
            importance: Importance.high,
            priority: Priority.high,
            onlyAlertOnce: true,
            ongoing: true,
            showProgress: true,
            maxProgress: 100,
            progress: progress,
            icon: '@mipmap/ic_launcher'
          ),
        ),
        payload: 'path',
      );
    }

      flutterLocalNotificationsPlugin.cancel(notificationId);

    // Delay for 1 seconds
    await Future.delayed(const Duration(seconds: 1));

    // Notify when the download is complete
     flutterLocalNotificationsPlugin.show(
      notificationId + 1, // Use a different ID for the second notification
      'Download Complete',
      'File has been downloaded successfully!',
      NotificationDetails(android: androidPlatformChannelSpecifics),
      payload: 'filePath',
    );

  }

  intervalNotification() async {
    print('interval notify');
    await flutterLocalNotificationsPlugin.periodicallyShow(
        15,
        'title_value',
        'repeat_notify',
        RepeatInterval.everyMinute,
        NotificationDetails(android: androidPlatformChannelSpecifics));
  }

  stopNotification() {
    flutterLocalNotificationsPlugin.cancelAll();
  }
}
