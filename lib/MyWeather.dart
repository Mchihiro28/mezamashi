import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'package:weather/weather.dart';

class MyWeather{
  //現在地の天気を取得するクラス

  //天気を取得するかどうか(設定で変更可能)
  bool weatherSetting = true;

  //現在地取得のための変数
  double _latitude = 0.0;
  double _longitude = 0.0;

  //位置情報取得のためのメソッド
  Future<void> getLocation() async {
    // 権限を取得
    LocationPermission permission = await Geolocator.requestPermission();
    // 権限がない場合は戻る
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
      print('現在地の緯度は、$_latitude');
      print('現在地の経度は、$_longitude');

    //取得した緯度経度からその地点の地名情報を取得する
    final placeMarks =
    await geoCoding.placemarkFromCoordinates(_latitude, _longitude);
    final placeMark = placeMarks[0];
    print("現在地の国は、${placeMark.country}");
    print("現在地の県は、${placeMark.administrativeArea}");
    print("現在地の市は、${placeMark.locality}");
    // setState(() {
    //   Now_location = placeMark.locality ?? "現在地データなし";
    //   ref.read(riverpodNowLocation.notifier).state = Now_location;
    //   print('現在地は、$Now_location');
    // });
  }

  //天気情報を取得するためのメソッド
  Future<String?> getWeather() async {
    if(weatherSetting){
      return 'weatherSetting is false';
    }

    // 権限を取得
    LocationPermission permission = await Geolocator.requestPermission();
    // 権限がない場合は戻る
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print('位置情報取得の権限がありません');
      return 'permission error';
    }

    try {
      await getLocation();
      //自身のAPIキー
      String key = "e918267d9696f7fdbbae61c7f1138671";
      double lat = _latitude; //latitude(緯度)
      double lon = _longitude; //longitude(経度)
      WeatherFactory wf = WeatherFactory(key);

      Weather w = await wf.currentWeatherByLocation(lat, lon);

      print('天気情報は$w');
      return w.weatherMain;
    } catch (e) {
      //exceptionが発生した場合のことをかく
      print('位置情報を取得できませんでした。位置情報の利用を許可してください。');
      return 'cannot get location';
    }
  }

}