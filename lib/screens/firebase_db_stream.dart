import 'package:firebase_products/notifier/firebase_stream_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirebaseDBStream extends StatelessWidget {
  const FirebaseDBStream({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FirebaseStreamNotifier(),
      child: Consumer<FirebaseStreamNotifier>(
        builder: (context, notifier, _) {
         return Scaffold(
           appBar: buildAppBar(notifier),
           body: buildBody(notifier),
           floatingActionButton: buildFloatingActionButton(notifier),
         );
        }
      ),
    );
  }

  PreferredSizeWidget buildAppBar(notifier) {
    return AppBar(
      title: const Text('Firebase DB Stream'),
      actions:  [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: notifier.deleteAllUsers,
              child: const Icon(Icons.delete)),
        )
      ],
    );
  }

  Widget buildBody(notifier) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: notifier.usersStream,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No Text'));
        }

        List<UserModel> finalData = snapshot.data!.map((data) => UserModel(
            name: data['name'],
            email: data['email'],
            age: data['age'],
            color: data['color'],
            id: data['id']
        )).toList();


        return ListView.builder(
          itemBuilder: (ctx, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(finalData[index].name ?? 'No Name'),
                subtitle: Text(finalData[index].email ?? 'No Email'),
                tileColor: finalData[index].color != null ? Color(finalData[index].color!) : Colors.blue,
              ),
            );
          },
          itemCount: finalData.length,
        );
      },
    );
  }

  Widget buildFloatingActionButton(notifier) {
    return FloatingActionButton(
      onPressed: () => notifier.addUser(UserModel(name:'user', email:'user100@gmail.com',age: 12,color: 0xFFFF980)),
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }
}

class UserModel{
  String? name;
  String? email;
  int? age;
  int? color;
  int? id;

  UserModel({this.name,this.email,this.age,this.color,this.id});
}