import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:travel_go/Home/function/userController.dart';
import 'package:travel_go/Login/function/apple_login.dart';
import 'package:travel_go/collection/ui/SelectedItemDetail.dart';
import 'package:travel_go/collection/ui/infoItem.dart';

class inventoryItems extends GetxController {
  RxBool itemNetwork = false.obs;
  RxBool _openListCommon = false.obs;
  RxBool get openListCommon => _openListCommon;
  RxBool _openListLocaion = false.obs;
  RxBool get openListLocaion => _openListLocaion;

  RxList<int> getItem = <int>[].obs; // 사용자 아이템 리스트
  RxList<int> itemPiece = <int>[].obs; // 사용자 아이템 조각 개수 리스트

  RxInt totalItemCount = 0.obs; // 전체 수집 개수
  RxInt earnItemCount = 0.obs; // 현재 수집 개수
  RxDouble earnPercentage = 0.0.obs; // 전체 수집률

  RxInt commonCount = 0.obs; // 공통 전체 수집 개수
  RxInt commonEarn = 0.obs; // 공통 현재 수집 개수

  RxInt normalCount = 0.obs; // 일반 전체 수집 개수
  RxInt normalEarn = 0.obs; // 일반 현재 수집 개수

  RxInt rareCount = 0.obs; // 희귀 전체 수집 개수
  RxInt rareEarn = 0.obs; // 희귀 현재 수집 개수

  RxInt epicCount = 0.obs; // 영웅 전체 수집 개수
  RxInt epicEarn = 0.obs; // 영웅 현재 수집 개수

  RxInt legendCount = 0.obs; // 전설 전체 수집 개수
  RxInt legendEarn = 0.obs; // 전설 현재 수집 개수

  RxInt locationCount = 0.obs; // 지역 전체 수집 개수
  RxInt locationEarn = 0.obs; // 지역 현재 수집 개수

  RxInt seoulTotalItemCount = 0.obs; // 서울 전체 수집 개수
  RxInt seoulCurrentItemCount = 0.obs; // 서울 현재 수집 개수

  RxInt busanTotalItemCount = 0.obs; // 부산 전체 수집 개수
  RxInt busanCurrentItemCount = 0.obs; // 부산 현재 수집 개수

  RxInt daeguTotalItemCount = 0.obs; // 대구 전체 수집 개수
  RxInt daeguCurrentItemCount = 0.obs; // 대구 현재 수집 개수

  RxInt incheonTotalItemCount = 0.obs; // 인천 전체 수집 개수
  RxInt incheonCurrentItemCount = 0.obs; // 인천 현재 수집 개수

  RxInt gwangjuTotalItemCount = 0.obs; // 광주 전체 수집 개수
  RxInt gwangjuCurrentItemCount = 0.obs; // 광주 현재 수집 개수

  RxInt daejeonTotalItemCount = 0.obs; // 대전 전체 수집 개수
  RxInt daejeonCurrentItemCount = 0.obs; // 대전 현재 수집 개수

  RxInt ulsanTotalItemCount = 0.obs; // 울산 전체 수집 개수
  RxInt ulsanCurrentItemCount = 0.obs; // 울산 현재 수집 개수

  RxInt sejongTotalItemCount = 0.obs; // 세종 전체 수집 개수
  RxInt sejongCurrentItemCount = 0.obs; // 세종 현재 수집 개수

  RxInt gyeonggiTotalItemCount = 0.obs; // 경기 전체 수집 개수
  RxInt gyeonggiCurrentItemCount = 0.obs; // 경기 현재 수집 개수

  RxInt gangwonTotalItemCount = 0.obs; // 강원 전체 수집 개수
  RxInt gangwonCurrentItemCount = 0.obs; // 강원 현재 수집 개수

  RxInt chungbukTotalItemCount = 0.obs; // 충청북도 전체 수집 개수
  RxInt chungbukCurrentItemCount = 0.obs; // 충청북도 현재 수집 개수

