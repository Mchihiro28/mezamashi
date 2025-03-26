import 'dart:collection';
import 'DatabaseHelper.dart';
import 'MyAlarm.dart';

  ///MyAlarmクラスのインスタンスを生成、管理するクラス
class AlarmFactory{

  ///作ったアラームのインスタンスを格納するリスト
  List<MyAlarm> alarms = [];

  /// インスタンスはシングルトンにする。
  static AlarmFactory instance = AlarmFactory();
  static AlarmFactory getInstance() => instance;

  ///alarmを時刻順に並び替える。
  void sortAlarm(){
    SplayTreeMap<int, MyAlarm> timeValues = SplayTreeMap();
    for (var element in alarms) {
      timeValues[element.hour*60 +element.min] = element;
    }
    alarms.clear();
    alarms.addAll(List.from(timeValues.values));
  }

  /// アラームを新規発行しデータベースに登録する。
  ///
  /// アラームは有効な状態で作成される。
  /// 時間[hour]、分[min]、音源番号[audioNum]を指定する。
  MyAlarm createAlarms( int hour,
                     int min,
                     int audioNum){

    MyAlarm customAlarm = MyAlarm(-1,hour, min, audioNum, 0);
    customAlarm.createAlarm();
    alarms.add(customAlarm);
    DatabaseHelper.setAlarmDB(this);
    sortAlarm();
    return customAlarm;
  }

  /// [index]番目のalarmを削除する。
  void deleteAlarm(int index){
    if(alarms.isNotEmpty) {
      // データベースから削除
      DatabaseHelper.delete(DatabaseHelper.alarmTable, alarms[index].id!);
      // アラームが鳴らないよう止める
      alarms[index].stopAlarm();
      // アラームを削除
      alarms.removeAt(index);
    }
  }

  /// すべてのアラームを削除する。
  void deleteAllAlarm(){
    for(var e in alarms){
      DatabaseHelper.delete(DatabaseHelper.alarmTable, e.id!);
      e.stopAlarm();
    }
    alarms.clear();
  }

  /// alarmの有効性を変化させる。
  ///
  /// [index]番目のアラームの有効性を[validity]に変化させて、その後データベースをupdateする。
  void changeValidity(int index, int validity){
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

  ///全てのアラームを解除した後、再セットする。
  void resetAllAlarm(){
    for(var e in alarms){
      if(e.isValid == 0){
        e.stopAlarm();
        e.createAlarm();
      }
    }
  }

}
