import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:get/get.dart';
import 'package:travel_go/Attraction/function/attraction_info.dart';
import 'package:travel_go/Attraction/function/visitList_info.dart';
import 'package:travel_go/Attraction/ui/Dokdo_page.dart';
import 'package:travel_go/Attraction/ui/attract_page.dart';
import 'package:travel_go/Attraction/ui/dialog_Hint.dart';
import 'package:travel_go/Login/function/apple_login.dart';
import 'package:xtyle/xtyle.dart';
import 'package:http/http.dart' as http;

class countryPage extends StatefulWidget {
  final String? country;
  final int? percent;

  const countryPage({super.key, this.country, this.percent});

  @override
  State<countryPage> createState() => _countryPageState();
}

class _countryPageState extends State<countryPage> {
  final visitinfo = Get.put(visitInfo());
  final attractInfos = Get.put(attractInfo());
  late ScrollController? _scrollController;
  bool lastStatus = true;
  late String? name = widget.country;
  late int? percent = widget.percent;

  @override
  void initState() {
    super.initState();
    visitinfo.fetchVisitList(name!);
    _scrollController = ScrollController()
      ..addListener(() {
        if (_isShrink != lastStatus) {
          setState(() {
            lastStatus = _isShrink;
          });
        }
      }); // 상단 스크롤 검사
  }

  bool get _isShrink {
    return _scrollController != null &&
        _scrollController!.hasClients &&
        _scrollController!.offset > kToolbarHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: countryAppbar(), // 지역별 명소 상단
          body: countryList(),
          floatingActionButton: name == "경상북도"
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * 0.22,
                  height: MediaQuery.of(context).size.width * 0.22,
                  child: FloatingActionButton.extended(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100), // 둥글게 만들기
                    ),
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      Get.to(() => DokdoPage());
                    },
                    label: Column(
                      children: [
                        Icon(Icons.landscape,
                            color: const Color.fromARGB(255, 123, 228, 126),
                            size: MediaQuery.of(context).size.width * 0.1),
                        const XtyleText("독도",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )
              : null,
        ),
        Obx(
          () => Offstage(
            offstage: !visitinfo.networkVisitList.value, // false면 감춰
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

  // 지역별 명소 상단
  AppBar countryAppbar() {
    return AppBar(
      backgroundColor: _isShrink ? Colors.green : Colors.white,
      shadowColor: Colors.black,
      title: XtyleText(name ?? "",
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05)),
      centerTitle: false,
      actions: [
        Container(
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(children: [
                  WidgetSpan(
                      child: XtyleText(
                    "수집률 : ",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.045),
                  )),
                  WidgetSpan(
                      child: XtyleText(
                    "$percent%",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.045,
                        color: _isShrink
                            ? Colors.white
                            : attractInfos.attractChageColor(percent!)),
                  )),
                ]),
              ),
              // Obx(() => ElevatedButton(
              //       onPressed: attractInfos.openCheck.value
              //           ? () async {
              //               await attractInfos.updateHint();
              //             }
              //           : null,
              //       style: ElevatedButton.styleFrom(
              //           shape: const CircleBorder(),
              //           padding: const EdgeInsets.all(0)),
              //       child: const Icon(Icons.delete),
              //     ))
            ],
          ),
        ),
      ],
    );
  }

  // 지역별 명소 리스트
  Widget countryList() {
    double margin1 = MediaQuery.of(context).size.width * 0.05;
    double margin2 = MediaQuery.of(context).size.width * 0.02;

    return Obx(() => ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: visitinfo.visitList.length,
          itemBuilder: (context, index) {
            final visit =
                visitinfo.visitList[index]['attractionCommonResponse'];

            String address = visitinfo.visitList[index]
                ['attractionCommonResponse']['address'];

            return Container(
                margin: EdgeInsets.only(
                    left: margin1,
                    right: margin1,
                    top: margin2,
                    bottom: margin2),
                height: MediaQuery.of(context).size.height * 0.22,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02,
                      ),
                      margin: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.02),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          elevation: 2,
                          // backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width * 0.05),
                          ),
                          side: BorderSide(
                            color: Colors.black,
                            width: MediaQuery.of(context).size.width * 0.005,
                          ),
                        ),
                        onPressed: () {
                          Get.to(() => attackPage(
                              attractionId: visit['attractionId'],
                              datetime: visitinfo.visitList[index]
                                  ['visitTime']));
                        },
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.05),
                              child: visit['attractionImageUrl'].isNotEmpty
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      child: Image.network(
                                        '${visit['attractionImageUrl']}',
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          // color: Colors.white,
                                          padding: const EdgeInsets.all(3),
                                          child: Image.asset(
                                            "assets/images/Logo.png",
                                            scale: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.01,
                                          ),
                                        ),
                                        const XtyleText("이미지가 없습니다..")
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Row(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius:
                                      MediaQuery.of(context).size.width * 0.045,
                                  child: XtyleText("${index + 1}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.02),
                              width: MediaQuery.of(context).size.width *
                                  (visit['attractionName'].toString().length)
                                      .toDouble() *
                                  0.042,
                              height: MediaQuery.of(context).size.height * 0.04,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width * 0.02),
                                  border: Border.all(
                                      width: MediaQuery.of(context).size.width *
                                          0.005,
                                      color: Colors.black)),
                              child: XtyleText("${visit['attractionName']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        )),
                  ],
                ));
          },
        ));
  }
}
