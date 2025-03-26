import 'package:flutter/material.dart';
import 'package:mezamashi/AlarmFactory.dart';
import 'package:mezamashi/PlantScreen.dart';
import 'package:mezamashi/alarmListScreen.dart';
import 'package:mezamashi/sharedPref.dart';

///設定画面　
///
///メイン画面の一つ
///設定項目は以下の通り。
/// - 天気を取得するか（トグルスイッチ）
/// - すべてのalarmを削除する（ボタン）
/// - プライバシーポリシーの表示（ボタン）
class SettingScreen extends StatefulWidget{

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

  /// 画面の初期化を行う。
  ///
  /// 天気の取得可否を読み込む。
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                        sharedPref.save("weatherSetting", ["false"]);
                      }else{
                        sharedPref.save("weatherSetting", ["true"]);
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('プライバシーポリシー',
                      style:TextStyle(fontSize: 18)),
                  SizedBox(width: ss.width*0.2),
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

  /// プライバシーポリシーを表示する。
  ///
  /// alertDialogでプライバシーポリシーを表示する。
  void _myDialog() { //プライバシーポリシーを表示するalertdialog

    const String PRIVACY_POLICY = '''
    ・Privacy Policy
This privacy policy applies to the Good Morninglory! ～ちゃんと起きれば朝顔が咲くアラームアプリ～ app (hereby referred to as "Application") for mobile devices that was created by CMatsunaga (hereby referred to as "Service Provider") as an Ad Supported service. This service is intended for use "AS IS".


・Information Collection and Use
The Application collects information when you download and use it. This information may include information such as

  ・Your device's Internet Protocol address (e.g. IP address)
  ・The pages of the Application that you visit, the time and date of your visit, the time   spent on those pages
  ・The time spent on the Application
  ・The operating system you use on your mobile device

The Application collects your device's location, which helps the Service Provider determine your approximate geographical location and make use of in below ways:

  ・Geolocation Services: The Service Provider utilizes location data to provide features such as personalized content, relevant recommendations, and location-based services.
  ・Analytics and Improvements: Aggregated and anonymized location data helps the Service Provider to analyze user behavior, identify trends, and improve the overall performance and functionality of the Application.
  ・Third-Party Services: Periodically, the Service Provider may transmit anonymized location data to external services. These services assist them in enhancing the Application and optimizing their offerings.

The Service Provider may use the information you provided to contact you from time to time to provide you with important information, required notices and marketing promotions.


For a better experience, while using the Application, the Service Provider may require you to provide us with certain personally identifiable information. The information that the Service Provider request will be retained by them and used as described in this privacy policy.


・Third Party Access
Only aggregated, anonymized data is periodically transmitted to external services to aid the Service Provider in improving the Application and their service. The Service Provider may share your information with third parties in the ways that are described in this privacy statement.


Please note that the Application utilizes third-party services that have their own Privacy Policy about handling data. Below are the links to the Privacy Policy of the third-party service providers used by the Application:

  ・Google Play Services　　https://www.google.com/policies/privacy/
  ・AdMob　　https://support.google.com/admob/answer/6128543?hl=en

The Service Provider may disclose User Provided and Automatically Collected Information:

  ・as required by law, such as to comply with a subpoena, or similar legal process;
  ・when they believe in good faith that disclosure is necessary to protect their rights, protect your safety or the safety of others, investigate fraud, or respond to a government request;
  ・with their trusted services providers who work on their behalf, do not have an independent use of the information we disclose to them, and have agreed to adhere to the rules set forth in this privacy statement.

・Opt-Out Rights
You can stop all collection of information by the Application easily by uninstalling it. You may use the standard uninstall processes as may be available as part of your mobile device or via the mobile application marketplace or network.


・Data Retention Policy
The Service Provider will retain User Provided data for as long as you use the Application and for a reasonable time thereafter. If you'd like them to delete User Provided Data that you have provided via the Application, please contact them at matunagachihiro@gmail.com and they will respond in a reasonable time.


・Children
The Service Provider does not use the Application to knowingly solicit data from or market to children under the age of 13.


The Application does not address anyone under the age of 13. The Service Provider does not knowingly collect personally identifiable information from children under 13 years of age. In the case the Service Provider discover that a child under 13 has provided personal information, the Service Provider will immediately delete this from their servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact the Service Provider (matunagachihiro@gmail.com) so that they will be able to take the necessary actions.


・Security
The Service Provider is concerned about safeguarding the confidentiality of your information. The Service Provider provides physical, electronic, and procedural safeguards to protect information the Service Provider processes and maintains.


・Changes
This Privacy Policy may be updated from time to time for any reason. The Service Provider will notify you of any changes to the Privacy Policy by updating this page with the new Privacy Policy. You are advised to consult this Privacy Policy regularly for any changes, as continued use is deemed approval of all changes.


This privacy policy is effective as of 2024-04-01


・Your Consent
By using the Application, you are consenting to the processing of your information as set forth in this Privacy Policy now and as amended by us.


・Contact Us
If you have any questions regarding privacy while using the Application, or have questions about the practices, please contact the Service Provider via email at matunagachihiro@gmail.com.
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