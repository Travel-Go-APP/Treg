import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:travel_go/Home/function/userController.dart';
import 'package:travel_go/Login/function/UserModel.dart';
import 'package:travel_go/Login/function/apple_login.dart';
import 'package:travel_go/Login/function/kakao_login.dart';
import 'package:travel_go/Login/ui/loginPage.dart';
import 'package:travel_go/main.dart';
import 'package:travel_go/package_Info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xtyle/xtyle.dart';
import 'package:intl/intl.dart';

class settingPage extends StatefulWidget {
  const settingPage({super.key});

  @override
  State<settingPage> createState() => _settingPageState();
}

class _settingPageState extends State<settingPage> {
  var loginModel = UserModel(Kakao_Login()); // 카카오 로그인
  final userDate = Get.put(userController()); // 유저 컨트롤러
  final AppleLogin appleLogin = AppleLogin();
  final packinfos = Get.put(packinfo()); // 걸음수 컨트롤러
  String snsEmail = "";
  late FToast fToast;

  @override
  void initState() {
    userEmail();
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  _showToast(String text) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check),
          const SizedBox(
            width: 12.0,
          ),
          XtyleText(text),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  Future<void> userEmail() async {
    String? email = await appleLogin.getEmailPrefix();
    setState(() {
      if (email != null && email.split('@')[1] == "appleid.com") {
        snsEmail = "Apple";
      } else {
        snsEmail = "Kakao";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String tgCount = NumberFormat("###,###").format(userDate.userTG.value);
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(children: [
            const WidgetSpan(child: Icon(Icons.settings)),
            WidgetSpan(
              child: XtyleText(
                " 설정",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05),
              ),
            ),
          ]),
        ),
        centerTitle: true,
      ),
      body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const XtyleText("닉네임", style: TextStyle(fontSize: 18)),
                  XtyleText(userDate.nickname.value),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const XtyleText("레벨", style: TextStyle(fontSize: 18)),
                  XtyleText(
                      "${userDate.userLevel.value} LV (${userDate.percentage.value.toStringAsFixed(2)}%)"),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const XtyleText("TG 보유량", style: TextStyle(fontSize: 18)),
                  XtyleText("$tgCount TG"),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const XtyleText("로그인 환경", style: TextStyle(fontSize: 18)),
                  XtyleText(snsEmail),
                ],
              ),
              const SizedBox(height: 30),
              const Divider(height: 1),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const XtyleText("앱 버전", style: TextStyle(fontSize: 18)),
                  XtyleText(packinfos.version),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const XtyleText("저작권자", style: TextStyle(fontSize: 18)),
                  TextButton(
                      onPressed: () => _showLinkDialog(context),
                      child: const XtyleText("더보기")),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 187, 84)),
                    onPressed: () async {
                      logout();
                    },
                    child: const XtyleText("로그아웃",
                        style: TextStyle(color: Colors.black))),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 50),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                    onPressed: () {
                      userExit();
                    },
                    child: const XtyleText("회원 탈퇴",
                        style: TextStyle(color: Colors.white))),
              ),
            ],
          )),
    );
  }

  Future<void> logout() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: const XtyleText(
                "로그아웃",
                textAlign: TextAlign.center,
              ),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  XtyleText("수락하면 계정이 로그아웃되고, \n 앱이 종료됩니다."),
                  XtyleText("정말로 로그아웃 하시겠습니까?",
                      style: TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.bold)),
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                Container(
                  width: context.width * 0.25,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 110, 162, 251)),
                      onPressed: () {
                        Navigator.of(context).pop(); // 알림창을 닫고
                      },
                      child: const XtyleText("취소",
                          style: TextStyle(color: Colors.white))),
                ),
                Container(
                  width: context.width * 0.25,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 253, 142, 142)),
                      onPressed: () async {
                        if (snsEmail == "Kakao") {
                          await loginModel.logout();
                          await appleLogin.removeEmailPrefix();
                          _showToast("성공적으로 로그아웃 되었습니다");
                          Timer(const Duration(milliseconds: 1000), () {
                            Platform.isAndroid
                                ? SystemNavigator.pop()
                                : exit(0);
                          });
                        } else if (snsEmail == "Apple") {
                          await appleLogin.removeEmailPrefix();
                          await appleLogin.removeIdentityToken();
                          _showToast("성공적으로 로그아웃 되었습니다");
                          Timer(const Duration(milliseconds: 1000), () {
                            Platform.isAndroid
                                ? SystemNavigator.pop()
                                : exit(0);
                          });
                        }
                      },
                      child: const XtyleText("수락",
                          style: TextStyle(color: Colors.white))),
                ),
              ],
            ));
  }

  Future<void> userExit() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: const XtyleText(
                "회원탈퇴",
                textAlign: TextAlign.center,
              ),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  XtyleText("수락하면 모든 정보가 즉시 삭제되며,\n삭제 후 복구 불가능합니다."),
                  XtyleText("정말로 탈퇴하시겠습니까?",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                Container(
                  width: context.width * 0.25,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 110, 162, 251)),
                      onPressed: () {
                        Navigator.of(context).pop(); // 알림창을 닫고
                      },
                      child: const XtyleText("취소",
                          style: TextStyle(color: Colors.white))),
                ),
                Container(
                  width: context.width * 0.25,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 253, 142, 142)),
                      onPressed: () async {
                        if (snsEmail == "Kakao") {
                          await loginModel.logout();
                          await userDate.userDelete();
                          await appleLogin.removeEmailPrefix();
                          _showToast("성공적으로 회원탈퇴 되었습니다");
                          Timer(const Duration(milliseconds: 1000), () {
                            Platform.isAndroid
                                ? SystemNavigator.pop()
                                : exit(0);
                          });
                        } else if (snsEmail == "Apple") {
                          await userDate.userDelete();
                          await appleLogin.removeEmailPrefix();
                          await appleLogin.removeIdentityToken();
                          _showToast("성공적으로 회원탈퇴 되었습니다");
                          Timer(const Duration(milliseconds: 1000), () {
                            Platform.isAndroid
                                ? SystemNavigator.pop()
                                : exit(0);
                          });
                        }
                      },
                      child: const XtyleText("수락",
                          style: TextStyle(color: Colors.white))),
                ),
              ],
            ));
  }

  void _showLinkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Column(
            children: [
              XtyleText('저작자 표시 리스트', style: TextStyle(fontSize: 15)),
              XtyleText("클릭시, 해당페이지로 이동합니다.", style: TextStyle(fontSize: 12))
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite, // 다이얼로그의 최대 너비 설정
              height: 300.0, // 원하는 높이 지정
              child: ListView(
                children: [
                  _linkItem("assets/images/events/wallet.png", "Freepik",
                      "https://www.flaticon.com/kr/free-icon/wallet_855279"),
                  _linkItem("assets/images/events/trap.png", "Freepik",
                      "https://www.flaticon.com/kr/free-icon/no-trap_8672634?term=%ED%95%A8%EC%A0%95&page=1&position=3&origin=search&related_id=8672634"),
                  _linkItem("assets/images/events/TG100.png", "Freepik",
                      "https://www.flaticon.com/kr/free-icon/coin_533544"),
                  _linkItem("assets/images/events/LEVEL_1_UP.png", "Freepik",
                      "https://www.flaticon.com/kr/free-icon/star_1146243?term=%EB%B3%84%EB%98%A5%EB%B3%84&related_id=1146243"),
                  _linkItem("assets/images/event.png", "Freepik",
                      "https://www.flaticon.com/kr/free-icon/question-mark_5726686"),
                  _linkItem("assets/images/gift1.png", "Freepik",
                      "https://www.flaticon.com/kr/free-icon/pouch_5448082"),
                  _linkItem("assets/images/gift2.png", "Freepik",
                      "https://www.flaticon.com/kr/free-icon/package_5470273"),
                  _linkItem("assets/images/camera.png", "Freepik",
                      "https://www.flaticon.com/kr/free-icon/search_3435091"),
                  _linkItem("assets/images/events/police.png", "Freepik",
                      "https://www.flaticon.com/kr/free-icon/police-station_308023"),
                  _linkItem("assets/images/search.png", "Freepik",
                      "https://www.flaticon.com/kr/free-icon/investigation_8858997?term=%EC%A1%B0%EC%82%AC&related_id=8858997"),
                  _linkItem("assets/images/picture.png", "Freepik",
                      "https://www.flaticon.com/kr/free-icon/photo_11324939?term=%EC%82%AC%EC%A7%84&related_id=11324939"),
                  _linkItem("assets/images/gift3.png", "Pixel Buddha",
                      "https://www.flaticon.com/kr/free-icon/gift_214305"),
                  _linkItem("assets/images/camera.png", "PixelVerse",
                      "https://www.flaticon.com/kr/free-icon/camera_11475150"),
                  _linkItem("assets/images/gift4.png", "Smashicons",
                      "https://www.flaticon.com/kr/free-icon/treasure_1355876"),
                  _linkItem("assets/images/events/charge_50.png", "monkik",
                      "https://www.flaticon.com/kr/free-icon/charging_1995998"),
                  _linkItem("assets/images/events/charge_100.png", "monkik",
                      "https://www.flaticon.com/kr/free-icon/gas-station_887185"),
                  _linkItem("assets/images/events/EXP500.png", "monkik",
                      "https://www.flaticon.com/kr/free-icon/gym_1421388"),
                  _linkItem("assets/images/events/still.png", "monkik",
                      "https://www.flaticon.com/kr/free-icon/robbery_1576476"),
                  _linkItem("assets/images/events/SearchUP.png", "Eucalyp",
                      "https://www.flaticon.com/kr/free-icon/energy-drink_4496649"),
                  _linkItem("assets/images/events/Dealer.png", "Eucalyp",
                      "https://www.flaticon.com/kr/free-icon/croupier_2980165?term=%EC%83%81%EC%9D%B8&page=1&position=48&origin=search&related_id=2980165"),
                  _linkItem(
                      "assets/images/events/EXP100.png",
                      "photo3idea_studio",
                      "https://www.flaticon.com/kr/free-icon/reading-book_5805445"),
                  _linkItem(
                      "assets/images/events/lottery.png",
                      "Nikita Golubev",
                      "https://www.flaticon.com/free-icon/lottery-game_2004441"),
                  _linkItem("assets/images/events/SearchDown.png", "Dimas Anom",
                      "https://www.flaticon.com/kr/free-icon/loss-of-appetite_7959703"),
                  _linkItem("assets/images/events/TG300.png", "flatart_icons",
                      "https://www.flaticon.com/kr/free-icon/celebration_3278094?term=%EC%B6%95%ED%95%98&page=2&position=25&origin=search&related_id=3278094"),
                  _linkItem(
                      "assets/images/ranks/Rank1.png",
                      "Md Tanvirul Haque",
                      "https://www.flaticon.com/kr/free-icon/1st-prize_11173312?term=1%EB%93%B1&page=1&position=2&origin=search&related_id=11173312"),
                  _linkItem(
                      "assets/images/ranks/Rank2.png",
                      "Md Tanvirul Haque",
                      "https://www.flaticon.com/kr/free-icon/2nd-place_11173316?term=2&related_id=11173316"),
                  _linkItem(
                      "assets/images/ranks/Rank3.png",
                      "Md Tanvirul Haque",
                      "https://www.flaticon.com/kr/free-icon/3rd-place_11173320?term=3&related_id=11173320"),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  Widget _linkItem(String title, String nick, String url) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Image.asset(
                title,
                scale: MediaQuery.of(context).size.width * 0.05,
              ),
              const SizedBox(width: 10),
              XtyleText(nick)
            ],
          )),
    );
  }
}
