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
   MyAlarm? ma;
   TimeOfDay selectedTime = TimeOfDay.now();
   final TimeOfDay? picked = await showTimePicker(//time picker
     context: context,
     initialTime: selectedTime,
     initialEntryMode: TimePickerEntryMode.input,
     helpText: "アラームを設定したい時刻を入力してください"
   );

   if (picked == null) return;
   if (!mounted) return;

   final String? selectedAudio = await showDialog<String>(
       context: context,
       builder: (_) {
         return const SimpleDialogSample();
       });


   setState(() {
      selectedTime = picked;
      ma = af.createAlarms(selectedTime.hour, selectedTime.minute, selectedAudio ?? "デフォルト音源");//TODO selectedAudioのデフォルトを設定
      af.setPreference();
    });

   Alarm.ringStream.stream.listen(
         (alarmSettings) => Navigator.push(
       context,
       MaterialPageRoute(builder: (context) => ringScreen(ma)),
     ),
   );

 }

 @override
  Widget build(BuildContext context) {
   var _ss = MediaQuery.of(context).size;
  return MaterialApp(
    title: 'alarm',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () => {
            createNewAlarm(context)
          },
          child: const Icon(Icons.add)
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text('アラーム一覧', style: TextStyle(fontSize: _ss.height*0.04)),
          Container(
            height: _ss.height,
            padding: const EdgeInsets.all(4),
            // 配列を元にリスト表示
            child: ListView.builder(
              itemCount: af.alarms.length,
              itemBuilder: (context, index) {
                return Container(
                  //listの要素コンテナ
                  height: _ss.height*0.08,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width:_ss.height*0.004),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    // 横に並べる
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text("${af.alarms[index].hour} : ${af.alarms[index].min}",
                          style: TextStyle(fontSize: _ss.height*0.03)),
                      Transform.scale(
                          scale:2.0,
                          child: Switch(
                            value: switchValue,
                            activeTrackColor: Colors.green[600],
                            inactiveThumbColor: Colors.green[200],
                            onChanged: (value){setState(() {
                              switchValue = value;
                              if(switchValue){
                                af.alarms[index].createAlarm();
                                //TODO here
                              }else{
                                af.alarms[index].stopAlarm();
                              }
                            });},
                          )
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