import 'package:flutter/material.dart';
import 'package:mezamashi/MyAlarm.dart';
import 'AlarmFactory.dart';

class ringScreen extends StatelessWidget {
  //アラームが鳴ったときに表示される画面
  //TODO　スヌーズボタン　解除ボタン（パズル）　現在時刻

  final AlarmFactory af = AlarmFactory();
  final MyAlarm? myAlarm;

  ringScreen([this.myAlarm, Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _ss = MediaQuery.of(context).size;//画面サイズを取得
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: _ss.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    // 外側の余白（マージン）
                    margin: EdgeInsets.all(_ss.height*0.04),
                    child:  Text('${af.alarms[]}:${}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: _ss.height*0.16)),
                  ),
                  //TODO　時刻
                  Container(
                    width: double.infinity,
                    height: _ss.height*0.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(_ss.height*0.3, _ss.height*0.1),
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {}, //TODO
                          child: Text('Stop', style: TextStyle(fontSize: _ss.height*0.05)),
                        ),
                        OutlinedButton(
                          onPressed: () {}, //TODO here
                          style: OutlinedButton.styleFrom(

                            foregroundColor: Colors.green[600],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('snooze'),
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