  RxInt chungnamTotalItemCount = 0.obs; // 충청남도 전체 수집 개수
  RxInt chungnamCurrentItemCount = 0.obs; // 충청남도 현재 수집 개수

  RxInt jeonbukTotalItemCount = 0.obs; // 전라북도 전체 수집 개수
  RxInt jeonbukCurrentItemCount = 0.obs; // 전라북도 현재 수집 개수

  RxInt jeonnamTotalItemCount = 0.obs; // 전라남도 전체 수집 개수
  RxInt jeonnamCurrentItemCount = 0.obs; // 전라남도 현재 수집 개수

  RxInt gyeongbukTotalItemCount = 0.obs; // 경상북도 전체 수집 개수
  RxInt gyeongbukCurrentItemCount = 0.obs; // 경상북도 현재 수집 개수

  RxInt gyeongnamTotalItemCount = 0.obs; // 경상남도 전체 수집 개수
  RxInt gyeongnamCurrentItemCount = 0.obs; // 경상남도 현재 수집 개수

  RxInt jejuTotalItemCount = 0.obs; // 제주 전체 수집 개수
  RxInt jejuCurrentItemCount = 0.obs; // 제주 현재 수집 개수

  final AppleLogin appleLogin = AppleLogin();

  // 사용자 아이템 리스트 정보 불러오기
  Future<void> updateUseritem() async {
    var httpClient = http.Client();

    // User? user = await UserApi.instance.me(); // 사용자 정보 가져오기 요청
    String? email = await appleLogin.getEmailPrefix();
    var urlPath = dotenv.env['SERVER_URL'];

    itemNetwork.value = true;

    // GET 요청에서는 데이터를 쿼리 매개변수로 추가
    final url = Uri.parse('$urlPath/api/userItems/user-info?email=$email');
    final url2 = Uri.parse('$urlPath/api/userItems/items?email=$email');
    var headers = {
      "accept": '*/*',
      'Content-Type': 'application/json',
    };

    try {
      var response = await httpClient.get(url, headers: headers); // GET 요청으로 변경
      print("아이템 정보 받아오기 responseCode ${response.statusCode}");
      print("아이템 정보 : ${utf8.decode(response.bodyBytes)}");
      var responseData = jsonDecode(utf8.decode(response.bodyBytes));

      // 유저가 가지고 있는 아이템 id
      getItem.value = List<int>.from(responseData["itemIds"]);

      var response2 =
          await httpClient.get(url2, headers: headers); // GET 요청으로 변경
      print("아이템 조각 정보 받아오기 responseCode ${response2.statusCode}");
      print("아이템 조각 정보 : ${utf8.decode(response2.bodyBytes)}");
      var responseData2 = jsonDecode(utf8.decode(response2.bodyBytes));
      responseData2.forEach((key, value) {
        if (value is int) {
          itemPiece.add(value);
        }
      });

      print(getItem);

      // 전체 아이템 개수
      totalItemCount.value = responseData["totalItemCount"];
      // 획득한 아이템 개수
      earnItemCount.value = responseData["earnItemCount"];
      // 수집률 퍼센트
      earnPercentage.value = responseData["earnPercentage"] == "NaN"
          ? 0.0
          : responseData["earnPercentage"];
      // 공통 아이템 개수
      commonCount.value = responseData["rankTotalItemCounts"]["1"] +
          responseData["rankTotalItemCounts"]["2"] +
          responseData["rankTotalItemCounts"]["3"] +
          responseData["rankTotalItemCounts"]["4"];
      // 획득한 공통 아이템 개수
      commonEarn.value = responseData["rankEarnItemCounts"]["1"] +
          responseData["rankEarnItemCounts"]["2"] +
          responseData["rankEarnItemCounts"]["3"] +
          responseData["rankEarnItemCounts"]["4"];
      // 일반 아이템 개수
      normalCount.value = responseData["rankTotalItemCounts"]["1"];
      // 획득한 일반 아이템 개수
      normalEarn.value = responseData["rankEarnItemCounts"]["1"];
      // 희귀 아이템 개수
      rareCount.value = responseData["rankTotalItemCounts"]["2"];
      // 획득한 희귀 아이템 개수
      rareEarn.value = responseData["rankEarnItemCounts"]["2"];
      // 영웅 아이템 개수
      epicCount.value = responseData["rankTotalItemCounts"]["3"];
      // 획득한 영웅 아이템 개수
      epicEarn.value = responseData["rankEarnItemCounts"]["3"];
      // 전설 아이템 개수
      legendCount.value = responseData["rankTotalItemCounts"]["4"];
      // 획득한 전설 아이템 개수
      legendEarn.value = responseData["rankEarnItemCounts"]["4"];
      locationCount.value = responseData["rankTotalItemCounts"]["5"];
      locationEarn.value = responseData["rankEarnItemCounts"]["5"];
      // 서울 아이템 개수
      seoulTotalItemCount.value = responseData["areaTotalItemCounts"]["Seoul"];
      // 획득한 서울 아이템 개수
      seoulCurrentItemCount.value = responseData["areaEarnItemCounts"]["Seoul"];
      // 부산 아이템 개수
      busanTotalItemCount.value = responseData["areaTotalItemCounts"]["Busan"];
      // 획득한 부산 아이템 개수
      busanCurrentItemCount.value = responseData["areaEarnItemCounts"]["Busan"];
      // 대구 아이템 개수
      daeguTotalItemCount.value = responseData["areaTotalItemCounts"]["Daegu"];
      // 획득한 대구 아이템 개수
      daeguCurrentItemCount.value = responseData["areaEarnItemCounts"]["Daegu"];
      // 인천 아이템 개수
      incheonTotalItemCount.value =
          responseData["areaTotalItemCounts"]["Incheon"];
      // 획득한 인천 아이템 개수
      incheonCurrentItemCount.value =
          responseData["areaEarnItemCounts"]["Incheon"];
      // 광주 아이템 개수
      gwangjuTotalItemCount.value =
          responseData["areaTotalItemCounts"]["Gwangju"];
      // 획득한 광주 아이템 개수
      gwangjuCurrentItemCount.value =
          responseData["areaEarnItemCounts"]["Gwangju"];
      // 대전 아이템 개수
      daejeonTotalItemCount.value =
          responseData["areaTotalItemCounts"]["Daejeon"];
      // 획득한 대전 아이템 개수
      daejeonCurrentItemCount.value =
          responseData["areaEarnItemCounts"]["Daejeon"];
      // 울산 아이템 개수
      ulsanTotalItemCount.value = responseData["areaTotalItemCounts"]["Ulsan"];
      // 획득한 울산 아이템 개수
      ulsanCurrentItemCount.value = responseData["areaEarnItemCounts"]["Ulsan"];
      // 세종 아이템 개수
      sejongTotalItemCount.value =
          responseData["areaTotalItemCounts"]["Sejong"];
      // 획득한 세종 아이템 개수
      sejongCurrentItemCount.value =
          responseData["areaEarnItemCounts"]["Sejong"];
      // 경기 아이템 개수
      gyeonggiTotalItemCount.value =
          responseData["areaTotalItemCounts"]["Gyeonggido"];
      // 획득한 경기 아이템 개수
      gyeonggiCurrentItemCount.value =
          responseData["areaEarnItemCounts"]["Gyeonggido"];
      // 강원 아이템 개수
      gangwonTotalItemCount.value =
          responseData["areaTotalItemCounts"]["Gangwondo"];
      // 획득한 강원 아이템 개수
      gangwonCurrentItemCount.value =
          responseData["areaEarnItemCounts"]["Gangwondo"];
      // 충청북도 아이템 개수
      chungbukTotalItemCount.value =
          responseData["areaTotalItemCounts"]["Chungcheongbukdo"];
      // 획득한 충청북도 아이템 개수
      chungbukCurrentItemCount.value =
          responseData["areaEarnItemCounts"]["Chungcheongbukdo"];
      // 충청남도 아이템 개수
      chungnamTotalItemCount.value =
          responseData["areaTotalItemCounts"]["Chungcheongnamdo"];
      // 획득한 충청남도 아이템 개수
      chungnamCurrentItemCount.value =
          responseData["areaEarnItemCounts"]["Chungcheongnamdo"];
      // 전라북도 아이템 개수
      jeonbukTotalItemCount.value =
          responseData["areaTotalItemCounts"]["Jeollabukdo"];
      // 획득한 전라북도 아이템 개수
      jeonbukCurrentItemCount.value =
          responseData["areaEarnItemCounts"]["Jeollabukdo"];
      // 전라남도 아이템 개수
      jeonnamTotalItemCount.value =
          responseData["areaTotalItemCounts"]["Jeollanamdo"];
      // 획득한 전라남도 아이템 개수
      jeonnamCurrentItemCount.value =
          responseData["areaEarnItemCounts"]["Jeollanamdo"];
      // 경상북도 아이템 개수
      gyeongbukTotalItemCount.value =
          responseData["areaTotalItemCounts"]["Gyeonsangbukdo"];
      // 획득한 경상북도 아이템 개수
      gyeongbukCurrentItemCount.value =
          responseData["areaEarnItemCounts"]["Gyeonsangbukdo"];
      // 경상남도 아이템 개수
      gyeongnamTotalItemCount.value =
          responseData["areaTotalItemCounts"]["Gyeonsangnamdo"];
      // 획득한 경상남도 아이템 개수
      gyeongnamCurrentItemCount.value =
          responseData["areaEarnItemCounts"]["Gyeonsangnamdo"];
      // 제주 아이템 개수
      jejuTotalItemCount.value = responseData["areaTotalItemCounts"]["Jejudo"];
      // 획득한 제주 아이템 개수
      jejuCurrentItemCount.value = responseData["areaEarnItemCounts"]["Jejudo"];
    } catch (e) {
      print("Error: $e");
    }

    itemNetwork.value = false;
  }

