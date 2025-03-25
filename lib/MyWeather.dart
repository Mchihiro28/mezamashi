import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'package:mezamashi/sharedPref.dart';
import 'package:weather/weather.dart';
import 'package:mezamashi/env.dart';

class MyWeather{
  //現在地の天気を取得するクラス

  //天気を取得するかどうか(設定で変更可能)
  bool weatherSetting = true;

  //現在地取得のための変数
  double _latitude = 0.0;
  double _longitude = 0.0;


  Future<void> init() async{
    var data = await sharedPref.load("weatherSetting");
    data ??= ["false"];
    weatherSetting = bool.parse(data.first);
  }

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
    final placeMarks =
    await geoCoding.placemarkFromCoordinates(_latitude, _longitude);
    final placeMark = placeMarks[0];
  }


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
      double lat = _latitude; //latitude(緯度)
      double lon = _longitude; //longitude(経度)
      WeatherFactory wf = WeatherFactory(key);

      Weather w = await wf.currentWeatherByLocation(lat, lon);
      int wetherCondition = w.weatherConditionCode!;
      String icon = '';
      if(wetherCondition > 801){
        icon = '☁️';
      }else if(wetherCondition == 801){
        icon = '⛅';
      }else if(wetherCondition == 800){
        icon = '☀️';
      }else if(wetherCondition >= 700){
        icon = '🌀';
      }else if(wetherCondition >= 600){
        icon = '❄️';
      }else if(wetherCondition >= 500){
        icon = '☂️';
      }else if(wetherCondition >= 300){
        icon = '🌂';
      }else if(wetherCondition >= 200){
        icon = '⚡';
      }

      return [w.weatherMain!, icon, w.temperature!.celsius.toString(), w.humidity.toString()];
    } catch (e) {
      print('位置情報を取得できませんでした。');
      return ['loc err', '位置情報を取得できませんでした。'];
    }
  }
}