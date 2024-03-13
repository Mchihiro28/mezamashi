import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/service/storage.dart';
import 'package:flutter/material.dart';
import 'package:mezamashi/DatabaseHelper.dart';
import 'package:mezamashi/ringScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'AlarmFactory.dart';
import 'ManagePoint.dart';
import 'SimpleDialog.dart';

class alarmListScreen extends StatefulWidget{
  //アラームを管理する画面　メイン画面の一つ
  const alarmListScreen({super.key});

  @override
  alarmListScreenState createState() => alarmListScreenState();
}


class alarmListScreenState extends State<alarmListScreen> with AutomaticKeepAliveClientMixin<alarmListScreen>{

 AlarmFactory af = AlarmFactory();
 late final ManagePoint mp;
 bool switchValue = false;
 bool isInitStream = false;
 late List<AlarmSettings> alarms;
 StreamSubscription<AlarmSettings>? subscription; //alarmが鳴ったことをlistenするstream

 @override
 initState(){
   super.initState();
   _reBuild();
   AlarmStorage.init();
   if (Alarm.android) {
     checkAndroidNotificationPermission();
   }
   setStream(); //アプリの起動時に一回だけ呼ぶ
 }

 @override //stateの保持
 bool get wantKeepAlive => true;

 void setStream(){ //streamをセットする関数
   interrupt();
   if(isInitStream == false) {
     subscription ??= Alarm.ringStream.stream.listen(
           (alarmSettings) => navigateToRingScreen(alarmSettings),
     );
     isInitStream = true;
   }
 }


 @override
 void dispose() { //lifecycle
   subscription?.cancel();
   isInitStream = false;
   super.dispose();
 }

 Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
   await Navigator.push(
       context,
       MaterialPageRoute(
         builder: (context) =>
             ringScreen(alarmSettings: alarmSettings),
       ));

 }

 Future<void> createNewAlarm(BuildContext context) async { //alarmを作成する関数
   TimeOfDay selectedTime = TimeOfDay.now();
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
         return const SimpleDialogSample();
       });


   setState(() {
      selectedTime = picked;
      af.createAlarms(selectedTime.hour, selectedTime.minute, selectedAudio ?? 1);
    });
 }

 Future<void> checkAndroidNotificationPermission() async {
   final status = await Permission.notification.status;
   if (status.isDenied) {
     alarmPrint('Requesting notification permission...');
     final res = await Permission.notification.request();
     alarmPrint(
       'Notification permission ${res.isGranted ? '' : 'not'} granted.',
     );
   }
 }

 Future<void> checkAndroidExternalStoragePermission() async {
   final status = await Permission.storage.status;
   if (status.isDenied) {
     alarmPrint('Requesting external storage permission...');
     final res = await Permission.storage.request();
     alarmPrint(
       'External storage permission ${res.isGranted ? '' : 'not'} granted.',
     );
   }
 }

 Future<void> _reBuild() async{
   await DatabaseHelper.getAlarmDB(af);
   mp = await ManagePoint.getInstance();
   mp.addPoint(1); //ログインボーナス1pt
   setState((){ });
 }

 void interrupt(){ //開発者用に処理を実行する関数

 }



 @override
  Widget build(BuildContext context) {
    super.build(context);
   var ss = MediaQuery.of(context).size;
  return MaterialApp(
    title: 'alarm',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: Scaffold(
      resizeToAvoidBottomInset: false,
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
          Container(
            height: ss.height*0.8,
            padding: const EdgeInsets.all(4),
            // 配列を元にリスト表示
            child: ListView.builder(
              itemCount: af.alarms.length,
              itemBuilder: (context, index) {
                if(af.alarms[index].isValid == 1){
                  switchValue = false;
                }else{
                  switchValue = true;
                }
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
                      Text("${af.alarms[index].hour.toString().padLeft(2, '0')} : ${af.alarms[index].min.toString().padLeft(2, '0')}",  //時刻
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
                                af.changeValidity(index, 0);
                                af.alarms[index].createAlarm();
                              }else{
                                af.changeValidity(index, 1);
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