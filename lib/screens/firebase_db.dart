import 'package:firebase_products/notifier/firebase_db_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirebaseDB extends StatelessWidget {
  const FirebaseDB({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => FirebaseDbNotifier(),
      child: Consumer<FirebaseDbNotifier>(
          builder: (BuildContext context, notifier, _) => Scaffold(
                appBar: AppBar(title: const Text('Firebase DB')),
                body: buildBody(notifier),
                floatingActionButton: buildFloatingActionButton(notifier),
              )),
    );
  }

  Widget buildBody(FirebaseDbNotifier notifier) {
    return RefreshIndicator(
      onRefresh: () {
        return notifier.futureData = notifier.fetchUser();
      },
      child: FutureBuilder(
        future: notifier.futureData,
        builder:
            (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          List<Map<String, dynamic>> datas = snapshot.data ?? [];

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return datas.isEmpty
              ? const Center(child: Text('No Text'))
              : ListView.builder(
                  itemBuilder: (ctx, index) {
                    return ListTile(
                      title: Text(datas[index]['name'] ?? ''),
                      subtitle: Text(datas[index]['email'] ?? ''),
                    );
                  },
                  itemCount: datas.length,
                );
        },
      ),
    );
  }

  Widget buildFloatingActionButton(FirebaseDbNotifier notifier) {
    return FloatingActionButton(
      onPressed: notifier.onPressed,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }
}
