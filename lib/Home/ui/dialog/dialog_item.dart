import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:xtyle/xtyle.dart';
import 'dart:ui' as ui;

Future<void> dialogGetItem(BuildContext context) async {
  late VideoPlayerController controller;

  controller = VideoPlayerController.asset("assets/video/test1.mp4")..initialize(); // 비디오 초기화
  controller.setVolume(0.0); // 비디오 볼륨
  controller.setLooping(true); // 비디오 반복재생
  controller.play(); // 비디오 재생

  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              title(),
              Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.width * 0.5,
                      color: Colors.white,
                      child: AspectRatio(aspectRatio: controller.value.aspectRatio, child: VideoPlayer(controller)),
                    ),
                    DefaultTextStyle(
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      child: const XtyleText(
                        "먹다 버린 캔",
                      ),
                    ),
                    DefaultTextStyle(
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        color: Colors.black,
                      ),
                      child: const XtyleText(
                        "누군가 먹다가 버린 캔인거 같다. \n 무언가를 채우면 돈이 될지도?",
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                    onPressed: () async {
                      await controller.dispose(); // 메모리 회수
                      Navigator.of(context).pop(); // 알림창을 닫고
                    },
                    child: const Text("확인")),
              )
            ],
          ));
}

Widget title() {
  return Stack(
    children: <Widget>[
      DefaultTextStyle(
        style: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3
            ..color = Colors.black, // <-- Border color
        ),
        child: const XtyleText(
          "Legend Item !",
        ),
      ),
      DefaultTextStyle(
        style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, foreground: Paint()..shader = ui.Gradient.linear(const Offset(0, 20), const Offset(300, 20), <Color>[Colors.yellow, Colors.green])),
        child: const XtyleText(
          "Legend Item !",
        ),
      ),
    ],
  );
}
