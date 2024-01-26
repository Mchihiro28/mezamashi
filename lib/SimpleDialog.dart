import 'package:flutter/material.dart';

class SimpleDialogSample extends StatelessWidget {
  //TODO 選択肢を書き換える

  const SimpleDialogSample({Key? key}) : super(key: key);
  static const String audio1 = "";
  static const String audio2 = "";
  static const String audio3 = "";

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('アラーム音を選んでください'),
      children: [
        SimpleDialogOption(
          child: const Text('選択肢1'),
          onPressed: () {
            Navigator.pop(context, audio1);
          },
        ),
        SimpleDialogOption(
          child: const Text('選択肢2'),
          onPressed: () {
            Navigator.pop(context, audio2);
          },
        ),
        SimpleDialogOption(
          child: const Text('選択肢3'),
          onPressed: () {
            Navigator.pop(context, audio3);
          },
        )
      ],
    );
  }
}