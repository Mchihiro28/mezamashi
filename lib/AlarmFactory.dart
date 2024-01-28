import 'dart:collection';
import 'MyAlarm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AlarmFactory{
  //MyAlarmクラスのインスタンスを生成、管理するクラス
  //TODO firebaseかsharedpreferanceにアラームの中身を保存する
  List<MyAlarm> alarms = List<MyAlarm>.empty(); //作ったアラームのインスタンスを格納するリスト

  AlarmFactory(){
    getPreference();
  }


  void sortAlarm(){ //alarmを時刻順に並び替える
    SplayTreeMap<int, MyAlarm> timeValues = SplayTreeMap();
    for (var element in alarms) {
      timeValues[element.hour*60 +element.min] = element;
    }
    alarms.clear();
    alarms.addAll(List.from(timeValues.values));
  }

  MyAlarm createAlarms( int hour,  //新しいalarmを作成
                     int min,
                     String assetAudio){
    MyAlarm customAlarm = MyAlarm(-1,hour, min, assetAudio);
    customAlarm.createAlarm();
    alarms.add(customAlarm);
    sortAlarm();
    return customAlarm;
  }

  void deleteAlarm(int index){ //alarmを削除する
    alarms[index].stopAlarm();
    alarms.removeAt(index);
  }

  Future<void> setPreference() async { //sharedPreferenceに保存
    List<String> alarmInfo = List<String>.empty();
    for (var element in alarms) {
      alarmInfo.add(element.exportSettings());
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('alarms', alarmInfo);
  }

  Future<void> getPreference() async { //sharedPreferanceから取得
    List<String>? temp = List<String>.empty();
    final prefs = await SharedPreferences.getInstance();
    temp = prefs.getStringList('alarms');
    if(temp != null) {
      for (var element in temp) {
        final List<String> l = List<String>.from(json.decode(element));
        //このメソッドを使うときはalarmsが空の前提
        alarms.add(MyAlarm(
            int.parse(l[0]), int.parse(l[1]), int.parse(l[2]), l[3]));
      }
      sortAlarm();
    }
  }

}
