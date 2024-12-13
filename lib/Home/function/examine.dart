import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:travel_go/Home/function/Geolocation.dart';
import 'package:travel_go/Home/function/events/LevelUP.dart';
import 'package:travel_go/Home/function/events/getCamera.dart';
import 'package:travel_go/Home/function/events/getCharge.dart';
import 'package:travel_go/Home/function/events/getExp.dart';
import 'package:travel_go/Home/function/events/getLottery.dart';
import 'package:travel_go/Home/function/events/getSearch.dart';
import 'package:travel_go/Home/function/events/getTG.dart';
import 'package:travel_go/Home/function/events/getWallet.dart';
import 'package:travel_go/Home/function/events/getitem.dart';
import 'package:travel_go/Home/function/events/roulette.dart';
import 'package:travel_go/Home/function/events/trap.dart';
import 'package:travel_go/Home/function/userController.dart';
import 'package:travel_go/Home/ui/dialog/dialog_location.dart';
import 'package:travel_go/Home/ui/event_examine.dart';
import 'package:travel_go/Login/function/apple_login.dart';
import 'package:http/http.dart' as http;
import 'package:travel_go/collection/ui/SelectedItemDetail.dart';

class examine extends GetxController {
  final AppleLogin appleLogin = AppleLogin();
  final events = Get.put(event()); // 이벤트 컨트롤러
  RxInt Gauge = 0.obs; // 게이지
  RxBool addAttractionMarker = false.obs; // 명소 마커가 찍혀있는지 유무

  // 랜덤 게이지 충전
  Future<void> updateGauge() async {
    double randomNumber = Random().nextDouble(); // 0과 1 사이의 무작위 실수

    // 10% 확률로 게이지 20 증가
    if (randomNumber < 0.1) {
      int random = 20;
      Gauge.value += random;
      print("10퍼센트 확률로 20 증가했습니다!");
      // 30% 확률로 게이지 8 ~ 15 증가
    } else if (randomNumber < 0.4) {
      int random = Random().nextInt(8) + 8;
      Gauge.value += random;
      print("30퍼센트 확률로 $random 증가했습니다!");
      // 60% 확률로 게이지 3 ~ 7 증가
    } else {
      int random = Random().nextInt(5) + 3;
      Gauge.value += random;
      print("60퍼센트 확률로 $random 증가했습니다!");
    }
    // 테스트 용도
    // int random = 100;
    // Gauge.value += random;
  }

