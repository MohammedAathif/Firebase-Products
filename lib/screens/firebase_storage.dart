import 'package:firebase_products/notifier/firebase_storage_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirebaseStorageScreen extends StatelessWidget {
  const FirebaseStorageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => FirebaseStorageNotifier(),
      child: Consumer<FirebaseStorageNotifier>(
        builder: (context, notifier, _) {
          return Scaffold(
            appBar: AppBar(title: const Text('File Upload Example')),
            body: buildBody(notifier),
            floatingActionButton: FloatingActionButton(
              onPressed: notifier.uploadFile,
              tooltip: 'Upload Image',
              child: const Icon(Icons.cloud_upload),
            ),
          );
        },
      ),
    );
  }

  Widget buildBody(FirebaseStorageNotifier notifier) {
    return notifier.isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () {
              return notifier.getExistingFiles();
            },
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(notifier.dbList[index]),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 200,
                        child: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/flavor-sample-original.appspot.com/o/${notifier.dbList[index]}?alt=media',
                          //'https://firebasestorage.googleapis.com/v0/b/fir-database-313a4.appspot.com/o/${notifier.dbList[index]}?alt=media'),
                          // 'https://firebasestorage.googleapis.com/v0/b/flavor-sample-original.appspot.com/o/uploads%2F1708004210897.jpg?alt=media&token=5e2026dd-25bf-45e6-ae6e-c12ea098deaa'
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return const Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                    ));
              },
              itemCount: notifier.dbList.length,
            ),
          );
  }
}