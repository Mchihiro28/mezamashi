import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:mezamashi/MyAlarm.dart';
import 'package:mezamashi/ringScreen.dart';

import 'AlarmFactory.dart';
import 'SimpleDialog.dart';

class alarmListScreen extends StatefulWidget{
  //アラームを管理する画面　メイン画面の一つ
  const alarmListScreen({super.key});

  @override
  alarmListScreenState createState() => alarmListScreenState();
}


class alarmListScreenState extends State<alarmListScreen>{

 AlarmFactory af = AlarmFactory();
 bool switchValue = false;


 Future<void> createNewAlarm(BuildContext context) async { //alarmを作成する関数
   TimeOfDay selectedTime = TimeOfDay.now();
   MyAlarm ma = MyAlarm(-1, selectedTime.hour, selectedTime.minute, 1);
   final TimeOfDay? picked = await showTimePicker(//time picker
     context: context,
     initialTime: selectedTime,
     initialEntryMode: TimePickerEntryMode.dial,
     helpText: "アラームを設定したい時刻を入力してください"
   );

   if (picked == null) return;
   if (!mounted) return;

   final int? selectedAudio = await showDialog<int>(
       context: context,
       builder: (_) {
         return SimpleDialogSample();
       });


   setState(() {
      selectedTime = picked;
      ma = af.createAlarms(selectedTime.hour, selectedTime.minute, selectedAudio ?? 1);
      af.setPreference();

      Alarm.ringStream.stream.listen(
            (alarmSettings) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ringScreen(myAlarm: ma)),
        ),
      );
    });
 }

 @override
  Widget build(BuildContext context) {
   var ss = MediaQuery.of(context).size;
  return MaterialApp(
    title: 'alarm',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () => {
            createNewAlarm(context)
          },
          child: const Icon(Icons.add_alarm)
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox.square(dimension: ss.height*0.06,),
          Text('アラーム一覧', style: TextStyle(fontSize: ss.height*0.025)),
          Container(
            height: ss.height*0.8,
            padding: const EdgeInsets.all(4),
            // 配列を元にリスト表示
            child: ListView.builder(
              itemCount: af.alarms.length,
              itemBuilder: (context, index) {
                return Container(
                  //listの要素コンテナ
                  height: ss.height*0.08,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width:ss.height*0.004),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    // 横に並べる
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text("${af.alarms[index].hour} : ${af.alarms[index].min}",  //時刻
                          style: TextStyle(fontSize: ss.height*0.03)),
                      Transform.scale(
                          scale:1.0,
                          child: Switch(  //有効化スイッチ
                            value: switchValue,
                            activeTrackColor: Colors.green[600],
                            inactiveThumbColor: Colors.green[200],
                            onChanged: (value){setState(() {
                              switchValue = value;
                              if(switchValue){
                                af.alarms[index].createAlarm();
                                Alarm.ringStream.stream.listen(
                                      (alarmSettings) => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ringScreen(myAlarm : af.alarms[index])),
                                  ),
                                );
                              }else{
                                af.alarms[index].stopAlarm();
                              }
                            });},
                          )
                      ),
                      Text(af.alarms[index].audioName,style: TextStyle(fontSize: ss.height*0.02)),  //音源
                      IconButton( //削除ボタン
                        icon: const Icon(Icons.delete),
                        iconSize: ss.height*0.02,
                        color: Colors.grey,
                        tooltip: '削除ボタン',
                        onPressed: () {
                          setState(() {
                            af.deleteAlarm(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
 }

}