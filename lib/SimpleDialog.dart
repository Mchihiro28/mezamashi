import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class SimpleDialogSample extends StatelessWidget {
  SimpleDialogSample({Key? key}) : super(key: key);
  final audioPlayer = AudioPlayer();
  static const String audio1 = "sounds/1_default.mp3";
  static const String audio2 = "sounds/2_slow.mp3";
  static const String audio3 = "sounds/3_classic.mp3";

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('アラーム音を選んでください'),
      children: [
        SimpleDialogOption(
          child: const Text('アラーム1'),
          onPressed: () {
            audioPlayer.play(AssetSource(audio1));
            Navigator.pop(context, audio1);
          },
        ),
        SimpleDialogOption(
          child: const Text('アラーム2'),
          onPressed: () {
            audioPlayer.play(AssetSource(audio2));
            Navigator.pop(context, audio2);
          },
        ),
        SimpleDialogOption(
          child: const Text('アラーム3'),
          onPressed: () {
            audioPlayer.play(AssetSource(audio3));
            Navigator.pop(context, audio3);
          },
        )
      ],
    );
  }
}