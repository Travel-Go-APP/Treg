import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_go/Attraction/function/attraction_info.dart';
import 'package:travel_go/style.dart';
import 'package:xtyle/xtyle.dart';

Future<void> dialogHint(BuildContext context) async {
  final attractInfos = Get.put(attractInfo());

  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: alertStyle,
            title: Container(
              alignment: Alignment.center,
              child: const XtyleText("미획득 명소"),
            ),
            content: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    XtyleText(
                      "돋보기를 사용해서 \n 힌트를 얻겠습니까?",
                      style: nameStyle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                )),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  style: addStyle,
                  onPressed: () async {
                    await attractInfos.updateHint();
                    Navigator.of(context).pop(); // 알림창을 닫고
                  },
                  child: RichText(
                    text: TextSpan(children: [
                      const WidgetSpan(
                          child: Icon(
                        Icons.search,
                        color: Colors.blue,
                      )),
                      WidgetSpan(
                          child: XtyleText(
                        "사용하기",
                        style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, fontFamily: 'GmarketSans', color: Colors.blue),
                      )),
                    ]),
                  ),
                ),
              ),
            ],
          ));
}
