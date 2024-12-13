import 'dart:io';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:travel_go/Home/function/StepCounterAndroidController.dart';
import 'package:travel_go/Home/function/StepCounterIOSController.dart';
import 'package:travel_go/Home/function/db_steps.dart';
import 'package:travel_go/Home/function/userController.dart';
import 'package:travel_go/Home/ui/dialog/dialog_item.dart';
import 'package:travel_go/Home/ui/dialog/dialog_level.dart';
import 'package:travel_go/Home/ui/dialog/dialog_walk.dart';
import 'package:xtyle/xtyle.dart';
import 'package:intl/intl.dart';

class statusBar extends GetxController {
  final stepdb = Get.put(dbSteps());
  final userDate = Get.put(userController()); // 일일미션 컨트롤러
  final walkDiaglogs = Get.put(walkDiaglog()); // 일일미션 컨트롤러

  double widgetWidth = 0.2;
  double widgetHeight = 0.08;

  Widget status(BuildContext context) {
    return Positioned(
        top: MediaQuery.of(context).padding.top * 0.99,
        child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // mission(context),
                    mywalking(context),
                    mylv(context),
                    visitBenefits(context),
                  ],
                ),
                visitWeather(context)
              ],
            )));
  }

  Widget mywalking(BuildContext context) {
    return Obx(() {
      // String walkcount = NumberFormat("###,###").format(stepdb.steps.value);
      String walkcount = NumberFormat("###%")
          .format(stepdb.steps.value > 10000 ? 1 : stepdb.steps.value / 10000);
      return InkWell(
        onTap: () {
          walkDiaglogs.dialogWalk(context);
        },
        child: Container(
          alignment: Alignment.center,
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
          decoration: BoxDecoration(
            color: const Color.fromARGB(143, 255, 255, 255),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // 그림자 색상 및 투명도
                spreadRadius: 2, // 그림자 확산 범위
                blurRadius: 4, // 그림자의 흐림 정도
                offset: const Offset(0, 2), // 그림자의 위치
              ),
            ],
          ),
          width: MediaQuery.of(context).size.width * widgetWidth,
          height: MediaQuery.of(context).size.height * widgetHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/images/gift3.png',
                  scale: MediaQuery.of(context).size.height * 0.022,
                  color: stepdb.steps.value < 10000 ? Colors.grey : null),
              // Icon(Icons.directions_walk_outlined,
              //     size: MediaQuery.of(context).size.width * 0.06),
              // walkcount
              XtyleText(userDate.missionCount.value >= 1 ? "획득 완료" : walkcount,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: userDate.missionCount.value >= 1
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: userDate.missionCount.value >= 1
                          ? const Color.fromARGB(255, 37, 109, 40)
                          : Colors.black),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    });
  }

  Widget mylv(BuildContext context) {
    return Obx(() => Container(
          alignment: Alignment.center,
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
          decoration: BoxDecoration(
            color: const Color.fromARGB(143, 255, 255, 255),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // 그림자 색상 및 투명도
                spreadRadius: 2, // 그림자 확산 범위
                blurRadius: 4, // 그림자의 흐림 정도
                offset: const Offset(0, 2), // 그림자의 위치
              ),
            ],
          ),
          width: MediaQuery.of(context).size.width * widgetWidth * 2.5,
          height: MediaQuery.of(context).size.height * widgetHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("LV. ${userDate.userLevel} ",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontWeight: FontWeight.bold)),
                  XtyleText(" ${userDate.nickname}",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.035)),
                ],
              ),
              InkWell(
                  onTap: () {
                    levelTip(context);
                  },
                  child: Obx(
                    () => LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width *
                            widgetWidth *
                            2.5,
                        lineHeight: MediaQuery.of(context).size.height * 0.03,
                        barRadius: Radius.circular(
                            MediaQuery.of(context).size.width * 0.1),
                        progressColor: Colors.blue,
                        backgroundColor: Colors.white,
                        percent: (userDate.percentage.value * 0.01),
                        animation: true,
                        animationDuration: 2000,
                        animateFromLastPercent: true,
                        center: AnimatedFlipCounter(
                          curve: Curves.easeInOutQuad,
                          wholeDigits: 1,
                          value: userDate.percentage.value.toInt(),
                          suffix: "%",
                          duration: const Duration(
                              milliseconds: 2000), // 퍼센트와 시간을 맞추기 위해
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'GmarketSans',
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03),
                        )),
                  ))
            ],
          ),
        ));
  }

  Widget visitBenefits(BuildContext context) {
    final visit = Get.put(userController()); // 방문혜택 컨트롤러

    return Obx(() => Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
        decoration: BoxDecoration(
          color: const Color.fromARGB(143, 255, 255, 255),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // 그림자 색상 및 투명도
              spreadRadius: 2, // 그림자 확산 범위
              blurRadius: 4, // 그림자의 흐림 정도
              offset: const Offset(0, 2), // 그림자의 위치
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width * widgetWidth,
        height: MediaQuery.of(context).size.height * widgetHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                XtyleText(visit.city.value,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 37, 109, 40))),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.01),
            Text(visit.benefit.value,
                style: TextStyle(
                    fontFamily: 'GmarketSans',
                    fontSize: MediaQuery.of(context).size.width * 0.028,
                    fontWeight: FontWeight.bold)),
          ],
        )));
  }

  Widget visitWeather(BuildContext context) {
    final weather = Get.put(userController()); // 방문혜택 컨트롤러

    return Obx(() => Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
        decoration: BoxDecoration(
          color: Color.fromARGB(236, 255, 255, 255),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // 그림자 색상 및 투명도
              spreadRadius: 2, // 그림자 확산 범위
              blurRadius: 4, // 그림자의 흐림 정도
              offset: const Offset(0, 2), // 그림자의 위치
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width * widgetWidth * 1.45,
        height: MediaQuery.of(context).size.height * widgetHeight * 0.35,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
                weatherIcon(weather.pty == "없음"
                    ? "${weather.weather}"
                    : "${weather.pty}"),
                size: MediaQuery.of(context).size.width * 0.035),
            XtyleText(
              "${weather.weather}",
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03),
            ),
            XtyleText(
              "${weather.tmp}°C",
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03),
            ),
          ],
        )));
  }

  IconData? weatherIcon(String weather) {
    IconData? icon;

    if (weather == "맑음") {
      icon = Icons.sunny;
    } else if (weather == "구름많음") {
      icon = Icons.cloud;
    } else if (weather == "흐림") {
      icon = Icons.cloud;
    } else if (weather == "비") {
      icon = Icons.water_drop;
    } else if (weather == "비/눈") {
      icon = Icons.snowing;
    } else if (weather == "눈") {
      icon = Icons.ac_unit;
    } else if (weather == "소나기") {
      icon = Icons.water_drop;
    } else {
      icon = Icons.sunny;
    }

    return icon;
  }
}
