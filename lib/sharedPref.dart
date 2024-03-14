import 'package:shared_preferences/shared_preferences.dart';

class sharedPref{
  static Future<void> save(String key, List<String> data) async{ //List<String>で保存
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, data);
  }

  static Future<List<String>?> load(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

}
