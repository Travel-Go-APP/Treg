import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_go/Home/function/examine.dart';
import 'package:travel_go/Home/function/userController.dart';
import 'package:xtyle/xtyle.dart';

Future<void> getSearch(BuildContext context, int Search) async {
  final userDate = Get.put(userController()); // 유저 컨트롤러

  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: XtyleText(
              Search > 0 ? "드링크 충전" : "몸살에 걸려버렸다!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.055,
                  fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.05,
                      bottom: MediaQuery.of(context).size.width * 0.1),
                  child: Image.asset(
                      "assets/images/events/Search${Search > 0 ? "UP" : "Down"}.png",
                      width: MediaQuery.of(context).size.width * 0.3),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.05,
                      bottom: MediaQuery.of(context).size.width * 0.05),
                  child: XtyleText(
                    Search > 0
                        ? "한 입 마시니깐 온 몸에 \n 에너지가 생기는 기분이다."
                        : "온 몸에 기운이 빠진다....",
                    textAlign: TextAlign.center,
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    WidgetSpan(
                      child: Text(
                        Search > 0
                            ? "조사하기 횟수 차감이 되지 않고 \n 추가적으로 1회 회복합니다."
                            : "조사하기 횟수가 2배로 감소합니다.",
                        style: TextStyle(
                            color: Search > 0 ? Colors.blue : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
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
