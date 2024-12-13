import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:travel_go/Home/function/Geolocation.dart';
import 'package:travel_go/Home/function/userController.dart';
import 'package:travel_go/style.dart';
import 'package:xtyle/xtyle.dart';

final naverMap = Get.put(LatLngController());

// 권한 요청
Future<void> dialogLocation(BuildContext context,
    PermissionStatus locationStatus, PermissionStatus activityStatus) async {
  final userDate = Get.put(userController()); // 유저 컨트롤러
  showDialog(
      barrierDismissible: false, // 여백 터치 금지
      context: context,
      builder: (context) => AlertDialog(
            shape: alertStyle,
            title: Container(
              alignment: Alignment.center,
              child: const XtyleText("권한 체크"),
            ),
            content: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    XtyleText(
                      "현재 ${locationStatus.isDenied && activityStatus.isDenied ? "위치 및 활동" : locationStatus.isDenied ? "위치" : "활동"} 권한이 없습니다.",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          color: Colors.red),
                    ),
                    XtyleText(
                      "원활한 Treg! 이용을 위해서는 권한을 \"앱을 사용하는 동안 허용\" 으로 체크해주세요.",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                    XtyleText(
                      "(확인을 누르면 권한 체크 페이지로 넘어갑니다)",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.03),
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
                      await Permission.location.request(); // 위치 권한 요청
                      await Permission.sensors
                          .request(); // 센서 권한 요청 (Ios - 걸음수)
                      await Permission.activityRecognition
                          .request(); // 활동 권한 요청 (Android - 걸음수)
                      Navigator.of(context).pop(); // 알림창을 닫고
                      await naverMap.getMap(context); // 이후, 현 위치 갱신
                      await userDate.updateUser();
                    },
                    child: const XtyleText("확인")),
              ),
            ],
          ));
}
