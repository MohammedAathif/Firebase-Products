import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_products/notifier/firebase_auth_notifier.dart';
import 'package:firebase_products/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirebaseAuthScreen extends StatelessWidget {
  const FirebaseAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication Example'),
      ),
      body: ChangeNotifierProvider(
        create: (context) => FirebaseAuthNotifier(),
        child: Consumer<FirebaseAuthNotifier>(
          builder: (context, notifier, _) {
            return notifier.options
                ? buildOptions(context, notifier)
                : buildUi(notifier);
          },
        ),
      ),
    );
  }

  Widget buildOptions(context, FirebaseAuthNotifier notifier) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildButton(context, 'Sign In with Email', onPressed: () {
            notifier.options = false;
            notifier.isEmail = true;
          }),
          buildButton(context, 'Sign In with Phone', onPressed: () {
            notifier.options = false;
            notifier.isPhone = true;
          }),
          buildButton(context, 'Sign In with Google', onPressed: () {
            notifier.options = false;
            notifier.isGoogle = true;
          }),
        ],
      ),
    );
  }

  Widget buildUi(notifier) {
    return Center(
        child: ValueListenableBuilder(
            valueListenable: notifier.userCredential,
            builder: (context, value, child) {
              return (notifier.userCredential.value == '' ||
                      notifier.userCredential.value == null)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (notifier.isEmail) buildEmailBlock(notifier),
                        if (notifier.isGoogle) buildGoogleBlock(notifier),
                        if (notifier.isPhone) buildPhoneBlock(notifier)
                      ],
                    )
                  : buildSuccessScreen(notifier);
            }));
  }

  Widget buildSuccessScreen(notifier) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.5, color: Colors.black54)),
              child: Image.network(
                  notifier.userCredential.value.user!.photoURL.toString()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(notifier.userCredential.value.user!.displayName.toString()),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Text(notifier.userCredential.value.user!.email.toString()),
          ),
          ElevatedButton(
              onPressed: () async {
                bool result = await notifier.signOutFromGoogle();
                if (result) {
                  notifier.userCredential.value = '';
                  notifier.isGoogle = false;
                  notifier.isEmail = false;
                  notifier.isPhone = false;
                  notifier.options = true;
                }
              },
              child: const Text('Logout'))
        ],
      ),
    );
  }

  Widget buildEmailBlock(FirebaseAuthNotifier notifier) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              decoration: const InputDecoration(
                  hintText: 'Enter Email', border: OutlineInputBorder()),
              controller: notifier.emailController,
              onChanged: (val) {
                notifier.errorMessage = '';
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              decoration: const InputDecoration(
                  hintText: 'Enter Password', border: OutlineInputBorder()),
              controller: notifier.passController,
              onChanged: (val) {
                notifier.errorMessage = '';
              },
            ),
          ),
        ),
        if (notifier.errorMessage != '')
          Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  notifier.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: notifier.emailSignUp,
                  child: const Text('Sign Up')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: notifier.emailSignIn,
                  child: const Text('Sign In')),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildGoogleBlock(notifier) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: IconButton(
          iconSize: 20,
          icon: Image.network(
              'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png'),
          onPressed: () async {
            notifier.userCredential.value = await notifier.signInWithGoogle();
            if (notifier.userCredential.value != null) {
              print('email data');
              print(notifier.userCredential.value.user!.email);
            } else {
              print('error');
            }
          },
        ),
      ),
    );
  }

  Widget buildPhoneBlock(notifier) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              decoration: const InputDecoration(
                  hintText: 'Enter Mobile Number',
                  border: OutlineInputBorder()),
              controller: notifier.phoneController,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 28,top: 8,right: 8,left: 8),
          child: ElevatedButton(
              onPressed: () async {
                await notifier.verifyPhoneNumber();
              },
              child: const Text('Send Verification Code')),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 28,top: 8,right: 8,left: 8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              decoration: const InputDecoration(
                  hintText: 'Verification Code', border: OutlineInputBorder()),
              onChanged: (value) {
                notifier.verificationId = value;
              },
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await notifier.signInWithPhoneNumber();
          },
          child: const Text('Verify Code'),
        ),
      ],
    );
  }
}
