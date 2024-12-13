import 'package:flutter/material.dart';
import 'package:xtyle/xtyle.dart';

Future<void> getitem(BuildContext context, String ranked) async {
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
                            text: "$ranked 아이템 !",
                            style: TextStyle(
                              fontFamily: 'GmarketSans',
                              fontSize: MediaQuery.of(context).size.width * 0.1,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 3
                                ..color = ranked == "일반"
                                    ? Colors.black
                                    : ranked == "희귀"
                                        ? Colors.green
                                        : ranked == "영웅"
                                            ? Colors.purple
                                            : ranked == "전설"
                                            ? Colors.orange
                                            : Colors.red, // <-- Border color
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
                            text: ranked,
                            style: TextStyle(
                              fontFamily: 'GmarketSans',
                              fontSize: MediaQuery.of(context).size.width * 0.1,
                              fontWeight: FontWeight.bold,
                              color: ranked == "일반"
                                  ? Colors.grey
                                  : ranked == "희귀"
                                      ? const Color.fromARGB(255, 179, 230, 181)
                                      : ranked == "영웅"
                                          ? const Color.fromARGB(255, 211, 143, 223)
                                          : ranked == "전설"
                                          ? const Color.fromARGB(255, 255, 210, 142)
                                          : const Color.fromARGB(255, 247, 173, 168),
                            ),
                          ),
                          TextSpan(
                            text: " 아이템 !",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'GmarketSans',
                              fontSize: MediaQuery.of(context).size.width * 0.1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ))),
                ],
              ),
              AlertDialog(
                  title: const XtyleText("한라봉", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                      Image.asset("assets/item/한라봉.png", scale: MediaQuery.of(context).size.width * 0.01),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                      const XtyleText("\"내 귤 아임니다\"", style: TextStyle(color: Color.fromARGB(255, 124, 124, 124))),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                      const XtyleText("제주도에서 만날 수 있는 \n 맛있는 한라봉이다.", textAlign: TextAlign.center),
                    ],
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.06,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // 알림창을 닫고
                    },
                    child: XtyleText("확인", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05))),
              )
            ],
          ));
}
