import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class FirebaseCrashlyticsScreen extends StatelessWidget {
  const FirebaseCrashlyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crashlytics Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            simulateCrash();
          },
          child: const Text('Simulate Crash'),
        ),
      ),
    );
  }

  void simulateCrash() {
    // Simulate a crash by dividing by zero
    FirebaseCrashlytics.instance.crash();
    FirebaseCrashlytics.instance.log('firebase screen');
    //int result = 42 ~/ 0;
    //print(result); // This line won't be executed due to the crash
  }
}
