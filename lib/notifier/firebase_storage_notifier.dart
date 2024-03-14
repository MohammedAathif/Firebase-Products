import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseStorageNotifier extends ChangeNotifier {

  FirebaseStorage _storage = FirebaseStorage.instance;
  ImagePicker _picker = ImagePicker();
  File? _image;
  List _dbList = [];
  bool _isLoading = true;

  FirebaseStorageNotifier() {
    getExistingFiles();
  }

  Future<void> getExistingFiles() async {
    try {
      ListResult listResult = await storage.ref('uploads').listAll();

      List<String> files = listResult.items.map((item) => item.fullPath).toList();

      dbList = files.map((url) => url.replaceAll('/', '%2F')).toList();

      isLoading = false;

    } catch (e) {
      print('Error fetching existing files: $e');
    }
  }

  Future<void> uploadFile() async {
    try {
      // Get the file from the image picker
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      image = File(pickedFile!.path);

      // Upload the file to Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference = storage.ref().child('uploads/$fileName.jpg');
      UploadTask uploadTask = storageReference.putFile(image!);

      isLoading = true;

      // Wait for the upload to complete and get the download URL
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => print('File Uploaded'));
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // Use the download URL as needed (e.g., save to Firestore)
      print('File uploaded successfully. Download URL: $downloadUrl');
      getExistingFiles();

    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  FirebaseStorage get storage => _storage;

  set storage(FirebaseStorage value) {
    _storage = value;
    notifyListeners();
  }

  ImagePicker get picker => _picker;

  set picker(ImagePicker value) {
    _picker = value;
    notifyListeners();
  }

  File? get image => _image;

  set image(File? value) {
    _image = value;
    notifyListeners();
  }

  List get dbList => _dbList;

  set dbList(List value) {
    _dbList = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}