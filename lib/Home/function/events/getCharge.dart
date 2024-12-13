import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_go/Home/function/examine.dart';
import 'package:xtyle/xtyle.dart';

Future<void> getCharge(BuildContext context, int percent) async {
  final examines = Get.put(examine()); // 게이지 컨트롤러

  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: XtyleText(
              percent == 50 ? "핸드폰 충전" : "고급 주유소",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.055, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.05, bottom: MediaQuery.of(context).size.width * 0.1),
                  child: Image.asset("assets/images/events/charge_$percent.png", width: MediaQuery.of(context).size.width * 0.3),
                ),
                Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.05, bottom: MediaQuery.of(context).size.width * 0.05),
                  child: XtyleText(
                    percent == 50 ? "핸드폰을 충전할 수 있는 공간을 발견했다! \n 하지만 많이는 못 할 거 같다." : "고급 주유소를 발견했다! \n \"사장님, 여기 가득이요!\"",
                    textAlign: TextAlign.center,
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    WidgetSpan(
                      child: Text("조사하기 게이지가 $percent% 회복합니다.", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.04)),
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
                      examines.Gauge += percent;
                      Navigator.of(context).pop(); // 알림창을 닫고
                    },
                    child: const XtyleText("확인")),
              )
            ],
          ));
}
