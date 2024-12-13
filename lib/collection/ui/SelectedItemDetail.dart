import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_go/collection/function/itemController.dart';
import 'package:xtyle/xtyle.dart';

Future<void> selectedItemDetail(
    BuildContext context,
    int number,
    int rank,
    String name,
    String summary,
    String description,
    int piece,
    int chageTG,
    int chageEXP) async {
  String ranked = "";
  switch (rank) {
    case 1:
      ranked = "일반";
    case 2:
      ranked = "희귀";
    case 3:
      ranked = "영웅";
    case 4:
      ranked = "전설";
    case 5:
      ranked = "지역";
    default:
      ranked = "";
  }

  showDialog(
      context: context,
      builder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: <Widget>[
                  DefaultTextStyle(
                      style: const TextStyle(),
                      child: RichText(
                          text: TextSpan(
                        children: [
                          TextSpan(
                            text: name,
                            style: TextStyle(
                              fontFamily: 'GmarketSans',
                              fontSize: MediaQuery.of(context).size.width * 0.1,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 3
                                ..color = ranked == "일반"
                                    ? const Color.fromARGB(255, 39, 39, 39)
                                    : ranked == "희귀"
                                        ? Colors.green
                                        : ranked == "영웅"
                                            ? Colors.purple
                                            : ranked == "전설"
                                                ? const Color.fromARGB(
                                                    255, 180, 108, 0)
                                                : const Color.fromARGB(255, 203,
                                                    64, 0), // <-- Border color
                            ),
                          ),
                        ],
                      ))),
                  DefaultTextStyle(
                      style: const TextStyle(),
                      child: RichText(
                          text: TextSpan(
                        children: [
                          TextSpan(
                            text: name,
                            style: TextStyle(
                              fontFamily: 'GmarketSans',
                              fontSize: MediaQuery.of(context).size.width * 0.1,
                              fontWeight: FontWeight.bold,
                              color: ranked == "일반"
                                  ? Colors.grey
                                  : ranked == "희귀"
                                      ? const Color.fromARGB(255, 179, 230, 181)
                                      : ranked == "영웅"
                                          ? const Color.fromARGB(
                                              255, 211, 143, 223)
                                          : ranked == "전설"
                                              ? const Color.fromARGB(
                                                  255, 255, 183, 75)
                                              : const Color.fromARGB(
                                                  255, 255, 158, 83),
                            ),
                          ),
                        ],
                      ))),
                ],
              ),
              AlertDialog(
                  contentPadding: const EdgeInsets.only(
                      left: 30, right: 30, top: 30, bottom: 30),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(
                        color: ranked == "일반"
                            ? const Color.fromARGB(255, 39, 39, 39)
                            : ranked == "희귀"
                                ? Colors.green
                                : ranked == "영웅"
                                    ? Colors.purple
                                    : ranked == "전설"
                                        ? const Color.fromARGB(255, 180, 108, 0)
                                        : const Color.fromARGB(255, 203, 64,
                                            0), // <-- Border color
                        width: 3.0),
                  ),
                  title: Image.asset("assets/item/$number.png",
                      scale: MediaQuery.of(context).size.width * 0.003),
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      XtyleText("- $ranked 아이템 -",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: ranked == "일반"
                                  ? const Color.fromARGB(255, 39, 39, 39)
                                  : ranked == "희귀"
                                      ? Colors.green
                                      : ranked == "영웅"
                                          ? Colors.purple
                                          : ranked == "전설"
                                              ? const Color.fromARGB(
                                                  255, 180, 108, 0)
                                              : const Color.fromARGB(
                                                  255, 203, 64, 0))),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      summary != "string"
                          ? XtyleText("\"$summary\"",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 14))
                          : Container(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      XtyleText(
                        description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      piece < 10
                          ? XtyleText("도감에 등록까지 ${10 - piece}개 남았습니다",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                              textAlign: TextAlign.center)
                          : (piece >= 10 && chageTG != 0)
                              ? XtyleText("이미 획득해서, $chageTG TG를 획득합니다.",
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                  textAlign: TextAlign.center)
                              : (piece >= 10 && chageEXP != 0)
                                  ? XtyleText("이미 획득해서, $chageEXP EXP를 획득합니다.",
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                      textAlign: TextAlign.center)
                                  : const XtyleText("조각이 완성되어, 도감에 등록되었습니다",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                      textAlign: TextAlign.center),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // 알림창을 닫고
                            },
                            child: XtyleText("확인",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05))),
                      )
                    ],
                  )),
            ],
          ));
}
