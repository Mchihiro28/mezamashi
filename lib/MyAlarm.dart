import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:mezamashi/ringScreen.dart';

class MyAlarm{
  //Alarm機能を実現するクラス。AlarmControllerによってインスタンスが生成される
  int id = 0; //alarmごとに固有のid
  int hour = 12;//鳴る時間
  int min = 0;//鳴る分
  String assetAudio = "";//音源へのパス
  double fadeDuration = 0;//音量をフェードする時間

  MyAlarm(id, //constructor
          this.hour,
          this.min,
          this.assetAudio){
    if(id == -1){ //idが-1なら新規に発行
      var random = math.Random();
      id = random.nextInt(100000000);
    }else{//そうでないならすでにあるものを適用
      id = this.id;
    }

  }


  DateTime formatDateTime(int h, int m){
    DateTime now = DateTime.now();
    DateTime res = DateTime(now.year, now.month, now.day, h, m);
    if(res.isBefore(now)){
      res.add(const Duration(days:1));
    }
    return res;
  }

  void createAlarm(){//アラームを作成する
    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: formatDateTime(hour, min),
      assetAudioPath: assetAudio,
      loopAudio: true,
      vibrate: true,
      fadeDuration: fadeDuration,
      notificationTitle: 'アラーム',
      notificationBody: 'アラームが鳴りました！　起きてください！',
      enableNotificationOnKill: true,
    );
    Alarm.set(alarmSettings: alarmSettings);
  }

  void snooze(){  //10分後にもう一度アラームを鳴らす
    int thisHour = hour;
    int thisMin = min;
    stopAlarm();
    int nextTime = hour*60 + min + 10;
    hour = (nextTime/60) as int;
    min = nextTime % 60;
    createAlarm();
    hour = thisHour;
    min = thisMin;
  }

  void stopAlarm(){ //alarmを停止＆削除する
    Alarm.stop(id);
  }

  String exportSettings(){ //sharedprefarence用にlistでエクスポート
    List<String> res = List<String>.empty();
    res.add(id.toString());
    res.add(hour.toString());
    res.add(min.toString());
    res.add(assetAudio.toString());
    return res.toString();
  }
}
