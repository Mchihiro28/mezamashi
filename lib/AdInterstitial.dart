import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mezamashi/sharedPref.dart';

class InterstitialAdManager implements InterstitialAdLoadCallback{
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  int createdCount =0; //アラームを何回作ったかをカウントする
  final int displayPeriod = 3; //3回に1回広告を表示する

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

    getCount();
  }

  void getCount() async{
    var data = await sharedPref.load("Interstitial");
    data ??= ["0"];
    createdCount = int.parse(data.first);
  }

  void addCount() async{
    createdCount += 1;
    sharedPref.save("Interstitial",["$createdCount"]);
  }

  bool showInterstitialAd() {
    addCount();
    if((createdCount % displayPeriod) != 0){
      return false;
    }

    if (_isAdLoaded) {
      _interstitialAd?.fullScreenContentCallback;
      _interstitialAd?.show();
      return true;
    } else {
      print('Interstitial ad is not yet loaded.');
      return false;
    }
  }

  @override
  FullScreenAdLoadErrorCallback get onAdFailedToLoad => throw UnimplementedError();

  @override
  GenericAdEventCallback<InterstitialAd> get onAdLoaded => throw UnimplementedError();
}