import 'package:flutter/material.dart';
import 'package:mezamashi/AlarmFactory.dart';
import 'package:mezamashi/PlantScreen.dart';
import 'package:mezamashi/alarmListScreen.dart';
import 'package:mezamashi/sharedPref.dart';

class SettingScreen extends StatefulWidget{
  //設定画面　メイン画面の一つ
  const SettingScreen({super.key});

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> with AutomaticKeepAliveClientMixin<SettingScreen>{

  @override //stateの保持
  bool get wantKeepAlive => true;

  AlarmFactory af = AlarmFactory.getInstance();
  bool switchValue = false;

  @override
  initState(){
    super.initState();
    _init();
  }

  Future<void> _init()async{
    var data = await sharedPref.load("weatherSetting");
    data ??= ["false"];
    switchValue = bool.parse(data.first);
    setState((){ });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var ss = MediaQuery.of(context).size;
    return MaterialApp(
        title: 'setting',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
    home: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: ss.height*0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const Text('位置情報の使用を許可',
                      style:TextStyle(fontSize: 18)),
                  SizedBox(width: ss.width*0.02),
                  const Text('天気の取得に位置情報を使用します',
                      style:TextStyle(fontSize: 12)),
                  SizedBox(width: ss.width*0.1),
                  Switch(
                    value: switchValue,
                    activeTrackColor: Colors.green[600],
                    inactiveThumbColor: Colors.green[200],
                    onChanged: (value){setState(() {
                      switchValue = value;
                      PlantScreenState().reBuildWeather();
                      if(switchValue){
                        sharedPref.save("weatherSetting", ["true"]);
                      }else{
                        sharedPref.save("weatherSetting", ["false"]);
                      }
                    });},
                  ),
                  SizedBox(width: ss.width*0.1),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: ss.height*0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const Text('全てのアラームを削除',
                      style:TextStyle(fontSize: 18)),
                  SizedBox(width: ss.width*0.02),
                  const Text('不具合が起こった際にご使用ください。',
                      style:TextStyle(fontSize: 12)),
                  SizedBox(width: ss.width*0.05),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                      side: const BorderSide(color: Colors.green),
                    ),
                    onPressed: () {
                      af.deleteAllAlarm();
                      alarmListScreenState().setState(() { });
                    },
                    child: const Text('削除', style: TextStyle(color: Colors.black)),
                  ),
                  SizedBox(width: ss.width*0.1),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: ss.height*0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const Text('プライバシーポリシー',
                      style:TextStyle(fontSize: 18)),
                  SizedBox(width: ss.width*0.39),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                      side: const BorderSide(color: Colors.green),
                    ),
                    onPressed: () {
                      _myDialog();
                    },
                    child: const Text('表示', style: TextStyle(color: Colors.black)),
                  ),
                  SizedBox(width: ss.width*0.1),
                ],
              ),
            ),
          ],
        ),
      ),
    )
    );
  }

  void _myDialog() { //プライバシーポリシーを表示するalertdialog

    const String PRIVACY_POLICY = '''
    something content
    something content
      ''';

    showDialog(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AlertDialog(
        title: const Text("プライバシーポリシー"),
        content: const Text(PRIVACY_POLICY),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("閉じる"),
          )
        ],
      ),
      ),
    );
  }

}