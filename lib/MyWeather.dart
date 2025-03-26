import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'package:mezamashi/sharedPref.dart';
import 'package:weather/weather.dart';
import 'package:mezamashi/env.dart';

/// 現在地の天気を取得するクラス
///
/// OpenWeatherAPIを用いて天気を取得する。
class MyWeather{


  ///天気を取得するかどうか(設定で変更可能)
  bool weatherSetting = true;

  //現在地取得のための変数
  double _latitude = 0.0;
  double _longitude = 0.0;


  /// [MyWeather]の初期化を行う。
  ///
  /// 天気を取得するかの設定を読み込む。
  Future<void> init() async{
    var data = await sharedPref.load("weatherSetting");
    data ??= ["false"];
    weatherSetting = bool.parse(data.first);
  }

  /// 位置情報を取得する。
  ///
  /// 権限が必要。緯度・経度、地名情報を取得できる。
  Future<void> getLocation() async {
    // 権限を取得
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print('位置情報取得の権限がありません');
      return;
    }
    // 位置情報を取得
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

      // 北緯がプラス、南緯がマイナス
      _latitude = position.latitude;
      // 東経がプラス、西経がマイナス
      _longitude = position.longitude;

    //取得した緯度経度からその地点の地名情報を取得する
    final placeMarks = await geoCoding.placemarkFromCoordinates(_latitude, _longitude);
    final placeMark = placeMarks[0];
  }

  /// 天気を取得する。
  ///
  /// 返り値はサイズ3のリストで要素は以下の通り。
  /// 1. 天気コード
  /// 2. 温度
  /// 3. 湿度
  ///
  /// 天気を取得しない場合は代わりにポイントを返す（リストサイズ1）。
  Future<List<String>> getWeather() async {
    if(!weatherSetting){
      return ['ws is f', ' pt']; //天気の代わりにポイントを表示
    }

    // 権限を取得
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print('位置情報取得の権限がありません');
      return ['per err', '位置情報取得の権限がありません']; //snackbarを出す
    }

    try {
      await getLocation();
      //APIキー
      String key = Env.pass1;
      //latitude(緯度)
      double lat = _latitude;
      //longitude(経度)
      double lon = _longitude;
      WeatherFactory wf = WeatherFactory(key);

      Weather w = await wf.currentWeatherByLocation(lat, lon);

      // 天気コード（天気の状態を示す）
      int weatherCondition = w.weatherConditionCode!;
      String icon = '';
      if(weatherCondition > 801){
        icon = '☁️';
      }else if(weatherCondition == 801){
        icon = '⛅';
      }else if(weatherCondition == 800){
        icon = '☀️';
      }else if(weatherCondition >= 700){
        icon = '🌀';
      }else if(weatherCondition >= 600){
        icon = '❄️';
      }else if(weatherCondition >= 500){
        icon = '☂️';
      }else if(weatherCondition >= 300){
        icon = '🌂';
      }else if(weatherCondition >= 200){
        icon = '⚡';
      }

      return [w.weatherMain!, icon, w.temperature!.celsius.toString(), w.humidity.toString()];
    } catch (e) {
      print('位置情報を取得できませんでした。');
      return ['loc err', '位置情報を取得できませんでした。'];
    }
  }
}