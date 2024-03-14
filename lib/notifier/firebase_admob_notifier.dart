import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FirebaseAdMobNotifier extends ChangeNotifier {
  BannerAd? _bannerAd;
  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;

  int _loadAttempts = 0;
  int _maxFailedLoadAttempts = 3;

  // String testDevice = 'c7282b11-bdfc-4a94-b814-a1ce2abd2a6e';
  String _testDevice = 'dca649aa-6fd4-42e2-9411-0a55781083f2';
  String _advertisingId= '';

  // Function to load the banner ad
  void _loadBannerAd() {
    _bannerAd = BannerAd(
      // adUnitId: 'ca-app-pub-8507031572669977/1095939685', // Replace with your ad unit ID
      adUnitId: 'ca-app-pub-7497008934040732/9058491506', // Muthu Replace with your ad unit ID
      // adUnitId: 'ca-app-pub-3805485538389573/8680759580', // Github Replace with your ad unit ID
      request: const AdRequest(),
      size: AdSize.largeBanner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('Ad loaded');
            _bannerAd = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
          loadAttempts += 1;
          //_interstitialAd = null;
          if (loadAttempts < maxFailedLoadAttempts) {
            _loadBannerAd();
          }

        },
      ),
    );
    _bannerAd!.load();
  }

  BannerAd? getBannerAd() {
    return _bannerAd;
  }

  void preloadRewardedAd() {
    print('calling reward ad');
    RewardedAd.load(
      adUnitId: GoogleAdmob.rewardedAdUnitId,
      // adUnitId: 'ca-app-pub-8507031572669977/3571458586',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('reward ad $ad');
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  void showRewardedAd() {
    print('show reward');
    RewardedAd? rewardedAd = _rewardedAd;
    if (rewardedAd != null) {
      rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          ad.dispose();
          if (_interstitialAd != null) {
            showInterstitialAd();
          }
          preloadRewardedAd;
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          print('Failed to show rewarded ad: $error');
        },
      );
      rewardedAd.show(
        onUserEarnedReward: (Ad ad, RewardItem reward) async {
          if (ad is RewardedAd) {
            print('User earned reward: $reward');
            // await rewardUser(reward.amount.toInt());
          }
        },
      );
    } else {
      print('null data');
    }
  }

  void showInterstitialAd() {
    print('inter ad');
    InterstitialAd? interstitialAd = _interstitialAd;
    if (interstitialAd != null) {
      interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          if (_rewardedAd != null) {
            showRewardedAd();
          }
          preloadInterstitialAd();
        },
      );
      interstitialAd.show();
    }
  }

  void preloadInterstitialAd() {
    InterstitialAd.load(
      // adUnitId: GoogleAdmob.interstitialAdUnitId,
      adUnitId: 'ca-app-pub-8507031572669977/2531723553',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  FirebaseAdMobNotifier() {
    MobileAds.instance.initialize();

    RequestConfiguration(
      testDeviceIds: [testDevice],
    );

    // Load the banner ad
    _loadBannerAd();
    preloadRewardedAd();
  }

  int get loadAttempts => _loadAttempts;

  set loadAttempts(int value) {
    _loadAttempts = value;
    notifyListeners();
  }

  int get maxFailedLoadAttempts => _maxFailedLoadAttempts;

  set maxFailedLoadAttempts(int value) {
    _maxFailedLoadAttempts = value;
    notifyListeners();
  }

  String get advertisingId => _advertisingId;

  set advertisingId(String value) {
    _advertisingId = value;
    notifyListeners();
  }

  InterstitialAd? get interstitialAd => _interstitialAd;

  set interstitialAd(InterstitialAd? value) {
    _interstitialAd = value;
    notifyListeners();
  }

  RewardedAd? get rewardedAd => _rewardedAd;

  set rewardedAd(RewardedAd? value) {
    _rewardedAd = value;
    notifyListeners();
  }

  String get testDevice => _testDevice;

  set testDevice(String value) {
    _testDevice = value;
    notifyListeners();
  }


  BannerAd? get bannerAd => _bannerAd;

  set bannerAd(BannerAd? value) {
    _bannerAd = value;
    notifyListeners();
  }
}

class GoogleAdmob {
  static String get bannerAdUnitId {
    //   if (Platform.isAndroid) {
    return 'ca-app-pub-3805485538389573/8680759580';
    // } else {
    //   throw UnsupportedError('Unsupported platform');
    // }
  }

  static String get interstitialAdUnitId {
    //if (Platform.isAndroid) {
    return 'ca-app-pub-3805485538389573/9008611388';
    // } else {
    //  throw UnsupportedError('Unsupported platform');
    //}
  }

  static String get rewardedAdUnitId {
    // if (Platform.isAndroid) {
    return 'ca-app-pub-8507031572669977/3571458586';
    // return 'ca-app-pub-3805485538389573/5644081441';
    // return 'ca-app-pub-7497008934040732/9058491506';
    // } else {
    //   throw UnsupportedError('Unsupported platform');
    // }
  }
}