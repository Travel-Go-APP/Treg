import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:travel_go/Home/function/userController.dart';
import 'package:travel_go/Login/function/apple_login.dart';
import 'package:xtyle/xtyle.dart';

class attractionController extends GetxController {
  final AppleLogin appleLogin = AppleLogin();
  final userDate = Get.put(userController()); // 사용자 정보 컨트롤러

  Future<void> visitAttraction(int locationId) async {
    var httpClient = http.Client();
    String? email = await appleLogin.getEmailPrefix();
    var urlPath = dotenv.env['SERVER_URL'];

    userDate.connectingNetwork.value = true; // 화면 움직이지 못하게 금지

    final url = Uri.parse('$urlPath/api/visit');

    var headers = {
      "accept": '*/*',
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = {
      "email": "$email",
      "attractionId": locationId
    };

    try {
      var response =
          await httpClient.post(url, headers: headers, body: jsonEncode(body));
      print("responseCode ${response.statusCode}");
      var responseData = jsonDecode(utf8.decode(response.bodyBytes));
      print("명소 등록 결과 : $responseData");
    } catch (e) {
      print("명소 등록 에러 : $e");
    }

    userDate.connectingNetwork.value = false; // 화면 움직이지 못하게 금지
  }

  // 어느 명소를 들렸는지 정보 확인
  Future<void> getAttraction(BuildContext context, int locationId) async {
    var httpClient = http.Client();

    var urlPath = dotenv.env['SERVER_URL'];
    // String? email = await appleLogin.getEmailPrefix();
    final url = Uri.parse('$urlPath/api/attraction/$locationId');

    userDate.connectingNetwork.value = true;

    var headers = {
      "accept": '*/*',
      'Content-Type': 'application/json',
    };

    try {
      var response = await httpClient.get(url, headers: headers);
      var responseData = jsonDecode(utf8.decode(response.bodyBytes));
      print("명소 정보 : $responseData");
      String name = responseData['attractionName'];
      // latitude.value = responseData['latitude'];
      // longitude.value = responseData['longitude'];
      String address = responseData['address'];
      String imageUrl = responseData['attractionImageUrl'];
      String description = responseData['description'];

      dialogAttraction(context, name, address, imageUrl, description);
    } catch (e) {
      print("Error: $e");
    }

    userDate.connectingNetwork.value = false; // 화면 움직이지 못하게 금지
  }

  Future<void> dialogAttraction(BuildContext context, String name,
      String address, String imageURL, String description) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              titlePadding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: XtyleText(
                      name,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_pin,
                            size: MediaQuery.of(context).size.width * 0.035),
                        XtyleText(
                          address,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  imageURL.isNotEmpty
                      ? SizedBox(
                          // width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width * 0.5,
                          child: Image.network(imageURL, fit: BoxFit.cover))
                      : Image.asset(
                          "assets/images/Logo.png",
                          scale: MediaQuery.of(context).size.width * 0.01,
                        ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Text(
                    description.length > 200
                        ? '${description.substring(0, 200)}... (이하 생략)'
                        : description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        fontWeight: FontWeight.w300),
                  )
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: XtyleText(
                    "\"$name\"이 등록되었습니다.",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        color: const Color.fromARGB(255, 26, 141, 30)),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // 알림창을 닫고
                      },
                      child: const XtyleText("확인")),
                )
              ],
            ));
  }
}
