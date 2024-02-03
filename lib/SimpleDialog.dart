import 'package:flutter/material.dart';

class SimpleDialogSample extends StatelessWidget {
  const SimpleDialogSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('アラーム音を選んでください'),
      children: [
        SimpleDialogOption(
          child: const Text('アラーム1'),
          onPressed: () {
            Navigator.pop(context, 1);
          },
        ),
        SimpleDialogOption(
          child: const Text('アラーム2'),
          onPressed: () {
            Navigator.pop(context, 2);
          },
        ),
        SimpleDialogOption(
          child: const Text('アラーム3'),
          onPressed: () {
            Navigator.pop(context, 3);
          },
        )
      ],
    );
  }
}