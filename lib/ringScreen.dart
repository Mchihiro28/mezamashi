import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'AlarmFactory.dart';
import 'package:volume_controller/volume_controller.dart';

class ringScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;
  const ringScreen({required this.alarmSettings, super.key});
  @override
  ringScreenState createState() => ringScreenState();
}

class ringScreenState extends State<ringScreen>{
  //アラームが鳴ったときに表示される画面
  //TODO　解除ボタン（パズル）

  final AlarmFactory af = AlarmFactory();
  double orgVolume = 0; //音量を変える前の大きさ

  @override
  void initState() {
    super.initState();
    myGetVolume();
  }

  @override
  void dispose() {
    VolumeController().setVolume(orgVolume);
    super.dispose();
  }

  Future<void> myGetVolume() async {
    orgVolume = await VolumeController().getVolume();
    VolumeController().setVolume(0.5); //FIXME 音量の調節
  }


  @override
  Widget build(BuildContext context) {
    var ss = MediaQuery.of(context).size;//画面サイズを取得
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
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
                            Alarm.stop(widget.alarmSettings.id).then((_) => Navigator.pop(context));
                          },
                          child: Text('Stop', style: TextStyle(fontSize: ss.height*0.05)),
                        ),
                        OutlinedButton(
                          onPressed: () {//snooze
                            final now = DateTime.now();
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
      ),
    );
  }
}
