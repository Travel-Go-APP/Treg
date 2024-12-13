import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:travel_go/Home/function/examine.dart';
import 'package:travel_go/Home/function/userController.dart';
import 'package:travel_go/Login/function/apple_login.dart';
import 'package:xtyle/xtyle.dart';
import 'package:http/http.dart' as http;

class roulette extends GetxController {
  final userDate = Get.put(userController()); // 사용자 정보 컨트롤러
  RxBool wheelmove = false.obs;
  RxBool oneWheel = false.obs;
  RxString item_name = "".obs;
  RxString title = "운을 시험해볼래?".obs;

  Future<void> getDealer(BuildContext context, List<String> list) async {
    wheelmove.value = false;
    oneWheel.value = false;
    StreamController<int> controller = StreamController<int>();

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/events/Dealer.png",
                    width: MediaQuery.of(context).size.width * 0.3),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.055,
                        fontWeight: FontWeight.bold,
                      ),
                      child: Obx(() => Text(
                            title.value,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.07),
                          ))),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: FortuneWheel(
                    physics: NoPanPhysics(), // 사용자가 드래그 하지 못하게 막음
                    animateFirst: false,
                    selected: controller.stream,
                    items: [
                      for (var it in list)
                        FortuneItem(
                            child: Text(
                          it,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        ))
                    ],
                    onAnimationStart: () {
                      wheelmove.value = true;
                      oneWheel.value = true;
                      title.value = "과연 뭐가 나올까...?";
                    },
                    onAnimationEnd: () {
                      wheelmove.value = false;
                      title.value = item_name.value == "꽝"
                          ? "저런.. 다음 기회에.."
                          : "${item_name.value} 당첨!!";
                    },
                    onFocusItemChanged: (value) {
                      item_name.value = list[value];
                    },
                    // onFocusItemChanged: (value) {
                    //   print(value);
                    // },
                  ),
                ),
                Obx(() => ElevatedButton(
                    onPressed: !userDate.connectingNetwork.value
                        ? () async {
                            if (wheelmove.value == false &&
                                oneWheel.value == true) {
                              Navigator.of(context).pop(); // 알림창을 닫고

                              wheelmove.value = false;
                              oneWheel.value = false;
                              title.value = "운을 시험해볼래?";

                              final AppleLogin appleLogin = AppleLogin();
                              userDate.connectingNetwork.value =
                                  true; // 화면 움직이지 못하게 금지

                              var httpClient = http.Client();

                              String? email = await appleLogin.getEmailPrefix();
                              var urlPath = dotenv.env['SERVER_URL'];

                              // GET 요청에서는 데이터를 쿼리 매개변수로 추가
                              final url = Uri.parse(
                                  '$urlPath/api/search/event/merchant/roulette?email=$email&result=$item_name');

                              var headers = {
                                "accept": '*/*',
                                'Content-Type': 'application/json',
                              };

                              try {
                                var response = await httpClient.post(url,
                                    headers: headers);
                                var responseData =
                                    jsonDecode(utf8.decode(response.bodyBytes));
                                print("룰렛 반영 : $responseData");

                                userDate.userTG.value = responseData["tg"];
                                userDate.userLevel.value =
                                    responseData["level"];
                                userDate.userExperience.value =
                                    responseData["experience"];
                                userDate.userNextLevelExp.value =
                                    responseData["nextLevelExp"];
                                userDate.percentage.value =
                                    responseData["percentage"];
                              } catch (e) {
                                print("Error: $e");
                              }
                              userDate.connectingNetwork.value =
                                  false; // 화면 움직이지 못하게 금지
                            } else if (wheelmove.value == false &&
                                oneWheel.value == false) {
                              controller.add(
                                Fortune.randomInt(0, list.length),
                              );
                            } else {}
                          }
                        : null,
                    child: userDate.connectingNetwork.value
                        ? const CircularProgressIndicator(color: Colors.blue)
                        : (wheelmove.value == false && oneWheel.value == true)
                            ? const XtyleText("닫기")
                            : const XtyleText("돌리기"))),
              ],
            ));
  }
}
