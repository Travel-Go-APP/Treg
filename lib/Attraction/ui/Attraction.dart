import 'dart:async';
import 'dart:io';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:countries_world_map/countries_world_map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:travel_go/Attraction/function/attraction_info.dart';
import 'package:travel_go/Attraction/ui/country_page.dart';
import 'package:xtyle/xtyle.dart';

class attractionPage extends StatefulWidget {
  const attractionPage({super.key});

  @override
  State<attractionPage> createState() => _attractionPageState();
}

class _attractionPageState extends State<attractionPage> {
  final attractInfos = Get.put(attractInfo());
  late ScrollController? _scrollController;
  bool lastStatus = true;
  late SMapSouthKoreaColors _mapColors; // 초기 값 설정

  @override
  void initState() {
    super.initState();
    // 명소 수집률 가져오기
    attractInfos.updateAreaList();
    // 스크롤 감지
    _scrollController = ScrollController()
      ..addListener(() {
        if (_isShrink != lastStatus) {
          setState(() {
            lastStatus = _isShrink;
          });
        }
      }); // 상단 스크롤 검사
  }

  @override
  void dispose() {
    attractInfos.ResetValue();
    super.dispose();
  }

  bool get _isShrink {
    return _scrollController != null &&
        _scrollController!.hasClients &&
        _scrollController!.offset >
            (MediaQuery.of(context).size.height * 0.8 - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            backgroundColor: Colors.white,
            body: CustomScrollView(
              controller: _scrollController,
              slivers: [
                appbar(),
                scrollWidget(),
                countryList(),
              ],
            )),
        Obx(
          () => Offstage(
            offstage: !attractInfos.networkAttractionMain.value, // false면 감춰
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

  // 상단
  SliverAppBar appbar() {
    return SliverAppBar(
      backgroundColor:
          _isShrink ? Colors.green : const Color.fromARGB(255, 163, 220, 253),
      shadowColor: Colors.black, // 상단 스크롤 했을때 그림자
      floating: false, // 스크롤을 했을시 bottom만 보이게 하고 싶을때
      pinned: true, // 스크롤을 했을시, 상단이 고정되게 하고 싶을때
      stretch: true, // 오버 스크롤시 영역을 채우는가?
      title: RichText(
        text: TextSpan(children: [
          const WidgetSpan(child: Icon(Icons.account_balance_outlined)),
          WidgetSpan(
            child: XtyleText(
              " 기록",
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),
            ),
          ),
        ]),
      ),
      centerTitle: true,
      expandedHeight: MediaQuery.of(context).size.height * 0.75,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Container(
            color: const Color.fromARGB(255, 163, 220, 253),
            margin: Platform.isAndroid
                ? EdgeInsets.only(top: MediaQuery.of(context).padding.top * 2.5)
                : EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top * 1.5),
            child: Column(
              children: [
                koreanMaps(), // 대한민국 지도
                Column(
                  children: [
                    percentText(),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005),
                    percentBar(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    // completeGift(),
                  ],
                )
              ],
            )),
      ),
      bottom: _isShrink
          ? PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.04),
              child: Container(
                  margin:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const XtyleText("수집률",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          LinearPercentIndicator(
                            barRadius: Radius.circular(
                                MediaQuery.of(context).size.width * 0.05),
                            width: MediaQuery.of(context).size.width * 0.71,
                            lineHeight:
                                MediaQuery.of(context).size.height * 0.015,
                            backgroundColor: Colors.black,
                          ),
                          Obx(
                            () => LinearPercentIndicator(
                              barRadius: Radius.circular(
                                  MediaQuery.of(context).size.width * 0.05),
                              width: MediaQuery.of(context).size.width * 0.7,
                              lineHeight:
                                  MediaQuery.of(context).size.height * 0.01,
                              percent: attractInfos.percentValue.value,
                              progressColor: attractInfos.attractChageColor(
                                  (attractInfos.percentValue.value * 100)
                                      .toInt()),
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Obx(() => XtyleText(
                            "${(attractInfos.percentValue * 100).toInt()}%",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ))
                    ],
                  )))
          : null,
    );
  }

  // 하단 스크롤 연결
  SliverToBoxAdapter scrollWidget() {
    return SliverToBoxAdapter(
      child: Container(
        color: const Color.fromARGB(255, 163, 220, 253),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: Colors.black,
                      width: MediaQuery.of(context).size.width * 0.005),
                ),
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft:
                      Radius.circular(MediaQuery.of(context).size.width * 0.05),
                  topRight:
                      Radius.circular(MediaQuery.of(context).size.width * 0.05),
                ),
              ),
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01),
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.01)),
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.01,
              ),
            ),
          ],
        ),
      ),
    );
  }

