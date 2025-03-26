import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mezamashi/AlarmFactory.dart';
import 'package:mezamashi/ManagePoint.dart';
import 'package:volume_controller/volume_controller.dart';

/// アラームが鳴ったときに表示される画面
///
/// alarmListScreenからアラームの情報を引き継ぐ。
class ringScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;
  const ringScreen({required this.alarmSettings, super.key});
  @override
  ringScreenState createState() => ringScreenState();
}

class ringScreenState extends State<ringScreen>{

  // ManagePointを遅延初期化
  late final ManagePoint mp;
  // AlarmFactoryのインスタンスを取得
  final AlarmFactory af = AlarmFactory.getInstance();
  /// 音量を変える前の音の大きさ
  double orgVolume = 0;

  @override
  void initState() {
    super.initState();
    // 音量をMAXに
    _getVolume();
    // 画面を更新
    _reBuild();
    // 30分のタイマーをセット
    _delay();
  }

  @override
  void dispose() {
    VolumeController().setVolume(orgVolume);
    super.dispose();
  }

  /// ポイントを取得して画面を更新する。
  Future<void> _reBuild() async{
    mp = await ManagePoint.getInstance();
    setState((){ });
  }

  /// 音量をMAXにする関数
  ///
  /// 音量を変える前に元の音量を取得する。
  Future<void> _getVolume() async {
    orgVolume = await VolumeController().getVolume();
    VolumeController().setVolume(1);
  }

  /// 30分後にアラームを止めるタイマーを開始する。
  ///
  /// ずっと操作されなかった場合に自動で止まるようにするため。
  Future<void> _delay() async {
    await Future.delayed(const Duration(seconds: 1800));
    Alarm.stop(widget.alarmSettings.id).then((_) => Navigator.pop(context));
  }

  ///アラームを止める際に呼び出される関数
  void _onAlarmStop(){
    int diff = DateTime.now().difference(widget.alarmSettings.dateTime).inSeconds;
    diff -= ManagePoint.postponement; //アラームを止めるまでの猶予秒数
    if(diff < 0){ // diffが負なら成功
      // 猶予秒数より早く止められただけポイントを加算
      mp.addPoint(diff * ManagePoint.punishAndPrize);
    }else{
      // 遅れた時間にかかわらずポイントを減算
      mp.addPoint(ManagePoint.punishAndPrize);
    }

    Alarm.stop(widget.alarmSettings.id).then((_){
      af.resetAllAlarm();
      if (Navigator.canPop(context)) {
        Navigator.pop(context); //alarmListScreenに戻る
      } else {
        SystemNavigator.pop(); // アプリを閉じる
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    var ss = MediaQuery.of(context).size; // 画面サイズを取得
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async{
        if (didPop) {
          return;
        }
        // 戻るを選択した場合のみpopを明示的に呼ぶ
        _onAlarmStop();
      },
      child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: ss.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  // 外側の余白（マージン）
                  margin: EdgeInsets.all(ss.height*0.04),
                  // 時刻テキスト
                  child:  Text('${widget.alarmSettings.dateTime.hour.toString().padLeft(2, '0')}:${widget.alarmSettings.dateTime.minute.toString().padLeft(2, '0')}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: ss.height*0.12)),
                ),
                Container(
                  width: double.infinity,
                  height: ss.height*0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton( // アラーム停止ボタン
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(ss.height*0.3, ss.height*0.1),
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {//stop
                          _onAlarmStop();
                        },
                        child: Text('Stop', style: TextStyle(fontSize: ss.height*0.05)),
                      ),
                      OutlinedButton(
                        onPressed: () {//snooze
                          final now = DateTime.now();
                          mp.addPoint(ManagePoint.snoozePoint); //ポイント変動：スヌーズするたび
                          af.resetAllAlarm();
                          Alarm.set(
                            alarmSettings: widget.alarmSettings.copyWith(
                              dateTime: DateTime(
                                now.year,
                                now.month,
                                now.day,
                                now.hour,
                                now.minute,
                                0,
                                0,
                              ).add(const Duration(minutes: 10)),
                            ),
                          ).then((_) => Navigator.pop(context));
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green[600],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('スヌーズ'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),);
  }
}
