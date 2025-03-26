import 'package:envied/envied.dart';
part "env.g.dart";


/// Enviedを用いてAPIキーを隠ぺいする。
@Envied(path: 'env/.env')
abstract class Env {

  //varNameに設定する名前は「.envファイル」内に記載している「キーの名前」を記入する
  @EnviedField(varName: 'OPEN_WEATHER_API_KEY', obfuscate: true)
  static String pass1 = _Env.pass1;
}