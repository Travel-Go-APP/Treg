import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:travel_go/Achievements/ui/achievements.dart';
import 'package:travel_go/Home/function/StepCounterAndroidController.dart';
import 'package:travel_go/Home/function/StepCounterIOSController.dart';
import 'package:travel_go/Home/function/examine.dart';
import 'package:travel_go/Home/function/userController.dart';
import 'package:travel_go/Home/ui/dialog/dialog_search.dart';
import 'package:travel_go/Home/ui/event_examine.dart';
import 'package:travel_go/Route/ui/routePage.dart';
import 'package:travel_go/store/ui/bottomNav_store.dart';
import 'package:travel_go/Attraction/ui/Attraction.dart';
import 'package:travel_go/Home/function/Geolocation.dart';
import 'package:travel_go/Home/function/db_steps.dart';
import 'package:travel_go/Rank/ui/Rank.dart';
import 'package:travel_go/collection/ui/bottomNav_item.dart';
import 'package:travel_go/package_Info.dart';
import 'package:travel_go/Home/ui/statusBar.dart';
import 'package:travel_go/Home/ui/dialog/dialog_level.dart';
import 'package:travel_go/Home/ui/menu.dart';
import 'package:travel_go/setting.dart';
import 'package:xtyle/xtyle.dart';
import 'package:http/http.dart' as http;

class logined_Page extends StatefulWidget {
  const logined_Page({super.key});

  @override
  State<logined_Page> createState() => _logined_PageState();
}

class _logined_PageState extends State<logined_Page> {
  final stepdb = Get.put(dbSteps());
  final packinfos = Get.put(packinfo()); // 걸음수 컨트롤러
  final examines = Get.put(examine()); // 게이지 컨트롤러
  final naverMap = Get.put(LatLngController()); // 네이버 지도 컨트롤러
  bool cameraMove = false; // 카메라 이동이 있었는가?
  final events = Get.put(event()); // 이벤트 컨트롤러
  final userDate = Get.put(userController()); // 유저 컨트롤러
  final statusBars = Get.put(statusBar()); // 레벨 관련
  int moveCount = 0;
  double levelPercent = 0.95;

  bool openMenu = false;

  late Timer _timer;

  // final List<String> name = <String>["상점", "기록", "아이템", "경로", "랭킹", "설정"];
  final List<String> name = <String>["상점", "기록", "아이템", "랭킹", "설정"];
  // final List<IconData> icons = <IconData>[
  //   Icons.store,
  //   Icons.account_balance_outlined,
  //   Icons.auto_awesome_outlined,
  //   Icons.navigation_outlined,
  //   Icons.trending_up_outlined,
  //   Icons.settings
  // ];
  final List<IconData> icons = <IconData>[
    Icons.store,
    Icons.account_balance_outlined,
    Icons.auto_awesome_outlined,
    Icons.trending_up_outlined,
    Icons.settings
  ];
  //   final List<Color> colors = <Color>[
  //   Colors.red,
  //   Colors.green,
  //   const Color.fromARGB(255, 207, 187, 0),
  //   Colors.blue,
  //   Colors.orange,
  //   Colors.grey
  // ];
  final List<Color> colors = <Color>[
    Colors.red,
    Colors.green,
    const Color.fromARGB(255, 207, 187, 0),
    Colors.orange,
    Colors.grey
  ];
  //   final List page = [
  //   const bottomNavStorePage(),
  //   const attractionPage(),
  //   const bottomNavItemPage(),
  //   const routePage(),
  //   const rankPage(),
  //   const settingPage()
  // ];
  final List page = [
    const bottomNavStorePage(),
    const attractionPage(),
    const bottomNavItemPage(),
    const rankPage(),
    const settingPage()
  ];

