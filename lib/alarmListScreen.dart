import 'package:flutter/material.dart';

import 'AlarmFactory.dart';
import 'SinpleDialog.dart';

class alarmListScreen extends StatefulWidget{
  //アラームを管理する画面　メイン画面の一つ
  //TODO リストの要素＝＞有効化ボタン、時刻、音源、スヌーズ

  @override
  alarmListScreenState createState() => alarmListScreenState();
}


class alarmListScreenState extends State<alarmListScreen>{

 AlarmFactory af = AlarmFactory();
 bool switchValue = false;


 Future<void> createNewAlarm(BuildContext context) async { //alarmを作成する関数
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

   if (selectedAudio != null) {
     setState(() {
       selectedTime = picked;
       //TODO Datetimeをhour minに変換
       af.createAlarms(hour, min, selectedAudio);
     });
   }
 }

 @override
  Widget build(BuildContext context) {
  return MaterialApp(
    title: 'alarm',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () => {
            //TODO フローティングアクションボタンを押された時の処理.
            createNewAlarm(context)
          },
          child: const Icon(Icons.add)
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text('アラーム一覧', style: TextStyle(fontSize: 20)),
          Container(
            height: 125,
            padding: const EdgeInsets.all(4),
            // 配列を元にリスト表示
            child: ListView.builder(
              itemCount: af.alarms.length,
              itemBuilder: (context, index) {
                return Container(
                  //listの要素コンテナ
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width:3),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    // 横に並べる
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text("${af.alarms[index].hour} : ${af.alarms[index].min}",
                          style: const TextStyle(fontSize: 15)),
                      Transform.scale(
                          scale:2.0,
                          child: Switch(
                            value: switchValue,
                            activeTrackColor: Colors.green[600],
                            inactiveThumbColor: Colors.green[200],
                            onChanged: (value){},
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