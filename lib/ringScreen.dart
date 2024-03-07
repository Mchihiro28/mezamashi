import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mezamashi/ManagePoint.dart';
import 'AlarmFactory.dart';
import 'package:volume_controller/volume_controller.dart';

import 'DatabaseHelper.dart';

class ringScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;
  const ringScreen({required this.alarmSettings, super.key});
  @override
  ringScreenState createState() => ringScreenState();
}

class ringScreenState extends State<ringScreen>{
  //アラームが鳴ったときに表示される画面
  //TODO　解除ボタン（パズル）

  late final ManagePoint mp;
  double orgVolume = 0; //音量を変える前の大きさ

  @override
  void initState() {
    super.initState();
    _getVolume();
    _reBuild();
    _delay();
  }

  @override
  void dispose() {
    VolumeController().setVolume(orgVolume);
    super.dispose();
  }

  Future<void> _reBuild() async{
    mp = await ManagePoint.getInstance();
    setState((){ });
  }

  Future<void> _getVolume() async {
    orgVolume = await VolumeController().getVolume();
    VolumeController().setVolume(1.0); //FIXME 音量の調節
  }

  Future<void> _delay() async { //30分後に止める
    await Future.delayed(const Duration(seconds: 1800));
    Alarm.stop(widget.alarmSettings.id).then((_) => Navigator.pop(context));
  }

  void onAlarmStop(){ //アラームを止める際に呼ぶ関数
    int diff = DateTime.now().difference(widget.alarmSettings.dateTime).inSeconds;
    diff -= 15; //アラームを止めるまでの猶予秒数
    if(diff < 0){
      mp.addPoint(diff * -10);
    }else{
      mp.addPoint(-10);
    }

    Alarm.stop(widget.alarmSettings.id).then((_){
      if (Navigator.canPop(context)) {
        Navigator.pop(context); // 戻るを選択した場合のみpopを明示的に呼ぶ
      } else {
        SystemNavigator.pop(); // アプリを閉じる
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    var ss = MediaQuery.of(context).size;//画面サイズを取得
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async{
        if (didPop) {
          return;
        }
        onAlarmStop();
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
                  child:  Text('${widget.alarmSettings.dateTime.hour.toString().padLeft(2, '0')}:${widget.alarmSettings.dateTime.minute.toString().padLeft(2, '0')}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: ss.height*0.12)),
                ),
                Container(
                  width: double.infinity,
                  height: ss.height*0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(ss.height*0.3, ss.height*0.1),
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {//stop
                          onAlarmStop();
                        },
                        child: Text('Stop', style: TextStyle(fontSize: ss.height*0.05)),
                      ),
                      OutlinedButton(
                        onPressed: () {//snooze
                          final now = DateTime.now();
                          mp.addPoint(-30); //ポイント変動：スヌーズするたびに-30pt
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
                              ).add(const Duration(minutes: 1)),//FIXME スヌーズを何分後にならすか
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
