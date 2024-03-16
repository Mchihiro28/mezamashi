import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdManager implements InterstitialAdLoadCallback{
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  void interstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
        },
        onAdFailedToLoad: (error) {
          print('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_isAdLoaded) {
      _interstitialAd?.fullScreenContentCallback;
      _interstitialAd?.show();

    } else {
      print('Interstitial ad is not yet loaded.');
    }
  }

  @override
  FullScreenAdLoadErrorCallback get onAdFailedToLoad => throw UnimplementedError();

  @override
  GenericAdEventCallback<InterstitialAd> get onAdLoaded => throw UnimplementedError();
}