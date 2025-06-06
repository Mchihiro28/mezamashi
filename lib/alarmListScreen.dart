import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/service/storage.dart';
import 'package:flutter/material.dart';
import 'package:mezamashi/DatabaseHelper.dart';
import 'package:mezamashi/ringScreen.dart';
import 'package:permission_handler/permission_handler.dart';

import 'AdInterstitial.dart';
import 'AlarmFactory.dart';
import 'ManagePoint.dart';
import 'SimpleDialog.dart';

///アラームを管理する画面
///
///メイン画面の一つで、Stateを維持したまま画面を切り替えることができる。
class alarmListScreen extends StatefulWidget{
  const alarmListScreen({super.key});

  @override
  alarmListScreenState createState() => alarmListScreenState();
}


class alarmListScreenState extends State<alarmListScreen> with AutomaticKeepAliveClientMixin<alarmListScreen>{

  static final alarmListScreenState _instance = alarmListScreenState._internal();
  factory alarmListScreenState() {
    return _instance;
  }
  alarmListScreenState._internal();

  // AlarmFactoryのインスタンスを取得
  AlarmFactory af = AlarmFactory.getInstance();
  InterstitialAdManager interstitialAdManager = InterstitialAdManager();

  // ManagePointを遅延初期化
  late final ManagePoint mp;

  bool switchValue = false;
  bool isInitStream = false;
  late List<AlarmSettings> alarms;

  // alarmが鳴ったことを感知するstream
  StreamSubscription<AlarmSettings>? subscription;


 @override
 initState(){
   super.initState();
   // 画面の更新を行い、アラームとポイントを読み込む
   _reBuild();
   AlarmStorage.init();
   interstitialAdManager.interstitialAd();
   if (Alarm.android) {
     checkAndroidNotificationPermission();
   }
   // アプリの起動時に一回だけ呼ぶ
   setStream();
 }

 @override // Stateの保持
 bool get wantKeepAlive => true;

 /// アラームが鳴ったのを感知するStreamをセットする関数
 ///
 /// 起動時に一度だけ呼ばれる。
 void setStream(){
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

 // ringScreenへと遷移させる（ringScreenが上に重なる状態）
 Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
   await Navigator.push(
       context,
       MaterialPageRoute(
         builder: (context) =>
             ringScreen(alarmSettings: alarmSettings),
       ));

 }

 /// ボタンを押した際にalarmを作成する関数
 ///
 /// タイムピッカーを使用し、デフォルトの時間として現在時刻が入力された状態である。
 Future<void> createNewAlarm(BuildContext context) async {
   TimeOfDay selectedTime = TimeOfDay.now();
   final TimeOfDay? picked = await showTimePicker(//time picker
     context: context,
     initialTime: selectedTime,
     initialEntryMode: TimePickerEntryMode.dial,
     helpText: "アラームを設定したい時刻を入力してください"
   );

   if (picked == null) return;
   if (!mounted) return;

   // ダイアログを表示して音源の選択
   final int? selectedAudio = await showDialog<int>(
       context: context,
       builder: (_) {
         return const SimpleDialogSample();
       });


   // 画面の更新とアラームの登録、インタースティシャル広告の表示
   setState(() {
      selectedTime = picked;
      af.createAlarms(selectedTime.hour, selectedTime.minute, selectedAudio ?? 1);
      interstitialAdManager.showInterstitialAd();
    });
 }

 /// 通知を表示する権限の有無をチェックする。
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

 /// アプリ外の共有ストレージを使用する権限の有無をチェックする。
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

 /// 画面の更新をする関数
 ///
 /// アラームの更新、ポイントの更新を行う。
 Future<void> _reBuild() async{
   await DatabaseHelper.getAlarmDB(af);
   mp = await ManagePoint.getInstance();
   mp.addPoint(ManagePoint.loginPoint); //ログインボーナス
   // 画面の再描画
   setState((){ });
 }



 @override
  Widget build(BuildContext context) {
    super.build(context);

    // 画面サイズを取得
    var ss = MediaQuery.of(context).size;
  return MaterialApp(
    title: 'alarm',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.blue),
    home: Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton( //アラーム作成ボタン
          onPressed: () => {
            createNewAlarm(context)
          },
          child: const Icon(Icons.add_alarm)
      ),
      body: Container( // アラームを並べて表示するコンテナ
            constraints: const BoxConstraints.expand(),
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
      ),
    );
 }

}