  // Geolocator 기본 세팅
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 1,
  );

  @override
  void initState() {
    stepdb.initPlatformState(context);
    packinfos.loading(); // 패키지 정보 로딩
    // 경위도 갱신 (실시간)
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {
      naverMap.updateLatLng(position!.latitude, position.longitude, context);
      userDate.updateVisitBenfit();
    });
    _startHourlyCheck();
    super.initState();
  }

  // 정각에 클라이언트가 임시적으로 초기화 시켜두기 위한 로직
  void _startHourlyCheck() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      final now = DateTime.now();
      if (now.minute == 0 && now.second == 0) {
        // 정각에 실행할 작업
        print("정각입니다! ${now.hour}:00");
        stepdb.checkAndResetSteps();
        userDate.missionCount.value = 0;
        userDate.userPossibleSearch.value = 10;
      }
    });
  }

  // @override
  // void dispose() {
  //   _timer.cancel(); // 타이머 해제
  //   super.dispose();
  // }

  Future<void> loadingUserData() async {
    if (await Permission.location.status.isDenied) {
    } else {
      userDate.updateUser(); // 사용자 정보 받아오기
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          extendBody: true, // bottomAppBar 부분까지 확장으로 사용할것인가?
          body: Stack(
            children: [
              maps(context),
              statusBars.status(context),
              cameraMove // 카메라 움직임이 있을때,
                  ? nowLocation() // 현 위치 갱신 버튼
                  : gaugeButton(),
              checkCountAndTG(),
            ],
          ),
          bottomNavigationBar: bottomAppBar(), // 하단
        ),
        Obx(
          () => Offstage(
            offstage: !userDate.connectingNetwork.value, // false면 감춰
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

  // 조사하기 남은 횟수 & TG 재화
  Widget checkCountAndTG() {
    return Obx(() {
      String tgCount = NumberFormat("###,###").format(userDate.userTG.value);
      return Positioned(
          left: MediaQuery.of(context).size.width * 0.02,
          bottom: Platform.isAndroid
              ? MediaQuery.of(context).size.height * 0.08
              : MediaQuery.of(context).size.height * 0.12,
          child: Container(
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.height * 0.03,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0)),
                      onPressed: () {
                        dialogSearch(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: MediaQuery.of(context).size.width * 0.05,
                            color: const Color.fromARGB(255, 37, 109, 40),
                          ),
                          XtyleText(
                            "${userDate.userPossibleSearch} / ${userDate.userMaxSearch}",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035,
                                color: const Color.fromARGB(255, 37, 109, 40)),
                          )
                        ],
                      )),
                ),
                const SizedBox(width: 5),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.03,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0)),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedFlipCounter(
                            curve: Curves.easeInOutQuad,
                            wholeDigits:
                                userDate.userTG.value.toString().length,
                            value: userDate.userTG.value,
                            // suffix: " TG",
                            // decimalSeparator: ".",
                            thousandSeparator: ",",
                            duration: const Duration(
                                milliseconds: 1000), // 퍼센트와 시간을 맞추기 위해
                            textStyle: TextStyle(
                                // fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'GmarketSans',
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.032),
                          ),
                          const SizedBox(width: 3),
                          Text("TG",
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 1, 113, 206),
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.032))
                          // Text(
                          //   " $tgCount TG ",
                          //   style: TextStyle(
                          //       fontSize:
                          //           MediaQuery.of(context).size.width * 0.035),
                          // )
                        ],
                      )),
                ),
              ],
            ),
          ));
    });
  }

  // 네이버 지도
  Widget maps(BuildContext context) {
    double right = MediaQuery.of(context).size.width * 0.02;
    double bottom = MediaQuery.of(context).size.height * 0.08;

    return NaverMap(
      options: NaverMapViewOptions(
          tiltGesturesEnable: false,
          minZoom: 5, // 최소 줌 제한
          maxZoom: 19.5, // 최대 줌 제한
          extent: const NLatLngBounds(
              northEast: NLatLng(44.35, 132.0),
              southWest: NLatLng(31.43, 122.37)), // 지도 영역 : 한반도 인근
          // locationButtonEnable: true, // 현위치 버튼
          scaleBarEnable: false,
          initialCameraPosition: naverMap.maplatlng,
          logoAlign: NLogoAlign.rightBottom,
          logoMargin: EdgeInsets.only(right: right, bottom: bottom)),
      onMapReady: (controller) async {
        naverMap.mapController = controller;
        await naverMap.checkLocation(context); // 위치 권한 및 현 위치 가져오기
        loadingUserData(); // 사용자 정보 받아오기
        print("네이버 지도 로딩완료");
      },
      // 카메라 움직임 감지
      onCameraChange: (reason, animated) {
        setState(() {
          // 만약, 사용자가 직접 카메라를 움직였다면
          if (reason == NCameraUpdateReason.gesture) {
            cameraMove = true; // 현 위치 버튼 활성화
            naverMap.setCircleVisible(true);
            naverMap.updatemoving(true);
          } else {
            cameraMove = false;
            naverMap.setCircleVisible(false);
            naverMap.updatemoving(false);
          }
        });
      },
      // onCameraIdle: () {
      //   if (examines.Gauge.value < 100) {
      //     examines.updateGauge();
      //   }
      // },
    );
  }

  // [하단] - 위젯 배치
  BottomAppBar bottomAppBar() {
    double width = MediaQuery.of(context).size.width * 0.02;
    double top = MediaQuery.of(context).size.height * 0.01;

    return BottomAppBar(
      elevation: 5,
      padding: EdgeInsets.only(left: width, right: width, top: top),
      height: MediaQuery.of(context).size.height * 0.07,
      color: Colors.grey[50],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int index = 0; index < 5; index++)
            menuButton(name[index], icons[index], colors[index], page[index])
        ],
      ),
    );
  }

  IconButton menuButton(String name, IconData icon, Color color, Widget page) {
    return IconButton(
        padding: const EdgeInsets.all(0),
        onPressed: () {
          Get.to(() => page);
        },
        icon: Column(
          children: [Icon(icon, color: color), XtyleText(name)],
        ));
  }

  // 현 위치 갱신
  Widget nowLocation() {
    double mylocationButtonWidth = MediaQuery.of(context).size.width * 0.45;
    double mylocationButtonHeight = MediaQuery.of(context).size.height * 0.06;

    return Positioned(
        bottom: MediaQuery.of(context).size.height * 0.2,
        left:
            MediaQuery.of(context).size.width / 2 - (mylocationButtonWidth / 2),
        child: SizedBox(
          width: mylocationButtonWidth,
          height: mylocationButtonHeight,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(0),
                  side: BorderSide(
                      width: MediaQuery.of(context).size.width * 0.005,
                      color: Colors.blue)),
              onPressed: () {
                setState(() {
                  cameraMove = false;
                });
                naverMap.getMap(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.my_location_rounded, color: Colors.blue),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                  const XtyleText(
                    "현 위치로 이동",
                    style: TextStyle(color: Colors.black),
                  )
                ],
              )),
        ));
  }

  // 조사하기 버튼
  Widget gaugeButton() {
    double mylocationButtonWidth = MediaQuery.of(context).size.width * 0.45;
    double mylocationButtonHeight = MediaQuery.of(context).size.height * 0.06;

    double radiusbutton = MediaQuery.of(context).size.width * 0.08;

    Color availableColor = const Color.fromARGB(255, 52, 119, 54);

    return Positioned(
        bottom: MediaQuery.of(context).size.height * 0.2,
        left:
            MediaQuery.of(context).size.width / 2 - (mylocationButtonWidth / 2),
        child: SizedBox(
            width: mylocationButtonWidth,
            height: mylocationButtonHeight,
            child: Obx(() => ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 4,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(radiusbutton)),
                    side: BorderSide(
                      width: MediaQuery.of(context).size.width * 0.005,
                      color: examines.Gauge.value >= 100
                          ? availableColor
                          : Colors.grey,
                    )),
                onPressed: examines.Gauge.value >= 100
                    ? () {
                        // double randomNumber = Random().nextDouble();

                        // //
                        // if (randomNumber < 0.6) {
                        //   examines.searchAttraction(context);
                        // } else {
                        //   naverMap.addMarker(context);
                        // }

                        if (naverMap.examcount < 10) {
                          if (examines.addAttractionMarker.value == false) {
                            examines.searchAttraction(context);
                          } else {
                            naverMap.addMarker(context);
                          }
                        } else {
                          events.overMarker(context);
                        }

                        examines.resetGauge();
                      }
                    : null,
                child: Obx(() => LinearPercentIndicator(
                      progressColor:
                          examines.Gauge < 100 ? Colors.green : Colors.white,
                      animation: true,
                      animationDuration: 500,
                      animateFromLastPercent: true,
                      padding: const EdgeInsets.all(0),
                      width: mylocationButtonWidth,
                      lineHeight: mylocationButtonHeight,
                      barRadius: Radius.circular(radiusbutton),
                      percent: examines.Gauge < 100
                          ? examines.Gauge.toDouble() * 0.01
                          : 1,
                      backgroundColor: Colors.white,
                      center: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          examines.Gauge.value >= 100
                              ? Icon(Icons.search, color: availableColor)
                              : const Icon(Icons.battery_charging_full_rounded,
                                  color: Colors.black),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01),
                          XtyleText(
                            examines.Gauge.value >= 100
                                ? "조사하기"
                                : "충전중 (${examines.Gauge}%)",
                            style: TextStyle(
                                color: examines.Gauge.value >= 100
                                    ? availableColor
                                    : Colors.black),
                          )
                        ],
                      ),
                    ))))));
  }
}
