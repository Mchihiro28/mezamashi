import 'package:shared_preferences/shared_preferences.dart';

/// sharedPreferenceを用いて設定を保存するクラス
class sharedPref{

  /// sharedPrefでデータを保存する。
  ///
  /// キーと値の形式で保存する。<br>
  /// 引数
  /// - キー[key] \<String>
  /// - 値[data] List\<String>
  static Future<void> save(String key, List<String> data) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, data);
  }

  /// sharedPrefでデータをロードする。
  ///
  /// キー[key]に対応するデータを返す。<br>
  /// 引数：キー[key] \<String> <br>
  /// 返り値：List\<String>
  static Future<List<String>?> load(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

}