// 지역 리스트
  Widget countryList() {
    return Obx(() {
      // 지역 리스트가 비어있는 경우 빈 컨테이너 반환
      if (attractInfos.countries.isEmpty ||
          attractInfos.countryGet.isEmpty ||
          attractInfos.countryCount.isEmpty) {
        return Container();
      }

      return SliverList.builder(
        itemCount: attractInfos.countries.length,
        itemBuilder: (context, index) {
          // 인덱스가 범위를 벗어나지 않도록 확인
          if (index >= attractInfos.countryGet.length ||
              index >= attractInfos.countryCount.length) {
            return Container(); // 인덱스가 유효하지 않은 경우 빈 컨테이너 반환
          }

          int localPercent = (attractInfos.countryGet[index] /
                  attractInfos.countryCount[index] *
                  100)
              .toInt(); // 지역별 완성 수집률
          int localCount = attractInfos.countryCount[index]; // 지역별 총 개수
          int localGet = attractInfos.countryGet[index]; // 지역별 수집한 개수

          return Container(
            height: MediaQuery.of(context).size.height * 0.08,
            margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.005),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    side: const BorderSide(color: Colors.white)),
                onPressed: () {
                  Get.to(() => countryPage(
                        country: attractInfos.areas[index],
                        percent: localPercent,
                      ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: localPercent == 100
                                  ? Colors.green
                                  : Colors.grey,
                              maxRadius:
                                  MediaQuery.of(context).size.height * 0.022,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              maxRadius:
                                  MediaQuery.of(context).size.height * 0.02,
                              child: Icon(Icons.check,
                                  color: localPercent == 100
                                      ? Colors.green
                                      : Colors.transparent),
                            ),
                          ],
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03),
                        XtyleText(attractInfos.areas[index],
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.055,
                                color: localPercent == 100
                                    ? Colors.green
                                    : Colors.black,
                                fontWeight: localPercent == 100
                                    ? FontWeight.w700
                                    : FontWeight.w300)),
                      ],
                    ),
                    RichText(
                      text: TextSpan(children: [
                        WidgetSpan(
                            child: XtyleText(
                          "$localPercent%",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.045,
                            fontFamily: 'GmarketSans',
                            color: attractInfos.attractChageColor(localPercent),
                          ),
                        )),
                        WidgetSpan(
                            child: XtyleText(
                          "($localGet/$localCount)",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                              fontFamily: 'GmarketSans',
                              color: Colors.grey),
                        )),
                      ]),
                    ),
                  ],
                )),
          );
        },
      );
    });
  }

  // 대한민국 지도
  Widget koreanMaps() {
    return Stack(
      children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.6,
            margin: EdgeInsets.only(
                right: MediaQuery.of(context).size.height * 0.03),
            child: Obx(
              () => SimpleMap(
                instructions: SMapSouthKorea.instructions,
                countryBorder: const CountryBorder(
                    color: Color.fromARGB(130, 255, 255, 255)), // 도시 경계선
                colors: attractInfos.Mapcolor().toMap(),
                // callback: (id, name, tapDetails) {
                //   print("$name : $id"); // 이동 가능 할듯?
                // },
              ),
            )),
        // Positioned(
        //   right: MediaQuery.of(context).size.width * 0.08,
        //   bottom: MediaQuery.of(context).size.height * 0.06,
        //   child: Container(
        //       decoration: BoxDecoration(
        //           boxShadow: const [
        //             BoxShadow(
        //               color: Colors.green,
        //               spreadRadius: 1,
        //               blurRadius: 5,
        //               offset: Offset(0, 0),
        //             ),
        //           ],
        //           border: Border.all(width: 2, color: Colors.green),
        //           borderRadius: BorderRadius.circular(
        //             MediaQuery.of(context).size.width * 0.03,
        //           )),
        //       margin: EdgeInsets.only(
        //           right: MediaQuery.of(context).size.width * 0.05,
        //           bottom: MediaQuery.of(context).size.width * 0.05),
        //       width: MediaQuery.of(context).size.width * 0.2,
        //       height: MediaQuery.of(context).size.width * 0.2,
        //       child: ClipRRect(
        //         borderRadius: BorderRadius.circular(
        //             MediaQuery.of(context).size.width * 0.025),
        //         child: InkWell(
        //           onTap: () {
        //             print("터치");
        //           },
        //           child: Image.asset(
        //             'assets/images/Dokdo.png',
        //             fit: BoxFit.cover,
        //             // color: Colors.grey,
        //             // colorBlendMode: BlendMode.color,
        //           ),
        //         ),
        //       )),
        // )
      ],
    );
  }

  // 현재 수집률 (텍스트)
  Widget percentText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        XtyleText("전체 수집률",
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.bold)),
        Obx(() => AnimatedFlipCounter(
              curve: Curves.easeInOutQuad,
              wholeDigits: 2,
              value: (attractInfos.percentValue.value * 100).toInt(),
              prefix: " : ",
              suffix: "%",
              duration: const Duration(milliseconds: 2500), // 퍼센트와 시간을 맞추기 위해
              textStyle: TextStyle(
                  color: attractInfos.attractChageColor(
                      (attractInfos.percentValue.value * 100).toInt()),
                  fontFamily: 'GmarketSans',
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.bold),
            )),
      ],
    );
  }

  // 현재 수집률 (퍼센트)
  Widget percentBar() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Obx(() => LinearPercentIndicator(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.04,
                  right: MediaQuery.of(context).size.width * 0.04),
              lineHeight: MediaQuery.of(context).size.height * 0.03,
              progressColor: attractInfos.attractChageColor(
                  (attractInfos.percentValue.value * 100).toInt()),
              barRadius:
                  Radius.circular(MediaQuery.of(context).size.width * 0.05),
              backgroundColor: Colors.white,
            )),
        Obx(() => LinearPercentIndicator(
              center: XtyleText(
                "${attractInfos.nowCountry} / ${attractInfos.allCountry}",
                style:
                    const TextStyle(color: Color.fromARGB(255, 102, 102, 102)),
              ),
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05),
              curve: Curves.easeInOutQuad,
              animation: true,
              animationDuration: 2500,
              lineHeight: MediaQuery.of(context).size.height * 0.025,
              percent: attractInfos.percentValue.value,
              progressColor: attractInfos.attractChageColor(
                  (attractInfos.percentValue.value * 100).toInt()),
              barRadius:
                  Radius.circular(MediaQuery.of(context).size.width * 0.05),
              backgroundColor: Colors.white,
            )),
      ],
    );
  }

  // 수집 보상
  Widget completeGift() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.05,
      child: Tooltip(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
          richMessage: const TextSpan(children: [
            WidgetSpan(
                child: XtyleText("개발자의 편지",
                    style: TextStyle(color: Colors.orange)))
          ]),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(0)),
              onPressed: null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const XtyleText("500개 수집 보상 :"),
                  Image.asset(
                    "assets/images/gift3.png",
                    scale: MediaQuery.of(context).size.height * 0.03,
                  ),
                ],
              ))),
    );
  }
}
