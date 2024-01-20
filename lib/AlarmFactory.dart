import 'dart:collection';
import 'MyAlarm.dart';

class AlarmFactory{
  //MyAlarmクラスのインスタンスを生成、管理するクラス
  List<MyAlarm> alarms = List<MyAlarm>.empty(); //作ったアラームのインスタンスを格納するリスト


  void sortAlarm(){ //alarmを時刻順に並び替える
    SplayTreeMap<int, MyAlarm> timeValues = SplayTreeMap();
    for (var element in alarms) {
      timeValues[element.hour*60 +element.min] = element;
    }
    alarms.clear();
    alarms.addAll(List.from(timeValues.values));
  }

  void createAlarms( int hour,  //新しいalarmを作成
                     int min,
                     bool isSnooze,
                     String assetAudio){
    MyAlarm customAlarm = MyAlarm(hour, min, isSnooze, assetAudio);
    customAlarm.createAlarm();
    alarms.add(customAlarm);
    sortAlarm();
  }

  MyAlarm getAlarm(int index){ //alarmsのgetter
    return alarms[index];
  }

  void deleteAlarm(int index){ //alarmを削除する
    alarms[index].stopAlarm();
    alarms.removeAt(index);
  }

}
