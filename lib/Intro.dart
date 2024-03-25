import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:mezamashi/sharedPref.dart';

import 'BottomNavigationBar.dart';

class Intro extends StatelessWidget {
  // Making list of pages needed to pass in IntroViewsFlutter constructor.
  final pages = [
    PageViewModel( //アラーム作るボタンの説明
      pageColor: Colors.green[200],
      body: const Text(
        '画面右下にあるボタンを押すと新規アラームを作ることができます',
      ),
      title: const Text(
        'アラーム機能の使い方',
      ),
      titleTextStyle: const TextStyle(
        fontFamily: 'MyFont',
        color: Colors.white,
        fontSize: 40,
      ),
      bodyTextStyle: const TextStyle(
        fontFamily: 'MyFont',
        color: Colors.white,
        fontSize: 20,
      ),
      mainImage: Image.asset(
        'assets/images/intro1.png',
        height: 300.0,
        width: 300.0,
        alignment: Alignment.center,
      ),
    ),
    PageViewModel( //アラーム作る画面の説明
      pageColor: Colors.green[200],
      body: const Text(
        'アラームを設定したい時間とアラーム音を選べます',
      ),
      title: const Text(
        'アラーム機能の使い方',
      ),
      titleTextStyle: const TextStyle(
        fontFamily: 'MyFont',
        color: Colors.white,
        fontSize: 40,
      ),
      bodyTextStyle: const TextStyle(
        fontFamily: 'MyFont',
        color: Colors.white,
        fontSize: 20,
      ),
      mainImage: Image.asset(
        'assets/images/intro2.png',
        height: 300.0,
        width: 300.0,
        alignment: Alignment.center,
      ),
    ),
    PageViewModel(
      pageColor: Colors.green[200],
      body: const Text(
        'アラームが鳴ってから止める時間が早かったり、スヌーズを使わないと朝顔が成長してより多くの花が咲きます',
      ),
      title: const Text('朝顔の成長について'),
      mainImage: Image.asset(
        'assets/images/intro3.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle: const TextStyle(
        fontFamily: 'MyFont',
        color: Colors.white,
        fontSize: 40,
      ),
      bodyTextStyle: const TextStyle(
        fontFamily: 'MyFont',
        color: Colors.white,
        fontSize: 20,
      ),
    ),
  ];

  Intro({super.key});

  @override
  Widget build(BuildContext context) {
    sharedPref.save("isAccount", ["true"]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IntroViews Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(
        builder: (context) => IntroViewsFlutter(
          pages,
          showNextButton: true,
          showBackButton: true,
          onTapDoneButton: () {
            // Use Navigator.pushReplacement if you want to dispose the latest route
            // so the user will not be able to slide back to the Intro Views.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BottomNavigationBarScreen()),
            );
          },
          pageButtonTextStyles: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}