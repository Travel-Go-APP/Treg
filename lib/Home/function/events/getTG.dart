import 'package:flutter/material.dart';
import 'package:xtyle/xtyle.dart';

Future<void> getTG(BuildContext context, int TG) async {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
            title: XtyleText(
              TG == 100
                  ? "동전을 주웠습니다 !"
                      : "이벤트에 당첨 !",
              style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.055, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.3,
                  child: Image.asset("assets/images/events/TG$TG.png"),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                XtyleText(
                  TG == 100
                      ? "오늘은 재수가 좋은거같다"
                          : "오늘은 기분이 굉장히 좋다",
                  textAlign: TextAlign.center,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    WidgetSpan(
                      child: Text("TG $TG ", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                    const WidgetSpan(
                      child: XtyleText("을 획득합니다."),
                    ),
                  ]),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // 알림창을 닫고
                    },
                    child: const XtyleText("확인")),
              )
            ],
          ));
}
