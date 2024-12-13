import 'package:flutter/material.dart';
import 'package:xtyle/xtyle.dart';

Future<void> getEXP(BuildContext context, int exp) async {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
            title: XtyleText(
              exp == 100
                  ? "책을 읽었습니다 !"
                      : "헬스장을 방문했습니다 !",
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
                  child: Image.asset("assets/images/events/EXP$exp.png"),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                XtyleText(
                  exp == 100
                      ? "마음의 양식을 쌓았다"
                          : "내 몸이 건강해지는 기분이다",
                  textAlign: TextAlign.center,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    WidgetSpan(
                      child: Text("EXP $exp ", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                    const WidgetSpan(
                      child: XtyleText("를 획득했습니다."),
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
