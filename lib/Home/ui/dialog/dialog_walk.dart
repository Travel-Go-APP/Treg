import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:travel_go/Home/function/Geolocation.dart';
import 'package:travel_go/Home/function/StepCountController.dart';
import 'package:travel_go/Home/function/db_steps.dart';
import 'package:travel_go/Home/function/userController.dart';
import 'package:travel_go/Login/function/apple_login.dart';
import 'package:travel_go/collection/ui/SelectedItemDetail.dart';
import 'package:travel_go/style.dart';
import 'package:xtyle/xtyle.dart';
import 'package:http/http.dart' as http;

// 걸음 수 + 운동화 관련 dialog
class walkDiaglog extends GetxController {
  RxBool checking = false.obs;

  Future<void> dialogWalk(BuildContext context) {
    final walkingcount = Get.put(dbSteps());
    final userDate = Get.put(userController()); // 일일미션 컨트롤러
    final AppleLogin appleLogin = AppleLogin();
    final userlatlong = Get.put(LatLngController());
    var httpClient = http.Client();

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: alertStyle,
              title: Container(
                alignment: Alignment.center,
                child: XtyleText("활동 포인트",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.06)),
              ),
              content: GetBuilder<dbSteps>(
                  // 현재 걸음 수
                  builder: (controller) => Obx(() => SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                          Image.asset('assets/images/gift3.png',
                              scale: MediaQuery.of(context).size.width * 0.015,
                              alignment: Alignment.center,
                              color: controller.steps.value < 10000
                                  ? Colors.grey
                                  : null),
                          Container(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            alignment: Alignment.center,
                            child: XtyleText(
                              "1,000 Exp + 일반 ~ 지역 아이템 뽑기",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.03,
                                  color: const Color.fromARGB(255, 37, 87, 38)),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.03),
                          const XtyleText("사용자의 걸음수를 기반으로 \n 게이지가 충전됩니다.",
                              textAlign: TextAlign.center),
                          const Text("(일일 1회 보상)",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey)),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.03),
                          // Container(
                          //   alignment: Alignment.topLeft,
                          //   child: XtyleText(
                          //       "걸음 수 : ${controller.steps.value} 보",
                          //       style: TextStyle(
                          //           fontSize:
                          //               MediaQuery.of(context).size.width *
                          //                   0.03)),
                          // ),
                          LinearPercentIndicator(
                            linearGradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromARGB(255, 127, 247, 131),
                                  Colors.green,
                                ]),
                            animation: true,
                            animationDuration: 1500,
                            animateFromLastPercent: true,
                            padding: const EdgeInsets.only(right: 10),
                            lineHeight:
                                MediaQuery.of(context).size.height * 0.023,
                            barRadius: const Radius.circular(8),
                            percent: controller.steps.value < 10000
                                ? controller.steps.value.toDouble() * 0.0001
                                : 1.0,
                            backgroundColor: Colors.white,
                            trailing: XtyleText(
                                "${((controller.steps.value / 10000) * 100).toInt()}%"),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.005),
                        ],
                      )))),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Obx(() => ElevatedButton(
                        style: addStyle,
                        onPressed: (walkingcount.steps.value >= 10000 &&
                                userDate.missionCount == 0)
                            ? () async {
                                checking.value = true;
                                userDate.connectingNetwork.value =
                                    true; // 화면 움직이지 못하게 금지
                                String? email =
                                    await appleLogin.getEmailPrefix();
                                var urlPath = dotenv.env['SERVER_URL'];

                                final url = Uri.parse(
                                    '$urlPath/api/user/mission?email=$email&latitude=${userlatlong.mylatitude}&longitude=${userlatlong.mylongitude}');

                                var headers = {
                                  "accept": '*/*',
                                  'Content-Type': 'application/json',
                                };

                                try {
                                  var response = await httpClient.post(url,
                                      headers: headers);
                                  print("responseCode ${response.statusCode}");
                                  // print(
                                  //     "활동 포인트  : ${utf8.decode(response.bodyBytes)}");
                                  var responseData = jsonDecode(
                                      utf8.decode(response.bodyBytes));
                                  print("활동포인트 결과 : $responseData");

                                  int chageTG = 0;
                                  int chageEXP = 0;

                                  if (responseData["tg"] != null) {
                                    userDate.userTG.value = responseData["tg"];
                                    chageTG = responseData["tgChange"];
                                  } else if (responseData["exp"] != null) {
                                    userDate.userLevel.value =
                                        responseData["level"];
                                    userDate.userExperience.value =
                                        responseData["experience"];
                                    userDate.userNextLevelExp.value =
                                        responseData["nextLevelExp"];
                                    userDate.percentage.value =
                                        responseData["percentage"];
                                    chageEXP = responseData["exp"];
                                  }

                                  int itemId =
                                      responseData["itemId"]; // 선택된 아이템 id
                                  int selectedItemRank =
                                      responseData["itemRank"]; // 선택된 아이템 등급
                                  String selectedItemName =
                                      responseData["itemName"]; // 선택된 아이템 이름
                                  // String selectedItemArea = responseData["area"]; // 선택된 아이템 지역
                                  String selectedItemSummary = responseData[
                                      "itemSummary"]; // 선택된 아이템 간략글?
                                  String selectedItemDescription = responseData[
                                      "itemDescription"]; // 선택된 아이템 내용?
                                  int itemPiece = responseData["itemPiece"];

                                  selectedItemDetail(
                                      context,
                                      itemId,
                                      selectedItemRank,
                                      selectedItemName,
                                      selectedItemSummary,
                                      selectedItemDescription,
                                      itemPiece,
                                      chageTG,
                                      chageEXP);

                                  userDate.missionCount.value = 1;
                                } catch (e) {
                                  print("활동 포인트 에러 : $e");
                                }
                                checking.value = false;
                                userDate.connectingNetwork.value =
                                    false; // 화면 움직이지 못하게 금지
                              }
                            : null,
                        child: checking.value
                            ? Container(
                                padding: const EdgeInsets.all(5),
                                child: const CircularProgressIndicator(),
                              )
                            : userDate.missionCount >= 1
                                ? const XtyleText("보상 획득 완료")
                                : const XtyleText("보상 받기")))),
              ],
            ));
  }
}