  // 랜덤 이벤트 발생
  Future<void> randomExamine(BuildContext context, String markerID) async {
    final userlatlong = Get.put(LatLngController());
    final userDate = Get.put(userController()); // 사용자 정보 컨트롤러
    final roulettes = Get.put(roulette()); // 룰렛 컨트롤러
    final wallets = Get.put(wallet()); // 지갑 컨트롤러
    final cameras = Get.put(cameraEvent()); // 지갑 컨트롤러
    final lotterys = Get.put(lottery()); // 지갑 컨트롤러
    var httpClient = http.Client();

    print("이벤트 실행");

    updateinfo(markerID); // 일단 먼저 지우고 시작?

    // lotterys.getlottery(context);

    // User? user = await UserApi.instance.me(); // 사용자 정보 가져오기 요청
    String? email = await appleLogin.getEmailPrefix();
    var urlPath = dotenv.env['SERVER_URL'];

    double randomNumber1 = Random().nextDouble(); // 0과 1 사이의 무작위 실수

    // 10% 확률로 아무런 일도 벌어지지 않음
    if (randomNumber1 < 0.1) {
      events.nothingExamine(context); // 아무일도 벌어지지 않지만, 차감은 되지않음.
      // 50% 확률로 이벤트가 발생 한다.
    } else if (randomNumber1 < 0.6) {
      userDate.connectingNetwork.value = true; // 화면 움직이지 못하게 금지

      // GET 요청에서는 데이터를 쿼리 매개변수로 추가
      final url = Uri.parse('$urlPath/api/search/event?email=$email');

      var headers = {
        "accept": '*/*',
        'Content-Type': 'application/json',
      };

      try {
        var response = await httpClient.post(url, headers: headers);
        print("조사하기 정보 받아오기 responseCode ${response.statusCode}");
        print("조사하기 정보 : ${utf8.decode(response.bodyBytes)}");
        var responseData = jsonDecode(utf8.decode(response.bodyBytes));

        int eventID = responseData["eventCategory"];
        print("이벤트 번호 : $eventID");

        userDate.userTG.value = responseData["tg"];
        userDate.userLevel.value = responseData["level"];
        userDate.userExperience.value = responseData["experience"];
        userDate.userNextLevelExp.value = responseData["nextLevelExp"];
        userDate.percentage.value = responseData["percentage"];
        userDate.benefitFull.value = responseData["visitingBenefit"];
        userDate.userMaxSearch.value = responseData["maxSearch"];
        userDate.userPossibleSearch.value = responseData["possibleSearch"];

        switch (eventID) {
          case 1:
            getTG(context, 100);
            userDate.connectingNetwork.value = false; // 화면 움직이지 못하게 금지
          case 2:
            getTG(context, 300);
            userDate.connectingNetwork.value = false; // 화면 움직이지 못하게 금지
          case 3:
            getEXP(context, 100);
            userDate.connectingNetwork.value = false; // 화면 움직이지 못하게 금지
          case 4:
            getEXP(context, 500);
            userDate.connectingNetwork.value = false; // 화면 움직이지 못하게 금지
          case 5:
            getCharge(context, 50);
            userDate.connectingNetwork.value = false; // 화면 움직이지 못하게 금지
          case 6:
            getCharge(context, 100);
            userDate.connectingNetwork.value = false; // 화면 움직이지 못하게 금지
          case 7:
            getSearch(context, 2);
            userDate.connectingNetwork.value = false; // 화면 움직이지 못하게 금지
          case 8:
            getSearch(context, -1);
            userDate.connectingNetwork.value = false; // 화면 움직이지 못하게 금지
          case 9:
            trap(context);
            userDate.connectingNetwork.value = false; // 화면 움직이지 못하게 금지
          case 10:
            getLevel(context);
            userDate.connectingNetwork.value = false; // 화면 움직이지 못하게 금지
          case 11:
            wallets.getWallet(context);
            userDate.connectingNetwork.value = false; // 화면 움직이지 못하게 금지
          case 12:
            cameras.getCamera(context);
            userDate.connectingNetwork.value = false; // 화면 움직이지 못하게 금지
          case 13:
            // userDate.connectingNetwork.value = false; // 화면 움직이지 못하게 금지
            // final url =
            //     Uri.parse('$urlPath/api/search/event/merchant?email=$email');
            // var headers = {
            //   "accept": '*/*',
            //   'Content-Type': 'application/json',
            // };
            // try {
            //   var response = await httpClient.post(url, headers: headers);
            //   var responseData = jsonDecode(utf8.decode(response.bodyBytes));
            //   List<String> merchantResults = List<String>.from(
            //       responseData["merchantResults"]
            //           .map((item) => item.toString()));
            //   print("룰렛 정보 : $responseData");
            //   roulettes.getDealer(context, merchantResults);
            // } catch (e) {
            //   print("룰렛 에러 : $e");
            // }
            // userDate.connectingNetwork.value = false; // 화면 움직이지 못하게 금지

            userDate.connectingNetwork.value = true; // 화면 움직이지 못하게 금지
            final url = Uri.parse(
                '$urlPath/api/userItems/add?email=$email&latitude=${userlatlong.mylatitude}&longitude=${userlatlong.mylongitude}');

            var headers = {
              "accept": '*/*',
              'Content-Type': 'application/json',
            };

            try {
              var response = await httpClient.post(url, headers: headers);
              print("responseCode ${response.statusCode}");
              print("조사하기 아이템 : ${utf8.decode(response.bodyBytes)}");
              var responseData = jsonDecode(utf8.decode(response.bodyBytes));
              print("조사하기 아이템 결과 : $responseData");

              int itemId = responseData["itemId"]; // 선택된 아이템 id
              int selectedItemRank = responseData["itemRank"]; // 선택된 아이템 등급
              String selectedItemName = responseData["itemName"]; // 선택된 아이템 이름
              // String selectedItemArea = responseData["area"]; // 선택된 아이템 지역
              String selectedItemSummary =
                  responseData["itemSummary"]; // 선택된 아이템 간략글?
              String selectedItemDescription =
                  responseData["itemDescription"]; // 선택된 아이템 내용?
              int itemPiece = responseData["itemPiece"];
              int chageTG = 0;
              int chageEXP = 0;

              if (responseData["tg"] != null) {
                userDate.userTG.value = responseData["tg"];
                chageTG = responseData["tgChange"];
              } else if (responseData["exp"] != null) {
                userDate.userLevel.value = responseData["level"];
                userDate.userExperience.value = responseData["experience"];
                userDate.userNextLevelExp.value = responseData["nextLevelExp"];
                userDate.percentage.value = responseData["percentage"];
                chageEXP = responseData["exp"];
              }

              selectedItemDetail(
                  context,
                  itemId,
                  selectedItemRank,
                  selectedItemName,
                  selectedItemSummary,
                  selectedItemDescription,
                  itemPiece,
                  chageTG,
                  chageEXP);
            } catch (e) {
              print("조사하기 아이템 획득 에러 : $e");
            }
            decreaseSearch();

            userDate.connectingNetwork.value = false; // 화면 움직이지 못하게 금지
          case 14:
            // lotterys.getlottery(context);
            // userDate.connectingNetwork.value = false; // 화면 움직이지 못하게 금지

            userDate.connectingNetwork.value = true; // 화면 움직이지 못하게 금지
            final url = Uri.parse(
                '$urlPath/api/userItems/add?email=$email&latitude=${userlatlong.mylatitude}&longitude=${userlatlong.mylongitude}');

            var headers = {
              "accept": '*/*',
              'Content-Type': 'application/json',
            };

            try {
              var response = await httpClient.post(url, headers: headers);
              print("responseCode ${response.statusCode}");
              print("조사하기 아이템 : ${utf8.decode(response.bodyBytes)}");
              var responseData = jsonDecode(utf8.decode(response.bodyBytes));
              print("조사하기 아이템 결과 : $responseData");

              int itemId = responseData["itemId"]; // 선택된 아이템 id
              int selectedItemRank = responseData["itemRank"]; // 선택된 아이템 등급
              String selectedItemName = responseData["itemName"]; // 선택된 아이템 이름
              // String selectedItemArea = responseData["area"]; // 선택된 아이템 지역
              String selectedItemSummary =
                  responseData["itemSummary"]; // 선택된 아이템 간략글?
              String selectedItemDescription =
                  responseData["itemDescription"]; // 선택된 아이템 내용?
              int itemPiece = responseData["itemPiece"];
              int chageTG = 0;
              int chageEXP = 0;

              if (responseData["tg"] != null) {
                userDate.userTG.value = responseData["tg"];
                chageTG = responseData["tgChange"];
              } else if (responseData["exp"] != null) {
                userDate.userLevel.value = responseData["level"];
                userDate.userExperience.value = responseData["experience"];
                userDate.userNextLevelExp.value = responseData["nextLevelExp"];
                userDate.percentage.value = responseData["percentage"];
                chageEXP = responseData["exp"];
              }

              selectedItemDetail(
                  context,
                  itemId,
                  selectedItemRank,
                  selectedItemName,
                  selectedItemSummary,
                  selectedItemDescription,
                  itemPiece,
                  chageTG,
                  chageEXP);
            } catch (e) {
              print("조사하기 아이템 획득 에러 : $e");
            }
            decreaseSearch();

            userDate.connectingNetwork.value = false; // 화면 움직이지 못하게 금지
        }
      } catch (e) {
        print("조사하기 Error: $e");
      }
      userDate.connectingNetwork.value = false; // 화면 움직이지 못하게 금지

      // 40% 확률로 아이템을 획득한다
    } else {
      userDate.connectingNetwork.value = true; // 화면 움직이지 못하게 금지
      final url = Uri.parse(
          '$urlPath/api/userItems/add?email=$email&latitude=${userlatlong.mylatitude}&longitude=${userlatlong.mylongitude}');

      var headers = {
        "accept": '*/*',
        'Content-Type': 'application/json',
      };

      try {
        var response = await httpClient.post(url, headers: headers);
        print("responseCode ${response.statusCode}");
        print("조사하기 아이템 : ${utf8.decode(response.bodyBytes)}");
        var responseData = jsonDecode(utf8.decode(response.bodyBytes));
        print("조사하기 아이템 결과 : $responseData");

        int itemId = responseData["itemId"]; // 선택된 아이템 id
        int selectedItemRank = responseData["itemRank"]; // 선택된 아이템 등급
        String selectedItemName = responseData["itemName"]; // 선택된 아이템 이름
        // String selectedItemArea = responseData["area"]; // 선택된 아이템 지역
        String selectedItemSummary =
            responseData["itemSummary"]; // 선택된 아이템 간략글?
        String selectedItemDescription =
            responseData["itemDescription"]; // 선택된 아이템 내용?
        int itemPiece = responseData["itemPiece"];
        int chageTG = 0;
        int chageEXP = 0;

        if (responseData["tg"] != null) {
          userDate.userTG.value = responseData["tg"];
          chageTG = responseData["tgChange"];
        } else if (responseData["exp"] != null) {
          userDate.userLevel.value = responseData["level"];
          userDate.userExperience.value = responseData["experience"];
          userDate.userNextLevelExp.value = responseData["nextLevelExp"];
          userDate.percentage.value = responseData["percentage"];
          chageEXP = responseData["exp"];
        }

        selectedItemDetail(
            context,
            itemId,
            selectedItemRank,
            selectedItemName,
            selectedItemSummary,
            selectedItemDescription,
            itemPiece,
            chageTG,
            chageEXP);
      } catch (e) {
        print("조사하기 아이템 획득 에러 : $e");
      }
      decreaseSearch();

      userDate.connectingNetwork.value = false; // 화면 움직이지 못하게 금지
    }
  }

