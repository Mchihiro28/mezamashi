import 'dart:collection';
import 'DatabaseHelper.dart';
import 'MyAlarm.dart';

class AlarmFactory{
  //MyAlarmクラスのインスタンスを生成、管理するクラス
  List<MyAlarm> alarms = []; //作ったアラームのインスタンスを格納するリスト

  AlarmFactory();


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
                     int audioNum){
    MyAlarm customAlarm = MyAlarm(-1,hour, min, audioNum, 0);
    customAlarm.createAlarm();
    alarms.add(customAlarm);
    DatabaseHelper.setAlarmDB(this);
    sortAlarm();
    return customAlarm;
  }

  void deleteAlarm(int index){ //alarmを削除する
    if(alarms.isNotEmpty) {
      alarms[index].stopAlarm();
      alarms.removeAt(index);
      DatabaseHelper.delete(DatabaseHelper.alarmTable, alarms[index].id!);
    }
  }

  void changeValidity(int index, int validity){ //アラームの有効性を変化させて、dbをupdateする関数
    alarms[index].isValid = validity;

    DatabaseHelper.update(DatabaseHelper.alarmTable,
        {
          DatabaseHelper.columnAId : alarms[index].id,
          DatabaseHelper.columnHour  : alarms[index].hour,
          DatabaseHelper.columnMin  : alarms[index].min,
          DatabaseHelper.columnAudioNum  : alarms[index].audioNum,
          DatabaseHelper.columnValid  : validity,
        }
    );
  }



}
