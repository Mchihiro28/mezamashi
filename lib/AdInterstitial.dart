import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mezamashi/sharedPref.dart';

    /// admobのインタースティシャル広告を表示するクラス
class InterstitialAdManager implements InterstitialAdLoadCallback{

  InterstitialAd? _interstitialAd;

  /// インタースティシャル広告が無事に表示読み込めたかのフラグ
  bool _isAdLoaded = false;
  ///アラームを何回作ったかをカウントする変数
  int createdCount = 0;
  ///3回アラームを作成するごとに1回広告を表示する変数
  final int displayPeriod = 3;
  ///インタースティシャル広告の広告ID
  final String interstitialAdUnitId = 'ca-app-pub-2742833893230662/9354183551';

  void interstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
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

  /// アラームの作成回数を取得する。
  void getCount() async{
    var data = await sharedPref.load("Interstitial");
    data ??= ["0"]; // 取得できない場合は0
    createdCount = int.parse(data.first);
  }

  /// アラームの作成回数を1増やす。
  void addCount() async{
    createdCount += 1;
    sharedPref.save("Interstitial",["$createdCount"]);
  }

  /// displayPeriod回に1回広告を表示する。
  /// 読み込みに失敗した場合はそのまま再読み込みする。
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