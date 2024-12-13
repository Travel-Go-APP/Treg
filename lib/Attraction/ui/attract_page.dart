import 'package:favicon/favicon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:travel_go/Attraction/function/attraction_detail.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xtyle/xtyle.dart';
import 'package:intl/intl.dart';

class attackPage extends StatefulWidget {
  final int? attractionId;
  final String? datetime;
  const attackPage({super.key, this.attractionId, this.datetime});

  @override
  State<attackPage> createState() => _attackPageState();
}

class _attackPageState extends State<attackPage> {
  final attractDetails = Get.put(attractDetail());
  late int? id = widget.attractionId;
  late DateTime? datetime;

  @override
  void initState() {
    super.initState();
    attractDetails.visitDetail(id!);
    datetime =
        widget.datetime != null ? DateTime.parse(widget.datetime!) : null;
  }

  @override
  Widget build(BuildContext context) {
    String formattedDateTime = datetime != null
        ? DateFormat('MM월 dd일 HH시 mm분').format(datetime!)
        : '날짜 정보 없음';

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Colors.black,
                              width: MediaQuery.of(context).size.width * 0.01),
                        ),
                      ),
                      child: attractDetails.imageUrl.isNotEmpty
                          ? Image.network(
                              "${attractDetails.imageUrl}",
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.33,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              "assets/images/Logo.png",
                              alignment: Alignment.center,
                              scale: MediaQuery.of(context).size.width * 0.007,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.3,
                            ),
                    ),
                  ),
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
                          Obx(() => XtyleText(
                                "${attractDetails.name}",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.07),
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              color: Colors.grey),
                          Obx(() => XtyleText(" ${attractDetails.address}",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.032,
                                  color: Colors.grey)))
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.schedule, color: Colors.grey),
                          XtyleText(" $formattedDateTime",
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
                    child: Obx(() => Column(
                          children: [
                            XtyleText(
                              "${attractDetails.description}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  // wordSpacing: 0,
                                  height: MediaQuery.of(context).size.width *
                                      0.0038,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.044),
                            ),
                            const SizedBox(height: 30),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.centerLeft,
                              child: Image.asset("assets/images/openCode.jpeg",
                                  scale: MediaQuery.of(context).size.width *
                                      0.003),
                            ),
                            const SizedBox(height: 10),
                            RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                  child: XtyleText(
                                      "해당 내용은 \'한국관광공사\'에서 제1유형으로 개방한 저작물을 이용하였으며, 해당 저작물은 '공공 데이터 포털' 에서 무료로 사용이 가능합니다.",
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.035)),
                                ),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (await canLaunch(
                                          "https://www.data.go.kr/data/15101578/openapi.do#layer-api-guide")) {
                                        await launch(
                                            "https://www.data.go.kr/data/15101578/openapi.do#layer-api-guide");
                                      } else {
                                        throw 'Could not launch';
                                      }
                                    },
                                    child: XtyleText("해당 사이트로 이동하기",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                        ))),
              ),
            ],
          ),
          // bottomNavigationBar: BottomAppBar(
          //   height: MediaQuery.of(context).size.height * 0.05,
          //   elevation: 5,
          //   color: Colors.white,
          //   child: Container(
          //     alignment: Alignment.center,
          //     child: const SizedBox(
          //         child: XtyleText(
          //             "해당 내용은 \'한국관광공사\'에서 제1유형으로 개방한 저작물을 이용하였으며, 해당 저작물은 \"공공 데이터 포털\"에서 무료로 사용이 가능합니다.")),
          //   ),
          // ),
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
