import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:travel_go/Home/function/userController.dart';
import 'package:travel_go/Home/ui/statusBar.dart';
import 'package:travel_go/Login/function/apple_login.dart';
import 'package:travel_go/style.dart';
import 'package:xtyle/xtyle.dart';
import 'package:http/http.dart' as http;

// LEVEL 관련 툴팁
Future<void> dialogSearch(BuildContext context) {
  final userDate = Get.put(userController()); // 유저 컨트롤러
  final AppleLogin appleLogin = AppleLogin();
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: alertStyle,
            title: Container(
              alignment: Alignment.center,
              child: const XtyleText("회복 찬스"),
            ),
            content: Container(
                height: MediaQuery.of(context).size.height * 0.25,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset('assets/images/search.png',
                        scale: MediaQuery.of(context).size.width * 0.015),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        XtyleText(
                          "조사하기를 최대로 회복합니다",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.044),
                        ),
                        Text(
                          "남은 횟수 / 최대 횟수 : [${userDate.userPossibleSearch} / ${userDate.userMaxSearch}]",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035),
                        ),
                      ],
                    )
                  ],
                )),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  style: addStyle,
                  onPressed: userDate.userPossibleSearch.value <
                              userDate.userMaxSearch.value &&
                          userDate.userTG.value >= 5000
                      ? () async {
                          userDate.connectingNetwork.value = true;
                          Navigator.of(context).pop();
                          String? email = await appleLogin.getEmailPrefix();
                          var urlPath = dotenv.env['SERVER_URL'];
                          var httpClient = http.Client();

                          final url = Uri.parse(
                              '$urlPath/api/search/SearchCountRecover?email=$email');
                          var headers = {
                            "accept": '*/*',
                            'Content-Type': 'application/json',
                          };
                          try {
                            var response =
                                await httpClient.post(url, headers: headers);
                            var responseData =
                                jsonDecode(utf8.decode(response.bodyBytes));
                            print("조사하기 정보 : $responseData");
                            if (responseData['status'] == "성공") {
                              userDate.userPossibleSearch.value =
                                  userDate.userMaxSearch.value;
                              userDate.userTG.value = responseData['TG'];
                            } else {
                              print(responseData['message']);
                            }
                          } catch (e) {
                            print("조사하기 에러 : $e");
                          }
                          userDate.connectingNetwork.value = false;
                        }
                      : null,
                  child: () {
                    if (userDate.userPossibleSearch.value >=
                        userDate.userMaxSearch.value) {
                      return const Text("이미 최대치입니다.");
                    } else if (userDate.userTG.value < 5000) {
                      return Text("${5000 - userDate.userTG.value} TG가 모자릅니다.");
                    } else {
                      return const Text("충전하기 (5000 TG)");
                    }
                  }(),
                ),
              ),
            ],
          ));
}
