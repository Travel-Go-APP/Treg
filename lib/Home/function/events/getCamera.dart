import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_go/Home/function/examine.dart';
import 'package:travel_go/Home/function/userController.dart';
import 'package:travel_go/Login/function/apple_login.dart';
import 'package:xtyle/xtyle.dart';
import 'package:http/http.dart' as http;

class cameraEvent extends GetxController {
  final userDate = Get.put(userController()); // 사용자 정보 컨트롤러
  RxBool isselected = false.obs;
  RxString title = "오래된 카메라".obs;
  RxString bodyText = "세월의 흔적이 보이는 카메라다. \n 아직 작동할까? \n\n (카메라 권한이 필요합니다)".obs;
  RxString resultText = "".obs;
  // XFile? file;

  Future<void> getCamera(BuildContext context) async {
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
                        child: title == "오래된 카메라"
                            ? Image.asset("assets/images/camera.png")
                            : Image.asset("assets/images/picture.png"),
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
                                  onPressed: () async {
                                    await _pickImage(context);
                                  },
                                  child: const XtyleText("찍어본다")),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3.5,
                              child: ElevatedButton(
                                  onPressed: () {
                                    title.value = "오래된 카메라";
                                    bodyText.value =
                                        "세월의 흔적이 보이는 카메라다. \n 아직 작동할까? \n\n (카메라 권한이 필요합니다)";
                                    resultText.value = "";
                                    isselected.value = false;
                                    Navigator.of(context).pop(); // 알림창을 닫고
                                  },
                                  child: const XtyleText("그냥간다")),
                            )
                          ],
                        ),
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            onPressed: !userDate.connectingNetwork.value
                                ? () {
                                    title.value = "오래된 카메라";
                                    bodyText.value =
                                        "세월의 흔적이 보이는 카메라다. \n 아직 작동할까? \n\n (카메라 권한이 필요합니다)";
                                    resultText.value = "";
                                    isselected.value = false;
                                    Navigator.of(context).pop(); // 알림창을 닫고
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

  Future<void> resultCamera() async {
    final AppleLogin appleLogin = AppleLogin();
    userDate.connectingNetwork.value = true; // 화면 움직이지 못하게 금지

    var httpClient = http.Client();

    // User? user = await UserApi.instance.me(); // 사용자 정보 가져오기 요청
    String? email = await appleLogin.getEmailPrefix();
    var urlPath = dotenv.env['SERVER_URL'];

    // GET 요청에서는 데이터를 쿼리 매개변수로 추가
    final url = Uri.parse('$urlPath/api/search/event/camera?email=$email');

    var headers = {
      "accept": '*/*',
      'Content-Type': 'application/json',
    };

    try {
      var response = await httpClient.post(url, headers: headers);
      var responseData = jsonDecode(utf8.decode(response.bodyBytes));
      print("카메라 결과 : $responseData");

      userDate.userTG.value = responseData["tg"];
      resultText.value = responseData["tgChange"] == null
          ? "0 TG 를 획득합니다."
          : "${responseData["tgChange"]} TG 를 획득합니다.";
    } catch (e) {
      print("카메라 결과 오류 : $e");
    }

    userDate.connectingNetwork.value = false; // 화면 움직이지 못하게 금지
  }

  Future<void> _pickImage(BuildContext context) async {
    ImagePicker().pickImage(source: ImageSource.camera).then((image) {
      if (image != null) {
        title.value = "추억이 담긴 사진";
        bodyText.value = "소중한 기억으로 남아 있기를..";
        resultCamera();
        isselected.value = true;
      } else {
        Navigator.of(context).pop();
      }
    });
  }
}
