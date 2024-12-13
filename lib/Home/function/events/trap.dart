import 'package:flutter/material.dart';
import 'package:xtyle/xtyle.dart';

Future<void> trap(BuildContext context) async {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: XtyleText(
              "함정에 빠졌다 !",
              style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.055, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.05, bottom: MediaQuery.of(context).size.width * 0.1),
                  child: Image.asset("assets/images/events/trap.png", width: MediaQuery.of(context).size.width * 0.3),
                ),
                Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.05, bottom: MediaQuery.of(context).size.width * 0.05),
                  child: const XtyleText(
                    "떨어지면서 지갑을 잃어버린거같다...",
                    textAlign: TextAlign.center,
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    WidgetSpan(
                      child: Text("보유 TG가 20% 감소합니다.", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.05)),
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
