import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_products/screens/dummy.dart';
import 'package:firebase_products/screens/singpass.dart';
import 'package:firebase_products/screens/sqfExample.dart';
import 'package:firebase_products/widgets/common.dart';
import 'package:firebase_products/widgets/notification_services.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'screens/screen.dart';
import 'notifier/notifiers.dart';
import 'screens/d1.dart' if(dart.library.html) 'screens/d2.dart' as html;


// 73f944093bb43e467a212cf532e7fcce

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 MobileAds.instance.initialize();
//  await Firebase.initializeApp();
  try {
   await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;

   //
   // // Listen to messages while the app is in the foreground
   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
     print("Received message from FCM foreground: ${message.messageId}");
     // Extract data from message (data or notification payload)
     RemoteNotification? notification = message.notification;
     if (notification != null) {
       print("Notification title: ${notification.title}");
       print("Notification body: ${notification.body}");
       NotificationService().showNotification(message);
     }
   });

   NotificationService().init();

   // // Request permission for notifications (optional)
   NotificationSettings settings = await messaging.requestPermission(
     alert: true,
     announcement: true,
     badge: true,
     provisional: false,
   );

   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
     print('User granted permission for notifications!');
   } else {
     print('User declined or has not granted permission for notifications.');
   }

  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  // Initialize Crashlytics
 FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  // Set up error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.recordFlutterError(details);
  };
  GoogleSignIn();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<FirebaseDbNotifier>(create: (_) => FirebaseDbNotifier()),
    ChangeNotifierProvider<FirebaseStreamNotifier>(create: (_) => FirebaseStreamNotifier()),
    ChangeNotifierProvider<RealtimeDbNotifier>(create: (_) => RealtimeDbNotifier()),
    ChangeNotifierProvider<NotificationNotifier>(create: (_) => NotificationNotifier()),
    ChangeNotifierProvider<FirebaseStorageNotifier>(create: (_) => FirebaseStorageNotifier()),
    ChangeNotifierProvider<FirebaseAdMobNotifier>(create: (_) => FirebaseAdMobNotifier()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const Home(),
      // home: const SqliteExample(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton(context,'Realtime Database',routeName: const RealTimeDatabase(), logName: 'realtime_database'),
            buildButton(context,'Firestore Database',routeName: const FirebaseDB(), logName: 'firestore_database'),
            buildButton(context,'Firestore Stream Database',routeName: const FirebaseDBStream(), logName: 'firestore_stream_database'),
            buildButton(context,'Firebase Messaging',routeName: const FirebaseMessagingScreen(), logName: 'FB_Messaging'),
            buildButton(context,'Firebase Notification',routeName: const FireBaseNotification(), logName: 'FB_Notification'),
            buildButton(context,'Firebase Storage',routeName: const FirebaseStorageScreen(), logName: 'FB_Storage'),
            buildButton(context,'Firebase AdMob',routeName: const FirebaseAdMobScreen(),  logName: 'FB_AdMob'),
            buildButton(context,'Firebase Crashlytics',routeName: const FirebaseCrashlyticsScreen(),  logName: 'FB_Crash'),
            buildButton(context,'Firebase Authentication',routeName: const FirebaseAuthScreen(),  logName: 'FB_Auth'),
            // buildButton(context,'Sing Pass',routeName: const SingPassScreen(),  logName: '',
            //     onPressed: kIsWeb ? () {
            //   html.openLink();
            // } : null,
            // ),
            // buildButton(context,'SQL DB',routeName: const SqliteExample()),
            // buildButton(context,'SQL DB',routeName: const SampleData()),
          ],
        ),
      ),
    );
  }
}


