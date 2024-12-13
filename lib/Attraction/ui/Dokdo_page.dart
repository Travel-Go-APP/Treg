import 'package:favicon/favicon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:travel_go/Attraction/function/attraction_detail.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xtyle/xtyle.dart';
import 'package:intl/intl.dart';

class DokdoPage extends StatefulWidget {
  @override
  State<DokdoPage> createState() => _DokdoPageState();
}

class _DokdoPageState extends State<DokdoPage> {
  final attractDetails = Get.put(attractDetail());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Colors.black,
                              width: MediaQuery.of(context).size.width * 0.01),
                        ),
                      ),
                      child: Image.asset(
                        "assets/images/Dokdo.png",
                        alignment: Alignment.center,
                        scale: MediaQuery.of(context).size.width * 0.007,
                        // width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height * 0.3,
                      )),
                  Positioned(
                      top: MediaQuery.of(context).padding.top,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.arrow_back_outlined,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                      )),
                ],
              ),
              // 명소 정보
              Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.015,
                      left: MediaQuery.of(context).size.width * 0.03),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          XtyleText(
                            "독도",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.07),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              color: Colors.grey),
                          XtyleText("대한민국 경상북도 울릉군 울릉읍 독도리",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.032,
                                  color: Colors.grey))
                        ],
                      ),
                    ],
                  )),
              Expanded(
                child: SingleChildScrollView(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        XtyleText(
                          """대한민국의 울릉도와 일본의 오키 제도 사이에 있으며, 울릉도에서 동남쪽으로 약 87 ㎞ 떨어져 있고 오키 제도에서는 서북쪽으로 약 157 ㎞ 떨어져 있다. 울릉도의 가시거리 한계와 독도의 거리가 거의 일치하여서, 평소에는 수증기, 해무(海霧)에 가려 잘 보이지 않더라도 날씨가 좋을 때면 열흘에 한 번 정도로 울릉도의 고지대에서 독도를 육안으로 관측할 수 있다. 보통은 울릉도의 정상인 성인봉을 떠올리지만 저동리의 내수전 일출전망대에서도 맑은 날에는 독도가 보인다고 한다. 다만 울릉도 본도의 날씨가 맑아도 독도 인근 해상에 구름 또는 안개가 끼면 도동리 독도전망대의 쌍안경을 동원해도 여지없이 보이지 않는다.

대한민국과 일본에서는 독도를 섬(island)으로 규정하지만, 국제해양법상 암초(rocks)로 분류된다. 섬을 "사람이 살며 경제 활동이 가능한 섬(island)"과 "그렇지 못한 암초(rocks)"로 구별하며, 독도가 국제법상 섬으로 인정받지 못하는 까닭은 사람이 살고는 있으나, 독도 안에서 스스로 경제 활동을 할 수 없기 때문이다. 다시 말해 섬에 마을을 건설하여 스스로 살 수 없다는 이야기. 섬의 정의에는 거주민뿐만 아니라 스스로 경제 활동을 할 수 있어야 한다는 단서가 붙기 때문에 섬으로 인정받지 못하고 있다.
                              """,
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              // wordSpacing: 0,
                              height:
                                  MediaQuery.of(context).size.width * 0.0038,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.044),
                        ),
                        // const SizedBox(height: 30),
                        // Container(
                        //   width: MediaQuery.of(context).size.width,
                        //   alignment: Alignment.centerLeft,
                        //   child: Image.asset("assets/images/openCode.jpeg",
                        //       scale: MediaQuery.of(context).size.width *
                        //           0.003),
                        // ),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(children: [
                            WidgetSpan(
                              child: XtyleText(
                                  "해당 내용은 '나무위키'에 적힌 내용을 이용하였으며, 상단 사진은 '공유마당'에서 자유이용으로 무료로 사용이 가능합니다.",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035)),
                            ),
                          ]),
                        ),
                        RichText(
                          text: TextSpan(children: [
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () async {
                                  if (await canLaunch(
                                      "https://namu.wiki/w/%EB%8F%85%EB%8F%84")) {
                                    await launch(
                                        "https://namu.wiki/w/%EB%8F%85%EB%8F%84");
                                  } else {
                                    throw 'Could not launch';
                                  }
                                },
                                child: XtyleText("\n내용 출처 : 나무위키",
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.038,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ),
                          ]),
                        ),
                        RichText(
                          text: TextSpan(children: [
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () async {
                                  if (await canLaunch(
                                      "https://gongu.copyright.or.kr/gongu/wrt/wrt/view.do?wrtSn=13299524&menuNo=200018")) {
                                    await launch(
                                        "https://gongu.copyright.or.kr/gongu/wrt/wrt/view.do?wrtSn=13299524&menuNo=200018");
                                  } else {
                                    throw 'Could not launch';
                                  }
                                },
                                child: XtyleText("사진 출처 : 권오철 - 독도 동도와 서도",
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.038,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(height: 50),
                      ],
                    )),
              ),
            ],
          ),
        ),
        Obx(
          () => Offstage(
            offstage: !attractDetails.networkDetail.value, // false면 감춰
            child: const Stack(children: <Widget>[
              //다시 stack
              Opacity(
                //뿌옇게~
                opacity: 0.1, //0.5만큼~
                child: ModalBarrier(
                    dismissible: false, color: Colors.black), //클릭 못하게~
              ),
              Center(
                child: CircularProgressIndicator(color: Colors.blue), //무지성 돌돌이~
              ),
            ]),
          ),
        )
      ],
    );
  }
}
