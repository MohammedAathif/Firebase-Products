import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../screens/firebase_db_stream.dart';

class FirebaseStreamNotifier extends ChangeNotifier {
  late Stream<List<Map<String, dynamic>>> _usersStream;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  FirebaseStreamNotifier() {
    _usersStream = FirebaseFirestore.instance.collection('users').snapshots().map(
          (QuerySnapshot querySnapshot) => querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList(),
    );
  }

  Future<void> addUser(UserModel userModel) async {
    try {
       await users.add({
        'name': userModel.name,
        'email': userModel.email,
        'age': userModel.age,
        'color':userModel.color
      });
      print("User added successfully! ");
    } catch (error) {
      print("Failed to add user: $error");
    }
  }

  Future<void> deleteAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await users.get();

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        await users.doc(document.id).delete();
      }

      // DocumentReference documentReference = users.doc('QmGcGnYMI75EsPbSysBt');
      // await documentReference.delete();
      print("All users deleted successfully!");
    } catch (error) {
      print("Failed to delete all users: $error");
    }
  }

  Stream<List<Map<String, dynamic>>> get usersStream => _usersStream;

  set usersStream(Stream<List<Map<String, dynamic>>> value) {
    _usersStream = value;
    notifyListeners();
  }
}