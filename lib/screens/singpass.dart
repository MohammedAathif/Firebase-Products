import 'dart:convert';
import 'dart:io';
import 'package:firebase_products/main.dart';
import 'package:firebase_products/singpass_model.dart';
import 'package:firebase_products/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'package:http/http.dart' as http;

class SingPassScreen extends StatefulWidget {
  const SingPassScreen({super.key});

  @override
  State<SingPassScreen> createState() => _SingPassScreenState();
}

class _SingPassScreenState extends State<SingPassScreen> {

  late WebViewXController webController;
  late int loadingPercentage = 0;


  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        // elevation: 0,
      ),
      body: Stack(
        children: [
          WebViewX(
              onWebViewCreated: (controller) {
                webController = controller;
              },
              navigationDelegate: (val) {
                final host = Uri.parse(val.content.source).host;

                final uri = Uri.parse(val.content.source);

                if(host.contains('localhost')) {
                  final code = uri.queryParameters['code'];
                  final state = uri.queryParameters['state'];

                  //callData(localUrl.replaceAll('localhost', '192.168.2.22'));
                  // callData(localUrl.replaceAll('localhost', '10.0.2.2'));
                  callData(code,state);
                }
                return NavigationDecision.navigate;
              },
              initialSourceType: SourceType.urlBypass,
              javascriptMode: JavascriptMode.unrestricted,
              webSpecificParams: const WebSpecificParams(
                printDebugInfo: true,
              ),
              mobileSpecificParams: const MobileSpecificParams(
                androidEnableHybridComposition: true,
              ),
              onPageStarted: (url) async {
                setState(() {
                  loadingPercentage = 0;
                });
              },
              onPageFinished: (url)  {
                setState(() {
                  loadingPercentage = 100;
                });
              },
            initialContent: singPassUrl,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height),
          // loadingPercentage != 100 ? const Center(child: CircularProgressIndicator())
          //     : Stack(),
        ],
      ),
    );
  }

  callData(authCode, state) async {
    //print('url $uri');

    String url = 'http://10.0.2.2:3001/getPersonData';

    Map<String, dynamic> payload = {
      'authCode': authCode,
      'state': state,
    };
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(payload),
    );
    print('res ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Response: ${response.body}');

      Welcome personData = Welcome.fromJson(jsonDecode(response.body));


       Navigator.pushReplacement (
        context,
        MaterialPageRoute (
          builder: (BuildContext context) =>  ResponseDisplayScreen(responseData: personData,),
        ),
      );

      // await saveResponseToFile(response.body);
      // Successful response
      // setState(() {
      //   _response = 'Response: ${response.body}';
      // });
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ResponseDisplayScreen(responseData: response.body),
      //   ),
      // );
    } else {
      print('else part');
      // Handle unsuccessful response
      // setState(() {
      //   _response = 'Error: ${response.statusCode}';
      // });
    }
  }

  Future<void> saveResponseToFile(String response) async {
    // Specify the file path where you want to save the response
    const String filePath = 'response.txt';

    // Create a File object
    final File file = File(filePath);

    try {
      // Write the response to the file
      await file.writeAsString(response);

      print('Response saved to file: $filePath');
    } catch (e) {
      print('Error saving response to file: $e');
    }
  }
}

class ResponseDisplayScreen extends StatelessWidget {
  final Welcome responseData;

  // Constructor to receive the response data
  const ResponseDisplayScreen({Key? key, required this.responseData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Response Display'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                responseData.name!.value,
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                responseData.sex!.desc.toString(),
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                responseData.race!.desc.toString(),
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                responseData.nationality!.desc.toString(),
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                responseData.dob!.value.toString(),
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                responseData.email!.value.toString(),
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                responseData.mobileno!.nbr!.value.toString(),
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '${responseData.regadd!.unit!.value}, ${responseData.regadd!.street!.value}, ${responseData.regadd!.postal!.value}' ,
                style: TextStyle(fontSize: 16.0),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
