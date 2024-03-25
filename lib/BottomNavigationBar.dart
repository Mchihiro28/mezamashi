import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mezamashi/PlantScreen.dart';
import 'package:mezamashi/SettingScreen.dart';
import 'package:mezamashi/alarmListScreen.dart';
import 'AdBanner.dart';

class BottomNavigationBarScreen extends StatefulWidget{
  //BottomNavigationBar
  const BottomNavigationBarScreen({super.key});

  @override
  BottomNavigationBarScreenState createState() => BottomNavigationBarScreenState();
}

class BottomNavigationBarScreenState extends State<BottomNavigationBarScreen>{
  int _selectedIndex = 1; //bottom navigation barがタップされた場所を格納する変数
  final PageController _controller = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'navigation_bar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: PageView(
          controller: _controller,
          children: const [
              PlantScreen(),
              alarmListScreen(),
              SettingScreen(),
            ],
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        bottomNavigationBar: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [FutureBuilder(
              future: AdSize.getAnchoredAdaptiveBannerAdSize(Orientation.portrait,
                  MediaQuery.of(context).size.width.truncate()),
              builder: (
                  BuildContext context,
                  AsyncSnapshot<AnchoredAdaptiveBannerAdSize?> snapshot,
                  ) {
                if (snapshot.hasData) {
                  final data = snapshot.data;
                  if (data != null) {
                    return Container(
                      height: 70,
                      color: Colors.white70,
                      child: AdBanner(size: data),
                    );
                  } else {
                    return Container(
                      height: 70,
                      color: Colors.white70,
                    );
                  }
                } else {
                  return Container(
                    height: 70,
                    color: Colors.white70,
                  );
                }
              },
            ),
              BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'ホーム',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.access_alarm),
                    label: 'アラーム',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: '設定',
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: (int index) {
                  setState(() {
                    _selectedIndex = index; //変数の更新
                  });
                  _controller.jumpToPage(index); //PageViewのページの更新
                },
              ),
            ],
        ),
      ),
    );
  }

}