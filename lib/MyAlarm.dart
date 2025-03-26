import 'package:alarm/alarm.dart';
import 'dart:math' as math;

///Alarm機能を実現するクラス。
///
///AlarmControllerによってインスタンスが生成される。
class MyAlarm{

  /// alarmごとに固有のid
  int? id;
  /// 鳴る時間
  int hour = 12;
  /// 鳴る分
  int min = 0;
  /// 音源へのパス
  String assetAudio = "assets/sounds/1_default.mp3";
  /// 音源名
  String audioName ="アラーム1";
  /// 音量をフェードする時間（フェードなし）
  double fadeDuration = 0;
  /// アラーム音の番号
  int audioNum = 0;
  /// アラームの有効性<br>1(false)or0(true)
  int isValid = 0;

  /// constructor
  ///
  /// idを1にすると新規作成になる。
  MyAlarm(int id,
          this.hour,
          this.min,
          this.audioNum,
          this.isValid,){
    if(id < 1){ // idが-1なら新規に発行
      // TODO: タイムスタンプにすれば確実にidがかぶらない
      var random = math.Random();
      this.id = random.nextInt(2100000000);
    }else{ // そうでないならすでにあるものを適用
      this.id = id;
    }

    switch(audioNum) {
      case 1:
        assetAudio = 'assets/sounds/1_default.mp3';
        audioName = "シンプル";
        break;
      case 2:
        assetAudio = 'assets/sounds/2_slow.mp3';
        audioName = "スロー";
        break;
      case 3:
        assetAudio = 'assets/sounds/3_classic.mp3';
        audioName = "クラシック";
        break;
      default:
        audioName = "シンプル";
        assetAudio = 'assets/sounds/1_default.mp3';
        break;
    }

  }


  /// アラームを作成するために時刻に日付の情報を追加
  ///
  /// 現在時刻よりも前の時刻が与えられた場合、２４時間遅らせる。
  DateTime formatDateTime(int h, int m){
    DateTime now = DateTime.now();
    DateTime res = DateTime(now.year, now.month, now.day, h, m);
    if(res.isBefore(now)){
      res = res.add(const Duration(days:1));
    }
    return res;
  }

  /// アラームを作成してセットする。
  void createAlarm(){
    final alarmSettings = AlarmSettings(
      id: id!,
      dateTime: formatDateTime(hour, min),
      assetAudioPath: assetAudio,
      loopAudio: true,
      vibrate: true,
      fadeDuration: fadeDuration,
      notificationTitle: 'アラーム', // アラームが鳴った際の通知のタイトル
      notificationBody: 'アラームが鳴りました！　起きてください！', // アラームが鳴った際の通知の本文
      enableNotificationOnKill: true, // アプリを終了しようとするとユーザに通知を送る
    );
    Alarm.set(alarmSettings: alarmSettings);
  }

  /// スヌーズ機能を提供する。
  ///
  /// いったんアラームを止め、[snoozeValue]分後にもう一度アラームを鳴らす
  void snooze(int snoozeValue){
    int thisHour = hour;
    int thisMin = min;
    stopAlarm();
    int nextTime = hour*60 + min + snoozeValue;
    hour = nextTime~/60;
    min = nextTime % 60;
    createAlarm();
    hour = thisHour;
    min = thisMin;
  }

  /// alarmを停止する。
  void stopAlarm(){
    Alarm.stop(id!);
  }

}
