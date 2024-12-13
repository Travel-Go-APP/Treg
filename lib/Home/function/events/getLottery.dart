import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:scratcher/scratcher.dart';
import 'package:travel_go/Home/function/examine.dart';
import 'package:travel_go/Home/function/userController.dart';
import 'package:travel_go/Login/function/apple_login.dart';
import 'package:xtyle/xtyle.dart';
import 'package:http/http.dart' as http;

class lottery extends GetxController {
  RxBool isselected = false.obs;
  RxBool clear = false.obs;
  RxString title = "복권 판매점이다".obs;
  RxString bodyText = "오늘 운이 좋은거 같은데.. 한번?".obs;
  RxString subText = "(1000 TG가 소모됩니다)".obs;
  RxString lotteryResultText = "".obs;
  RxString resultText = "".obs;
  final userDate = Get.put(userController()); // 사용자 정보 컨트롤러

  Future<void> getlottery(BuildContext context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Obx(() => XtyleText(
                    title.value,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.055,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() => title.value == "복권 판매점이다"
                      ? Image.asset(
                          "assets/images/events/lottery.png",
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.2,
                        )
                      : Obx(() => !userDate.connectingNetwork.value
                          ? Scratcher(
                              brushSize: 30,
                              threshold: 50,
                              color: Colors.red,
                              // onChange: (value) =>
                              //     print("Scratch progress: $value%"),
                              onThreshold: () {
                                clear.value = true;
                                subText.value =
                                    "${lotteryResultText.value}를 획득합니다.";
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * 0.6,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                color: Colors.white,
                                child: Text("$lotteryResultText",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        color: Colors.green)),
                              ),
                            )
                          : const CircularProgressIndicator(
                              color: Colors.blue))),
                  Obx(() => XtyleText(
                        bodyText.value,
                        textAlign: TextAlign.center,
                      )),
                  Obx(() => Text(
                        subText.value,
                        textAlign: TextAlign.center,
                      )),
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                Obx(() => !isselected.value
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3.5,
                              child: ElevatedButton(
                                  onPressed: userDate.userTG >= 1000
                                      ? () {
                                          resultLottery(true);
                                          title.value = "과연 당첨이 될까..?";
                                          bodyText.value = "";
                                          subText.value = "";
                                          isselected.value = true;
                                        }
                                      : null,
                                  child: const XtyleText("구매한다")),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3.5,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // 알림창을 닫고
                                    title.value = "복권 판매점이다";
                                    bodyText.value = "오늘 운이 좋은거 같은데.. 한번?";
                                    subText.value = "(1000 TG가 소모됩니다)";
                                    lotteryResultText.value = "";
                                    resultText.value = "";
                                    isselected.value = false;
                                    clear.value = false;
                                  },
                                  child: const XtyleText("안한다")),
                            )
                          ],
                        ),
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            onPressed: clear.value
                                ? () {
                                    Navigator.of(context).pop(); // 알림창을 닫고

                                    title.value = "복권 판매점이다";
                                    bodyText.value = "오늘 운이 좋은거 같은데.. 한번?";
                                    subText.value = "(1000 TG가 소모됩니다)";
                                    lotteryResultText.value = "";
                                    resultText.value = "";
                                    isselected.value = false;
                                    clear.value = false;
                                  }
                                : null,
                            child: const XtyleText("확인")),
                      )),
              ],
            ));
  }

  Future<void> resultLottery(bool result) async {
    final AppleLogin appleLogin = AppleLogin();

    var httpClient = http.Client();

    // User? user = await UserApi.instance.me(); // 사용자 정보 가져오기 요청
    String? email = await appleLogin.getEmailPrefix();
    var urlPath = dotenv.env['SERVER_URL'];

    userDate.connectingNetwork.value = true;

    // GET 요청에서는 데이터를 쿼리 매개변수로 추가
    final url = Uri.parse('$urlPath/api/search/event/lottery?email=$email');

    var headers = {
      "accept": '*/*',
      'Content-Type': 'application/json',
    };

    try {
      var response = await httpClient.post(url, headers: headers);
      var responseData = jsonDecode(utf8.decode(response.bodyBytes));
      print("복권 결과 : $responseData");

      userDate.userTG.value = responseData["tg"];
      lotteryResultText.value = "${responseData["tgChange"]} TG";
      resultText.value = responseData["tgChange"] == null
          ? "0 TG를 획득합니다."
          : "${responseData["tgChange"]} TG를 획득합니다.";
    } catch (e) {
      print("복권 결과 오류 : $e");
    }

    userDate.connectingNetwork.value = false;
  }
}
