import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:travel_go/Home/function/examine.dart';
import 'package:travel_go/Home/function/userController.dart';
import 'package:travel_go/Login/function/apple_login.dart';
import 'package:xtyle/xtyle.dart';
import 'package:http/http.dart' as http;

class wallet extends GetxController {
  final userDate = Get.put(userController()); // 사용자 정보 컨트롤러
  RxBool isselected = false.obs;
  RxBool walletNetwork = false.obs;
  RxString title = "땅에 떨어진 지갑".obs;
  RxString bodyText = "누군가 잃어버린거 같다. \n 주인을 찾아줘야 될까?".obs;
  RxString resultText = "".obs;

  Future<void> getWallet(BuildContext context) async {
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Obx(() => SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.width * 0.3,
                        child: title.value == "경찰서를 방문했다 !!"
                            ? Image.asset("assets/images/events/police.png")
                            : title.value == "지갑을 훔쳤다..."
                                ? Image.asset("assets/images/events/still.png")
                                : Image.asset(
                                    "assets/images/events/wallet.png"),
                      )),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Obx(() => XtyleText(
                        bodyText.value,
                        textAlign: TextAlign.center,
                      )),
                  Obx(() =>
                      isselected.value ? Text(resultText.value) : Container())
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
                                  onPressed: () {
                                    resultWallet(true);
                                    title.value = "경찰서를 방문했다 !!";
                                    bodyText.value = "주인이 나에게 답례를 했다 !!";
                                    isselected.value = true;
                                  },
                                  child: const XtyleText("돌려준다")),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3.5,
                              child: ElevatedButton(
                                  onPressed: () {
                                    resultWallet(false);
                                    title.value = "지갑을 훔쳤다...";
                                    bodyText.value =
                                        "굉장히 잘못된 행동이지만.... \n 순간 충동을 참지 못했다..";
                                    isselected.value = true;
                                    // Navigator.of(context).pop(); // 알림창을 닫고
                                  },
                                  child: const XtyleText("가져간다")),
                            )
                          ],
                        ),
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            onPressed: !userDate.connectingNetwork.value
                                ? () {
                                    Navigator.of(context).pop(); // 알림창을 닫고
                                    title.value = "땅에 떨어진 지갑";
                                    bodyText.value =
                                        "누군가 잃어버린거 같다. \n 주인을 찾아줘야 될까?";
                                    resultText.value = "";
                                    isselected.value = false;
                                  }
                                : null,
                            child: !userDate.connectingNetwork.value
                                ? const XtyleText("확인")
                                : const CircularProgressIndicator(
                                    color: Colors.blue)),
                      )),
              ],
            ));
  }

  Future<void> resultWallet(bool result) async {
    final AppleLogin appleLogin = AppleLogin();
    userDate.connectingNetwork.value = true; // 화면 움직이지 못하게 금지
    var httpClient = http.Client();

    // User? user = await UserApi.instance.me(); // 사용자 정보 가져오기 요청
    String? email = await appleLogin.getEmailPrefix();
    var urlPath = dotenv.env['SERVER_URL'];

    // GET 요청에서는 데이터를 쿼리 매개변수로 추가
    final url = Uri.parse(
        '$urlPath/api/search/event/wallet?email=$email&takeAction=$result');

    var headers = {
      "accept": '*/*',
      'Content-Type': 'application/json',
    };

    try {
      var response = await httpClient.post(url, headers: headers);
      var responseData = jsonDecode(utf8.decode(response.bodyBytes));
      print("지갑 결과 : $responseData");

      userDate.userTG.value = responseData["tg"];
      resultText.value = responseData["tgChange"] == null
          ? "0 TG"
          : "${responseData["tgChange"]} TG";
    } catch (e) {
      print("지갑 결과 오류 : $e");
    }

    userDate.connectingNetwork.value = false; // 화면 해제
  }
}