///
//
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// //import 'constants/adsmanager.dart';
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   MobileAds.instance.initialize();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   BannerAd? _bannerAd;
//   int loadAttempts = 0;
//   int maxFailedLoadAttempts = 3;
//   // String testDevice = 'c7282b11-bdfc-4a94-b814-a1ce2abd2a6e';
//   String testDevice = 'dca649aa-6fd4-42e2-9411-0a55781083f2';
//   RewardedAd? _rewardedAd;
//   InterstitialAd? _interstitialAd;
//
//   String advertisingId= '';
//
//   @override
//   void initState() {
//     super.initState();
//     //Initialize the Mobile Ads SDK
//     MobileAds.instance.initialize();
//
//     RequestConfiguration(
//       testDeviceIds: [testDevice],
//     );
//
//     // Load the banner ad
//     _loadBannerAd();
//     preloadRewardedAd();
//
//   }
//
//
//   // Function to load the banner ad
//   void _loadBannerAd() {
//     _bannerAd = BannerAd(
//       adUnitId: 'ca-app-pub-8507031572669977/1095939685', // Replace with your ad unit ID
//       // adUnitId: 'ca-app-pub-7497008934040732/9058491506', // Muthu Replace with your ad unit ID
//       // adUnitId: 'ca-app-pub-3805485538389573/8680759580', // Github Replace with your ad unit ID
//       request: const AdRequest(),
//       size: AdSize.largeBanner,
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           print('Ad loaded');
//           setState(() {
//             _bannerAd = ad as BannerAd;
//           });
//         },
//         onAdFailedToLoad: (ad, err) {
//           print('Failed to load a banner ad: ${err.message}');
//           ad.dispose();
//           setState(() {
//
//           });
//           loadAttempts += 1;
//           //_interstitialAd = null;
//           if (loadAttempts < maxFailedLoadAttempts) {
//             _loadBannerAd();
//           }
//
//         },
//       ),
//     );
//     _bannerAd!.load();
//   }
//
//   BannerAd? getBannerAd() {
//     return _bannerAd;
//   }
//
//   void preloadRewardedAd() {
//     print('calling reward ad');
//     RewardedAd.load(
//       adUnitId: GoogleAdmob.rewardedAdUnitId,
//       // adUnitId: 'ca-app-pub-8507031572669977/3571458586',
//       request: const AdRequest(),
//       rewardedAdLoadCallback: RewardedAdLoadCallback(
//         onAdLoaded: (RewardedAd ad) {
//           print('reward ad $ad');
//           _rewardedAd = ad;
//         },
//         onAdFailedToLoad: (LoadAdError error) {
//           print('RewardedAd failed to load: $error');
//         },
//       ),
//     );
//   }
//
//   void showRewardedAd() {
//     print('show reward');
//     RewardedAd? rewardedAd = _rewardedAd;
//     if (rewardedAd != null) {
//       rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
//         onAdDismissedFullScreenContent: (RewardedAd ad) {
//           ad.dispose();
//           if (_interstitialAd != null) {
//             showInterstitialAd();
//           }
//           preloadRewardedAd;
//         },
//         onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
//           print('Failed to show rewarded ad: $error');
//         },
//       );
//       rewardedAd.show(
//         onUserEarnedReward: (Ad ad, RewardItem reward) async {
//           if (ad is RewardedAd) {
//             print('User earned reward: $reward');
//             // await rewardUser(reward.amount.toInt());
//           }
//         },
//       );
//     } else {
//       print('null data');
//     }
//   }
//
//   void showInterstitialAd() {
//     print('inter ad');
//     InterstitialAd? interstitialAd = _interstitialAd;
//     if (interstitialAd != null) {
//       interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
//         onAdDismissedFullScreenContent: (InterstitialAd ad) {
//           ad.dispose();
//           if (_rewardedAd != null) {
//             showRewardedAd();
//           }
//           preloadInterstitialAd();
//         },
//       );
//       interstitialAd.show();
//     }
//   }
//
//   void preloadInterstitialAd() {
//     InterstitialAd.load(
//       // adUnitId: GoogleAdmob.interstitialAdUnitId,
//       adUnitId: 'ca-app-pub-8507031572669977/2531723553',
//       request: const AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (InterstitialAd ad) {
//           _interstitialAd = ad;
//         },
//         onAdFailedToLoad: (LoadAdError error) {
//           print('InterstitialAd failed to load: $error');
//         },
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('AdMob Banner Example'),
//       ),
//       body: Center(
//         child: getBannerAd() != null
//             ? Container(
//           alignment: Alignment.bottomCenter,
//           width: getBannerAd()!.size.width.toDouble(),
//           height: getBannerAd()!.size.height.toDouble(),
//           child: AdWidget(ad: getBannerAd()!),
//         )
//             : const CircularProgressIndicator(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.white,
//         onPressed: () {
//           showRewardedAd();
//         },
//         // isExtended: true,
//         child: Icon(
//           Icons.add,
//           color: Colors.black,
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     // Dispose of the banner ad when the widget is disposed
//     _bannerAd!.dispose();
//     super.dispose();
//   }
// }
//
//
// class GoogleAdmob {
//   static String get bannerAdUnitId {
//     //   if (Platform.isAndroid) {
//     return 'ca-app-pub-3805485538389573/8680759580';
//     // } else {
//     //   throw UnsupportedError('Unsupported platform');
//     // }
//   }
//
//   static String get interstitialAdUnitId {
//     //if (Platform.isAndroid) {
//     return 'ca-app-pub-3805485538389573/9008611388';
//     // } else {
//     //  throw UnsupportedError('Unsupported platform');
//     //}
//   }
//
//   static String get rewardedAdUnitId {
//     // if (Platform.isAndroid) {
//     return 'ca-app-pub-8507031572669977/3571458586';
//     // return 'ca-app-pub-3805485538389573/5644081441';
//     // return 'ca-app-pub-7497008934040732/9058491506';
//     // } else {
//     //   throw UnsupportedError('Unsupported platform');
//     // }
//   }
// }
