import 'package:firebase_products/notifier/realtime_db_notifier.dart';
import 'package:firebase_products/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RealTimeDatabase extends StatelessWidget {
  const RealTimeDatabase({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => RealtimeDbNotifier(),
      child: Consumer<RealtimeDbNotifier>(
        builder: (context, notifier, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Realtime Database'),
              actions:  [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: notifier.deleteAllUsers,
                      child: const Icon(Icons.delete)),
                )
              ],
            ),
            body: buildBody(notifier),
            floatingActionButton: FloatingActionButton(
              onPressed: () => buildAlertDialog(context,notifier),
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  Widget buildBody(notifier) {
    print(notifier.isLoading);
    return notifier.isLoading
        ? const Center(child: CircularProgressIndicator())
        : notifier.dbData.isEmpty
            ? const Center(child: Text('No Data in DB'))
            : ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text('Name : ${notifier.dbData[index]['name']}'),
                        const SizedBox(height: 10),
                        Text('Email : ${notifier.dbData[index]['email'].toString()}'),
                        const SizedBox(height: 10),
                        Text('Age: ${notifier.dbData[index]['age'].toString()}'),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                },
                itemCount: notifier.dbData.length,
              );
  }
}
