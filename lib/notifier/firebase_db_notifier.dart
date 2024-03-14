import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirebaseDbNotifier extends ChangeNotifier {
  late Future<List<Map<String, dynamic>>> _futureData;
  int _count = 10;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  FirebaseDbNotifier() {
    futureData = fetchUser();
  }

  Future<void> addUser(String name, String email, int age) {

    return users.add({
      'name': name,
      'email': email,
      'age': age,
    }).then((value) {
      print("User added successfully!");
      futureData = fetchUser();
    }).catchError((error) => print("Failed to add user: $error"));

  }

  Future<List<Map<String, dynamic>>> fetchUser() async {

    try {
      QuerySnapshot snapshot = await users.get();

      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    } catch (error) {
      print("Failed to fetch users: $error");
      rethrow;
    }
  }

  onPressed() {
    count = count + 1;
    addUser('Mickey', 'user$count@gmail.com', 12);
  }

  Future<List<Map<String, dynamic>>> get futureData => _futureData;

  set futureData(Future<List<Map<String, dynamic>>> value) {
    _futureData = value;
    notifyListeners();
  }

  int get count => _count;

  set count(int value) {
    _count = value;
    notifyListeners();
  }
}