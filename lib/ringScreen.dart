import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:mezamashi/MyAlarm.dart';
import 'package:mezamashi/alarmListScreen.dart';
import 'AlarmFactory.dart';

class ringScreen extends StatelessWidget {
  //アラームが鳴ったときに表示される画面
  //TODO　スヌーズボタン　解除ボタン（パズル）　現在時刻

  final AlarmFactory af = AlarmFactory();
  final MyAlarm myAlarm;

  ringScreen({required this.myAlarm, super.key});

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
                    child:  Text('${myAlarm.hour}:${myAlarm.min}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: ss.height*0.16)),
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
                            myAlarm.stopAlarm();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const alarmListScreen()),
                            );
                          },
                          child: Text('Stop', style: TextStyle(fontSize: ss.height*0.05)),
                        ),
                        OutlinedButton(
                          onPressed: () {//snooze
                            myAlarm.stopAlarm();
                            myAlarm.snooze(1); //FIXME スヌーズを何分後にならすか
                            Alarm.ringStream.stream.listen(
                                  (alarmSettings) => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ringScreen(myAlarm: myAlarm)),
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const alarmListScreen()),
                            );
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