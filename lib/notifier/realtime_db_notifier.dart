import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class RealtimeDbNotifier extends ChangeNotifier {
  late DatabaseReference _databaseReference;

  bool _isLoading = true;
  bool _disposed = false;

  List<Map<dynamic, dynamic>> _dbData = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  RealtimeDbNotifier() {
    Firebase.initializeApp().whenComplete(() {

      databaseReference = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        // databaseURL: 'https://fir-database-313a4-default-rtdb.asia-southeast1.firebasedatabase.app/',
        databaseURL: 'https://flavor-sample-original-default-rtdb.asia-southeast1.firebasedatabase.app/'
      ).ref().child('users');
      readData();
    });
  }

  void createRecord(name,email,age) {
    print('cr');
    DatabaseReference newReference = databaseReference.push();

    newReference.set({
      'name': name,
      'email': email,
      'age': age,
    }).then((value) {
      print("User added successfully!");
    })
        .catchError((error) {
      print("Failed to add user: $error");
    });

    readData();
  }

  void readData() {
    print('read');

    databaseReference.onValue.listen((event) {
      print('value');
      DataSnapshot dataSnapshot = event.snapshot;
      print(dataSnapshot);
      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic> values = dataSnapshot.value as Map<dynamic, dynamic>;

        dbData.clear();
        isLoading = true;

        values.forEach((key, values) {
          dbData.add({
            'key': key,
            'name': values['name'],
            'email': values['email'],
            'age': values['age']
          });
          Future.delayed(const Duration(milliseconds: 500)).then((value) {
           isLoading = false;
          });
        });

      } else {
        print('empty data');
        isLoading = false;
      }
    });
  }

  void deleteAllUsers() async {
    print('calling delete method');
    if (_disposed) {
      return; // Check if the notifier is disposed
    }

    try {
      await databaseReference.remove();
      // Check if the notifier is disposed before updating properties
      if (_disposed) {
        return;
      }
      if (!_disposed) {
        _isLoading = false;
      }
    } catch (error) {
      print('Failed to delete all users: $error');
      // Check if the notifier is disposed before updating properties
      if (!_disposed) {
        _isLoading = false;
      }
    }

    // isLoading = true;
    // databaseReference.remove();
    //
    // Future.delayed(const Duration(milliseconds: 500)).then((value) {
    //   isLoading = false;
    // });
  }

  @override
  void dispose() {
    _disposed = true; // Set the flag when the notifier is disposed
    super.dispose();
  }

  DatabaseReference get databaseReference => _databaseReference;

  set databaseReference(DatabaseReference value) {
    _databaseReference = value;
    notifyListeners();
  }

  List<Map<dynamic, dynamic>> get dbData => _dbData;

  set dbData(List<Map<dynamic, dynamic>> value) {
    _dbData = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get disposed => _disposed;

  set disposed(bool value) {
    _disposed = value;
    notifyListeners();
  }
}