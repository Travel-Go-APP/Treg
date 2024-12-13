import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:travel_go/Home/function/Geolocation.dart';
import 'package:travel_go/Home/function/examine.dart';
import 'package:travel_go/Home/function/userController.dart';
import 'package:travel_go/Home/ui/dialog/dialog_location.dart';
import 'package:xtyle/xtyle.dart';

class event extends GetxController {
  Future<void> addMapAttraction(BuildContext context) async {
    showToastWidget(
      Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.75,
        height: MediaQuery.of(context).size.height * 0.07,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(context).size.width * 0.05)),
            border: Border.all(
                color: const Color.fromARGB(255, 5, 164, 0), width: 2)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(
              Icons.map,
              color: Color.fromARGB(255, 5, 164, 0),
            ),
            XtyleText(
              "어딘가에 좌표가 찍힌거 같다..",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  color: Colors.black),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
      duration: const Duration(seconds: 3),
      context: context,
      position: StyledToastPosition(
          align: Alignment.topCenter,
          offset: MediaQuery.of(context).size.width * 0.25),
      curve: Curves.fastOutSlowIn,
      animation: StyledToastAnimation.slideFromTop,
      reverseAnimation: StyledToastAnimation.fade,
    );
  }

  // 이벤트 마커 (30% 확률로 아무 일도 벌어지지 않음)
  Future<void> nothingExamine(BuildContext context) async {
    showToastWidget(
      Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.75,
        height: MediaQuery.of(context).size.height * 0.07,
        decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(context).size.width * 0.05)),
            border: Border.all(color: Colors.black, width: 2)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            XtyleText(
              "조사를 해봤지만 아무것도 없습니다...",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  color: Colors.black),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
      duration: const Duration(seconds: 3),
      context: context,
      position: StyledToastPosition(
          align: Alignment.topCenter,
          offset: MediaQuery.of(context).size.width * 0.25),
      curve: Curves.fastOutSlowIn,
      animation: StyledToastAnimation.slideFromTop,
      reverseAnimation: StyledToastAnimation.fade,
    );
  }

  // 이벤트 마커 (거리가 멀때)
  Future<void> failExamine(
      BuildContext context, double meter, double minMeter, String id) async {
    showToastWidget(
      isIgnoring: false, // 버튼 같은 동작을 하기 위한 용도
      Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(context).size.width * 0.05)),
            border: Border.all(color: Colors.black, width: 2)),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.07,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // const Icon(Icons.warning_amber, color: Colors.orange),
            RichText(
              text: TextSpan(children: [
                WidgetSpan(
                  child: (meter - minMeter).toInt() >= 100
                      ? Text(
                          "${((meter - minMeter) / 1000).toStringAsFixed(1)} km",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.bold,
                              color: Colors.red))
                      : Text(" ${(meter - minMeter).toInt()}m ",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                ),
                WidgetSpan(
                  child: XtyleText("만큼 더 이동해야 합니다.",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04)),
                ),
              ]),
            ),
            // 멀리 있는 이벤트 삭제 하기 위한 용도
            IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  naverMap.mapController.deleteOverlay(
                      NOverlayInfo(type: NOverlayType.marker, id: id));
                  final marker = Get.put(LatLngController()); // 사용자 정보 컨트롤러
                  marker.examcount.value -= 1; // 마커 카운트 감소
                  ToastManager().dismissAll(showAnim: true);
                  print("이벤트 삭제");
                },
                icon: const Icon(Icons.delete_forever))
          ],
        ),
      ),
      duration: const Duration(seconds: 3),
      context: context,
      position: StyledToastPosition(
          align: Alignment.topCenter,
          offset: MediaQuery.of(context).size.width * 0.25),
      curve: Curves.fastOutSlowIn,
      animation: StyledToastAnimation.slideFromTop,
      reverseAnimation: StyledToastAnimation.fade,
    );
  }

  // 더 이상 남은 조사하기 카운트가 없을때
  Future<void> noCountSearch(BuildContext context) async {
    showToastWidget(
      Container(
        decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(context).size.width * 0.05)),
            border: Border.all(color: Colors.black, width: 2)),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.07,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RichText(
              text: TextSpan(children: [
                WidgetSpan(
                  child: XtyleText("조사하기 횟수가 부족합니다..",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04)),
                ),
              ]),
            ),
          ],
        ),
      ),
      duration: const Duration(seconds: 3),
      context: context,
      position: StyledToastPosition(
          align: Alignment.topCenter,
          offset: MediaQuery.of(context).size.width * 0.25),
      curve: Curves.fastOutSlowIn,
      animation: StyledToastAnimation.slideFromTop,
      reverseAnimation: StyledToastAnimation.fade,
    );
  }

  // 생성된 마커가 10개 넘었을때
  Future<void> overMarker(BuildContext context) async {
    showToastWidget(
      Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(context).size.width * 0.05)),
            border: Border.all(color: Colors.red, width: 2)),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.07,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(Icons.warning_amber, color: Colors.red),
            RichText(
              text: TextSpan(children: [
                WidgetSpan(
                  child: XtyleText(
                      " 더 이상 이벤트를 만들 수 없습니다. \n 생성된 이벤트를 먼저 수행하세요.",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.032)),
                ),
              ]),
            ),
          ],
        ),
      ),
      duration: const Duration(seconds: 4),
      context: context,
      position: StyledToastPosition(
          align: Alignment.topCenter,
          offset: MediaQuery.of(context).size.width * 0.25),
      curve: Curves.fastOutSlowIn,
      animation: StyledToastAnimation.slideFromTop,
      reverseAnimation: StyledToastAnimation.fade,
    );
  }
}
