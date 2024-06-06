import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_products/notifier/realtime_db_notifier.dart';
import 'package:flutter/material.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;

buildAlertDialog(context,RealtimeDbNotifier notifier) {
  return showDialog(
      context: context,
      builder: (val) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: SizedBox(
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  const Text('Name'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: notifier.nameController,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  const Text('Email'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: notifier.emailController,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  const Text('Age'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: notifier.ageController,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                        onPressed: () {
                          if(notifier.nameController.text != '' ||
                              notifier.emailController.text != '' ||
                              notifier.ageController.text != '') {
                            notifier.createRecord(
                                notifier.nameController.text,
                                notifier.emailController.text,
                                notifier.ageController.text);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Submit')),
                  ),
                ],
              ),
            ),
          ),
          title: const Text('Add Data to DB'),
        );
      });
}

Widget buildButton(context,String name, {routeName, onPressed, logName}) {
  return SizedBox(
    width: 250,
    height: 50,
    child: Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: ElevatedButton(
          onPressed: onPressed ?? () {
            Navigator.push( context, MaterialPageRoute(builder: (context) => routeName));
            sendAnalyticsReport(name: logName);
            print('button tapped $logName');
          },
          child: Text(name)),
    ),
  );
}

Future<void> sendAnalyticsReport({name,paramName = 'click_text', param1 = '', param2 = ''}) async {
  // print('Analytics method Called');
  // print('Analytics method Called $paramName');
  // print(name);
  // print(param1);
  // print(param2);
  await analytics.logEvent(
    name: name,
    parameters: <String, dynamic>{
      paramName : param1,
      'page_url': param2,
    },
  );
}

String singPassUrl = 'https://test.api.myinfo.gov.sg/serviceauth/myinfo-com/v1/authorise'
'?client_id=STG2-MYINFO-DEMO-APP&purpose=demonstrating%20MyInfo%20APIs'
'&redirect_uri=http%3A%2F%2Flocalhost%3A3001%2Fcallback'
'&response_type=code'
'&scope=uinfin%20name%20sex%20race%20nationality%20dob%'
'20email%20mobileno%20regadd%20housingtype%20hdbtype%20'
'marital%20edulevel%20noa-basic%20ownerprivate%20cpfcontributions%20cpfbalances&state=14490';