  // 선택한 아이템 정보 가져오기
  Future<void> selectedUseritem(BuildContext context, int itemId) async {
    print("$itemId 아이템을 검색합니다.");
    var httpClient = http.Client();

    // User? user = await UserApi.instance.me(); // 사용자 정보 가져오기 요청
    String? email = await appleLogin.getEmailPrefix();
    var urlPath = dotenv.env['SERVER_URL'];

    itemNetwork.value = true;

    // GET 요청에서는 데이터를 쿼리 매개변수로 추가
    final url = Uri.parse('$urlPath/api/item/{itemId}?item_id=$itemId');

    var headers = {
      "accept": '*/*',
      'Content-Type': 'application/json',
    };

    try {
      var response = await httpClient.get(url, headers: headers); // GET 요청으로 변경
      print("아이템 정보 받아오기 responseCode ${response.statusCode}");
      print("아이템 정보 : ${utf8.decode(response.bodyBytes)}");
      var responseData = jsonDecode(utf8.decode(response.bodyBytes));

      int selectedItemRank = responseData["itemRank"]; // 선택된 아이템 등급
      String selectedItemName = responseData["itemName"]; // 선택된 아이템 이름
      // String selectedItemArea = responseData["area"]; // 선택된 아이템 지역
      String selectedItemSummary = responseData["summary"]; // 선택된 아이템 간략글?
      String selectedItemDescription =
          responseData["description"]; // 선택된 아이템 내용?
      // int itemPiece = responseData["itemPiece"];

      infoItem(context, itemId, selectedItemRank, selectedItemName,
          selectedItemSummary, selectedItemDescription);
    } catch (e) {
      print("Error: $e");
    }

    itemNetwork.value = false;
  }
}
