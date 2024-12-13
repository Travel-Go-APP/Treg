import 'package:flutter/material.dart';
import 'package:xtyle/xtyle.dart';

Future<void> getLevel(BuildContext context) async {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: XtyleText(
              "유성을 발견했다 !",
              style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.055, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.05, bottom: MediaQuery.of(context).size.width * 0.1),
                  child: Image.asset("assets/images/events/LEVEL_1_UP.png", width: MediaQuery.of(context).size.width * 0.3),
                ),
                Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.05, bottom: MediaQuery.of(context).size.width * 0.05),
                  child: const XtyleText(
                    "온 우주의 기운이 내게로 오는거 같다.",
                    textAlign: TextAlign.center,
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    WidgetSpan(
                      child: Text("LEVEL 1 UP", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.05)),
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