  Future<void> decreaseSearch() async {
    final userDate = Get.put(userController()); // 사용자 정보 컨트롤러
    String? email = await appleLogin.getEmailPrefix();
    var urlPath = dotenv.env['SERVER_URL'];
    var httpClient = http.Client();

    final url2 =
        Uri.parse('$urlPath/api/search/SearchCountDecrease?email=$email');

    var headers = {
      "accept": '*/*',
    };

    try {
      var response2 = await httpClient.post(url2, headers: headers);
      print("responseCode2 ${response2.statusCode}");
      //print("아이템으로 감소 : ${utf8.decode(response2.bodyBytes)}");
      //var responseData2 = jsonDecode(utf8.decode(response2.bodyBytes));
      //print("아이템으로 인한 감소 결과 : $responseData2");
      if (response2.statusCode == 200) {
        userDate.userPossibleSearch.value =
            userDate.userPossibleSearch.value - 1;
      }
    } catch (e) {
      print("조사하기 감소 에러 : $e");
    }
  }

  // 명소 마커찍기
  Future<void> searchAttraction(BuildContext context) async {
    final userlatlong = Get.put(LatLngController());
    final userDate = Get.put(userController()); // 사용자 정보 컨트롤러

    // User? user = await UserApi.instance.me(); // 사용자 정보 가져오기 요청
    String? email = await appleLogin.getEmailPrefix();
    var urlPath = dotenv.env['SERVER_URL'];
    var httpClient = http.Client();

    userDate.connectingNetwork.value = true; // 화면 움직이지 못하게 금지
    final url = Uri.parse(
        '$urlPath/api/attraction-record?email=$email&latitude=${userlatlong.mylatitude}&longitude=${userlatlong.mylongitude}&distance=3');

    var headers = {
      "accept": '*/*',
      'Content-Type': 'application/json',
    };

    try {
      var response = await httpClient.get(url, headers: headers);
      print("responseCode ${response.statusCode}");
      print("조사하기 명소 : ${utf8.decode(response.bodyBytes)}");
      var responseData = jsonDecode(utf8.decode(response.bodyBytes));

      // 만약 비어있다면 그냥 이벤트 마커 찍고,
      if (responseData[0]["latitude"] == "") {
        addAttractionMarker.value = false;
        if (userlatlong.examcount < 10) {
          userlatlong.addMarker(context);
        } else {
          events.overMarker(context);
        }

        // 있으면 명소 마커 생성하기
      } else {
        addAttractionMarker.value = true;
        double locationLatitude = responseData[0]["latitude"];
        double locationLongitude = responseData[0]["longitude"];
        int locationId = responseData[0]["attractionId"];

        userlatlong.addLocationMarker(
            context, locationLatitude, locationLongitude, locationId);
      }
    } catch (e) {
      print("조사하기 명소 획득 에러 : $e");
      addAttractionMarker.value = false;
      if (userlatlong.examcount < 10) {
        userlatlong.addMarker(context);
      } else {
        events.overMarker(context);
      }
    }

    userDate.connectingNetwork.value = false; // 화면 움직이지 못하게 금지
  }

  // 이벤트 이후 처리(마커 삭제, 카운트 감소)
  Future<void> updateinfo(String id) async {
    final userDate = Get.put(userController()); // 사용자 정보 컨트롤러
    final marker = Get.put(LatLngController()); // 마커 컨트롤러
    naverMap.mapController
        .deleteOverlay(NOverlayInfo(type: NOverlayType.marker, id: id));
    marker.examcount.value -= 1; // 마커 카운트 감소
    // userDate.updateSearch(); // 조사하기 횟수 감소
  }

  Future<void> resetGauge() async {
    Gauge.value = 0;
  }
}
