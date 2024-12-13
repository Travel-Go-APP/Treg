import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_go/Home/function/userController.dart';
import 'package:travel_go/Home/ui/statusBar.dart';
import 'package:travel_go/style.dart';
import 'package:xtyle/xtyle.dart';
import 'package:intl/intl.dart';

// LEVEL 관련 툴팁
Future<void> levelTip(BuildContext context) {
  final levels = Get.put(userController()); // 레벨 관련
  String expCount = NumberFormat("###,###")
      .format(levels.userNextLevelExp.value - levels.userExperience.value);
  String nowExp = NumberFormat("###,###").format(levels.userExperience.value);
  String totalExp =
      NumberFormat("###,###").format(levels.userNextLevelExp.value);
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: alertStyle,
            title: Container(
              alignment: Alignment.center,
              child: const XtyleText("LEVEL"),
            ),
            content: Container(
                height: MediaQuery.of(context).size.height * 0.25,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    XtyleText(
                      "남은 EXP : $expCount",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05),
                    ),
                    XtyleText(
                      "[$nowExp / $totalExp] \n",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          color: const Color.fromARGB(255, 133, 133, 133)),
                    ),
                    const Divider(height: 1),
                    XtyleText(
                      "\n 게이지 충전 : 100%",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                    XtyleText(
                      "조사하기 범위 : 100%",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                      ),
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
                      Navigator.of(context).pop(); // 알림창을 닫고
                    },
                    child: const XtyleText("닫기")),
              ),
            ],
          ));
}
