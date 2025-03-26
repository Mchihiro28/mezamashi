import 'package:flutter/material.dart';

/// alertDialogを表示するクラス
///
/// アラーム音を選択する際に表示する。
class SimpleDialogSample extends StatelessWidget {
  const SimpleDialogSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('アラーム音を選んでください'),
      children: [
        SimpleDialogOption(
          child: const Text('アラーム1　（シンプル）'),
          onPressed: () {
            Navigator.pop(context, 1);
          },
        ),
        SimpleDialogOption(
          child: const Text('アラーム2　（スロー）'),
          onPressed: () {
            Navigator.pop(context, 2);
          },
        ),
        SimpleDialogOption(
          child: const Text('アラーム3　（クラシック）'),
          onPressed: () {
            Navigator.pop(context, 3);
          },
        )
      ],
    );
  }
}