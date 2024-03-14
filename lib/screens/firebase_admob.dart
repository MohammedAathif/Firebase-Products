import 'package:firebase_products/notifier/firebase_admob_notifier.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class FirebaseAdMobScreen extends StatelessWidget {
  const FirebaseAdMobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
     create: (BuildContext context) => FirebaseAdMobNotifier(),
     child: Consumer<FirebaseAdMobNotifier>(
     builder: (context, notifier, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('AdMob Banner Example'),
        ),
        body: buildBody(notifier),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            notifier.showRewardedAd();
          },
          // isExtended: true,
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      );
  }));
  }

  Widget buildBody(FirebaseAdMobNotifier notifier) {
    return Center(
      child: notifier.getBannerAd() != null
          ? Container(
              alignment: Alignment.bottomCenter,
              width: notifier.getBannerAd()!.size.width.toDouble(),
              height: notifier.getBannerAd()!.size.height.toDouble(),
              child: AdWidget(ad: notifier.getBannerAd()!),
            )
          : const CircularProgressIndicator(),
    );
  }

}



// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// class FirebaseAdMobScreen extends StatefulWidget {
//   const FirebaseAdMobScreen({super.key});
//
//   @override
//   State<FirebaseAdMobScreen> createState() => _FirebaseAdMobScreenState();
// }
//
// class _FirebaseAdMobScreenState extends State<FirebaseAdMobScreen> {
//
//   MobileAds mobileAds = MobileAds.instance;
//   InterstitialAd? _interstitialAd;
//   int _numInterstitialLoadAttempts = 0;
//   RewardedAd? _rewardedAd;
//   int _numRewardedAdLoadAttempts = 0;
//   late BannerAd _bannerAd;
//   int _numBannerAdLoadAttempts = 0;
//
//
//   static const AdRequest request = AdRequest(
//     keywords: <String>['foo', 'bar'],
//     contentUrl: 'http://foo.com/bar.html',
//     nonPersonalizedAds: true,
//   );
//
//   int maxFailedLoadAttempts = 3;
//   String testDevice = 'c7282b11-bdfc-4a94-b814-a1ce2abd2a6e';
//
//   late InterstitialAd _interstitialAd1;
//   bool _isInterstitialAdReady = false;
//
//
//   @override
//   void initState() {
//     super.initState();
//     MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
//       testDeviceIds: [testDevice],
//     ));
//     loadBannerAd();
//     //_loadInterstitialAd();
//     // _loadInterstitialAd();
//     //
//     // _createInterstitialAd();
//     // _createRewardedAd();
//     // _createBannerAd();
//   }
//
//   loadBannerAd() {
//     _bannerAd = BannerAd(
//       adUnitId: 'ca-app-pub-8507031572669977/5681519120',
//       // adUnitId: 'ca-app-pub-8507031572669977/1095939685',
//       // adUnitId: 'ca-app-pub-8507031572669977/4854634567',
//       // adUnitId: 'ca-app-pub-8507031572669977/2531723553',
//       request: const AdRequest(),
//       size: AdSize.banner,
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           print('ad loaded');
//           print(ad);
//           setState(() {
//             _bannerAd = ad as BannerAd;
//           });
//         },
//         onAdFailedToLoad: (ad, err) {
//           print('Failed to load a banner ad: ${err.message}');
//           ad.dispose();
//         },
//       ),
//     )..load();
//   }
//
//   void _loadInterstitialAd() {
//     InterstitialAd.load(
//       adUnitId: 'ca-app-pub-8507031572669977/2531723553', // Replace with your ad unit ID
//       request: AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (ad) {
//           print('Interstitial Ad loaded');
//           setState(() {
//             _interstitialAd = ad as InterstitialAd;
//             _isInterstitialAdReady = true;
//           });
//         },
//         onAdFailedToLoad: (err) {
//           print('Failed to load an interstitial ad: ${err.message}');
//         },
//       ),
//     );
//   }
//
//   // Function to show the interstitial ad
//   void _showInterstitialAd() {
//     if (_isInterstitialAdReady) {
//       _interstitialAd1.show();
//     } else {
//       print('Interstitial ad not ready yet.');
//     }
//   }
//
//
//   void _loadInterstitialAd1() {
//     InterstitialAd.load(
//       adUnitId: 'ca-app-pub-8507031572669977/2531723553',
//       request: const AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (ad) {
//           _interstitialAd = ad;
//           print('interstitial ad loaded!!!!!!');
//         },
//         onAdFailedToLoad: (err) {
//           print('Failed to load an interstitial ad: ${err.message}');
//           _interstitialAd = null;
//         },
//       ),
//     );
//   }
//
//   void _showIntersitialAd() {
//     if (_interstitialAd != null) {
//       _interstitialAd?.show();
//       _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
//         ad.dispose();
//         _loadInterstitialAd();
//       }, onAdFailedToShowFullScreenContent: ((ad, error) {
//         ad.dispose();
//         _loadInterstitialAd();
//       }));
//     }
//   }
//
//   void _createInterstitialAd() {
//     InterstitialAd.load(
//         adUnitId: 'ca-app-pub-8507031572669977/2531723553',
//         request: request,
//         adLoadCallback: InterstitialAdLoadCallback(
//           onAdLoaded: (InterstitialAd ad) {
//             print('$ad loaded');
//             _interstitialAd = ad;
//             _numInterstitialLoadAttempts = 0;
//             _interstitialAd!.setImmersiveMode(true);
//           },
//           onAdFailedToLoad: (LoadAdError error) {
//             print('InterstitialAd failed to load: $error.');
//             _numInterstitialLoadAttempts += 1;
//             _interstitialAd = null;
//             if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
//               _createInterstitialAd();
//             }
//           },
//         ));
//   }
//
//   void _showInterstitialAd1() {
//     if (_interstitialAd == null) {
//       print('Warning: attempt to show interstitial before loaded.');
//       return;
//     }
//     _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (InterstitialAd ad) =>
//           print('ad onAdShowedFullScreenContent.'),
//       onAdDismissedFullScreenContent: (InterstitialAd ad) {
//         print('$ad onAdDismissedFullScreenContent.');
//         ad.dispose();
//         _createInterstitialAd();
//       },
//       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
//         print('$ad onAdFailedToShowFullScreenContent: $error');
//         ad.dispose();
//         _createInterstitialAd();
//       },
//     );
//     _interstitialAd!.show();
//     _interstitialAd = null;
//   }
//
//   void _createBannerAd() {
//     BannerAd(
//       adUnitId: 'ca-app-pub-8507031572669977/1095939685',
//       size: AdSize.banner,
//       listener: BannerAdListener(
//           onAdLoaded: (val) {
//          //   _bannerAd = val as BannerAd?;
//           }
//       ),
//       request: request,
//     );
//   }
//
//   void _showBannerAd() {
//     if (_bannerAd == null) {
//       print('Warning: attempt to show interstitial before loaded.');
//       return;
//     }
//     _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (InterstitialAd ad) =>
//           print('ad onAdShowedFullScreenContent.'),
//       onAdDismissedFullScreenContent: (InterstitialAd ad) {
//         print('$ad onAdDismissedFullScreenContent.');
//         ad.dispose();
//         _createBannerAd();
//       },
//       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
//         print('$ad onAdFailedToShowFullScreenContent: $error');
//         ad.dispose();
//         _createBannerAd();
//       },
//     );
//     _interstitialAd!.show();
//     _interstitialAd = null;
//   }
//
//   void _createRewardedAd() {
//     RewardedAd.load(
//         adUnitId: 'ca-app-pub-8507031572669977~2768114007',
//         request: request,
//         rewardedAdLoadCallback: RewardedAdLoadCallback(
//           onAdLoaded: (RewardedAd ad) {
//             print('$ad loaded.');
//             _rewardedAd = ad;
//             _numRewardedAdLoadAttempts = 0;
//           },
//           onAdFailedToLoad: (LoadAdError error) {
//             print('RewardedAd failed to load: $error');
//             _rewardedAd = null;
//             _numRewardedAdLoadAttempts += 1;
//             if (_numRewardedAdLoadAttempts < maxFailedLoadAttempts) {
//               _createRewardedAd();
//             }
//           },
//         )
//     );
//   }
//
//   void _showRewardedAd() {
//     if (_rewardedAd == null) {
//       print('Warning: attempt to show rewarded before loaded.');
//       return;
//     }
//     _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (RewardedAd ad) =>
//           print('ad onAdShowedFullScreenContent.'),
//       onAdDismissedFullScreenContent: (RewardedAd ad) {
//         print('$ad onAdDismissedFullScreenContent.');
//         ad.dispose();
//         _createRewardedAd();
//       },
//       onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
//         print('$ad onAdFailedToShowFullScreenContent: $error');
//         ad.dispose();
//         _createRewardedAd();
//       },
//     );
//
//     _rewardedAd!.setImmersiveMode(true);
//     _rewardedAd!.show(
//         onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
//           print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
//         });
//     _rewardedAd = null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Firebase AdMob')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('Firebase AdMob'),
//               ElevatedButton(onPressed: _showInterstitialAd, child: const Text('Show Interstitial AD')),
//               ElevatedButton(onPressed: _showRewardedAd, child: const Text('Show AD')),
//               // Container(
//               //       alignment: Alignment.center,
//               //       width: _bannerAd.size.width.toDouble(),
//               //       height: _bannerAd.size.height.toDouble(),
//               //       child: AdWidget(ad: _bannerAd),
//               //     ),
//             ElevatedButton(
//               onPressed: _showInterstitialAd,
//               child: Text('Show Interstitial Ad'),
//             ),
//             Container(
//               alignment: Alignment.center,
//               width: _bannerAd.size.width.toDouble(),
//               height: _bannerAd.size.height.toDouble(),
//               child: AdWidget(ad: _bannerAd),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     // Dispose of the interstitial ad when the widget is disposed
//     _interstitialAd1.dispose();
//     super.dispose();
//   }
// }

///
// working code
//import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// class FirebaseAdMobScreen extends StatefulWidget {
//   const FirebaseAdMobScreen({super.key});
//
//   @override
//   State<FirebaseAdMobScreen> createState() => _FirebaseAdMobScreenState();
// }
//
// class _FirebaseAdMobScreenState extends State<FirebaseAdMobScreen> {
//
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
//   // Function to load the banner ad
//   void _loadBannerAd() {
//     _bannerAd = BannerAd(
//       // adUnitId: 'ca-app-pub-8507031572669977/1095939685', // Replace with your ad unit ID
//       adUnitId: 'ca-app-pub-7497008934040732/9058491506', // Muthu Replace with your ad unit ID
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