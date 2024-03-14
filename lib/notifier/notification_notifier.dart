import 'dart:async';
import 'package:firebase_products/widgets/notification_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationNotifier with ChangeNotifier {
  NotificationService _notificationService = NotificationService();
  bool _isPressed = false;
  int _time = 60;
  Timer? _timer;

  NotificationNotifier() {
    getPermission();

    notificationService.init();
    notificationService.callNotification();
  }

  getPermission() async {

    var status = await Permission.notification.status;


    if (status.isGranted) {
      // Permission is already granted, perform your action
      // For example, open the camera
      //openCamera();
      print('in if status');
    } else {
      // Permission is not granted, request it
      // await requestPermission();
      var result = await Permission.notification.request();
      print('default $result');
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      time = time - 1;
      if (time == 0) {
        time = 60;
      }
    });
  }

  void stopTimer() {
    timer.cancel();
    time = 60;
    isPressed = false;
    notificationService.stopNotification();
  }

  void repeatNotification() {
    isPressed = true;
    startTimer();
    notificationService.intervalNotification();
  }

  // getter and setter

  bool get isPressed => _isPressed;

  set isPressed(bool value) {
    _isPressed = value;
    notifyListeners();
  }

  int get time => _time;

  set time(int value) {
    _time = value;
    notifyListeners();
  }

  Timer get timer => _timer!;

  set timer(Timer value) {
    _timer = value;
    notifyListeners();
  }

  NotificationService get notificationService => _notificationService;

  set notificationService(NotificationService value) {
    _notificationService = value;
    notifyListeners();
  }
}
