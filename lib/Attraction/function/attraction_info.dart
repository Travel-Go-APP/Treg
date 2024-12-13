import 'dart:convert';

import 'package:countries_world_map/data/maps/countries/south_korea.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:travel_go/Login/function/apple_login.dart';

class attractInfo extends GetxController {
  RxBool networkAttractionMain = false.obs;
  RxBool _openCheck = false.obs; // 힌트 오픈 했는지
  RxBool get openCheck => _openCheck;
  RxInt allCountry = 0.obs; // 명소 전체 수
  RxInt nowCountry = 0.obs; // 현재 획득한 전체 명소 수
  RxDouble percentValue = 0.0.obs; // 명소 전체 수집률
  RxInt gwangjuTotalCount = 0.obs; // 광주 전체 개수
  RxInt gwangjuVisitCount = 0.obs; // 광주 현재 수집
  RxInt incheonTotalCount = 0.obs; // 인천 젠체 개수
  RxInt incheonVisitCount = 0.obs; // 인천 현재 수집
  RxInt ulsanTotalCount = 0.obs; // 울산 전체 개수
  RxInt ulsanVisitCount = 0.obs; // 울산 현재 수집
  RxInt daejeonTotalCount = 0.obs; // 대전 전체 개수
  RxInt daejeonVisitCount = 0.obs; // 대전 현재 수집
  RxInt gyeonggidoTotalCount = 0.obs; // 경기도 전체 개수
  RxInt gyeonggidoVisitCount = 0.obs; // 경기도 현재 수집
  RxInt gangwondoTotalCount = 0.obs; // 강원도 전체 개수
  RxInt gangwondoVisitCount = 0.obs; // 강원도 현재 수집
  RxInt gyeonsangbukdoTotalCount = 0.obs; // 경상북도 전체 개수
  RxInt gyeonsangbukdoVisitCount = 0.obs; // 경상북도 현재 수집
  RxInt sejongTotalCount = 0.obs; // 세종 전체 개수
  RxInt sejongVisitCount = 0.obs; // 세종 현재 수집
  RxInt seoulTotalCount = 0.obs; // 서울 전체 개수
  RxInt seoulVisitCount = 0.obs; // 서울 현재 수집
  RxInt busanTotalCount = 0.obs; // 부산 전체 개수
  RxInt busanVisitCount = 0.obs; // 부산 현재 수집
  RxInt jeollabukdoTotalCount = 0.obs; // 전라북도 전체 개수
  RxInt jeollabukdoVisitCount = 0.obs; // 전라북도 현재 수집
  RxInt jejudoTotalCount = 0.obs; // 제주 전체 개수
  RxInt jejudoVisitCount = 0.obs; // 제주 현재 수집
  RxInt gyeonsangnamdoTotalCount = 0.obs; // 경상남도 전체 개수
  RxInt gyeonsangnamdoVisitCount = 0.obs; // 경상남도 현재 수집
  RxInt chungcheongbukdoTotalCount = 0.obs; // 충청북도 전체 개수
  RxInt chungcheongbukdoVisitCount = 0.obs; // 충청북도 현재 수집
  RxInt jeollanamdoTotalCount = 0.obs; // 전라남도 전체 개수
  RxInt jeollanamdoVisitCount = 0.obs; // 전라남도 현재 수집
  RxInt daeguTotalCount = 0.obs; // 대구 전체 개수
  RxInt daeguVisitCount = 0.obs; // 대구 현재 수집
  RxInt chungcheongnamdoTotalCount = 0.obs; // 충청남도 전체 개수
  RxInt chungcheongnamdoVisitCount = 0.obs; // 충청남도 현재 수집

  // http 통신과 데이터 처리를 위한 지역 리스트
  List<String> countries = <String>[
    "Seoul",
    "Busan",
    "Daegu",
    "Incheon",
    "Gwangju",
    "Daejeon",
    "Ulsan",
    "Sejong",
    "Gyeonggido",
    "Gangwondo",
    "Chungcheongbukdo",
    "Chungcheongnamdo",
    "Jeollabukdo",
    "Jeollanamdo",
    "Gyeonsangbukdo",
    "Gyeonsangnamdo",
    "Jejudo"
  ].obs;

  // 실제 화면에서 사용될 지역 리스트
  List<String> areas = <String>[
    '서울',
    '부산',
    '대구',
    '인천',
    '광주',
    '대전',
    '울산',
    '세종특별자치도',
    '경기도',
    '강원특별자치도',
    '충청북도',
    '충청남도',
    '전북특별자치도',
    '전라남도',
    '경상북도',
    '경상남도',
    '제주'
  ].obs;

  // // 지역별 명소 개수
  // List<int> countryCount = <int>[
  //   1,
  //   2,
  //   3,
  //   4,
  //   5,
  //   6,
  //   7,
  //   8,
  //   9,
  //   10,
  //   11,
  //   12,
  //   13,
  //   14,
  //   15,
  //   16,
  //   17,
  // ];

  // // 지역별 획득한 명소 개수
  // List<int> countryGet = <int>[
  //   0,
  //   0,
  //   0,
  //   1,
  //   1,
  //   2,
  //   2,
  //   3,
  //   4,
  //   5,
  //   7,
  //   8,
  //   10,
  //   11,
  //   12,
  //   13,
  //   17,
  // ];

  // 지역 이름
  RxList<String> areaList = <String>[].obs;

  // 지역별 total 개수
  RxList<int> countryCount =
      <int>[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1].obs;

  // 지역별 Visit 개수
  RxList<int> countryGet =
      <int>[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0].obs;

  final AppleLogin appleLogin = AppleLogin();

  // 사용자 아이템 리스트 정보 불러오기
  Future<void> updateAreaList() async {
    var httpClient = http.Client();

    // User? user = await UserApi.instance.me(); // 사용자 정보 가져오기 요청

    networkAttractionMain.value = true;

    var urlPath = dotenv.env['SERVER_URL'];
    String? email = await appleLogin.getEmailPrefix();
    // GET 요청에서는 데이터를 쿼리 매개변수로 추가
    final url = Uri.parse('$urlPath/api/attraction-achievement?email=$email');

    var headers = {
      "accept": '*/*',
      'Content-Type': 'application/json',
    };

    try {
      var response = await httpClient.get(url, headers: headers); // GET 요청으로 변경
      print("아이템 정보 받아오기 responseCode ${response.statusCode}");
      print("아이템 정보 : ${utf8.decode(response.bodyBytes)}");
      var responseData = jsonDecode(utf8.decode(response.bodyBytes));

      print("명소 기록 불러오기 : $responseData");

      // "areaTotalCount"에서 데이터 추출하여 리스트에 추가
      // 0이면 에러가 발생하기에, 무조건 1이상의 값이 들어가 있어야 함.
      responseData['areaTotalCount'].forEach((key, value) {
        int index = countries.indexOf(key);
        if (value != 0) {
          countryCount[index] = value;
        } else {
          countryCount[index] = 1;
        }
      });

      // "areaVisitCount"에서 데이터 추출하여 리스트에 추가
      responseData['areaVisitCount'].forEach((key, value) {
        int index = countries.indexOf(key);
        countryGet[index] = value;
      });

      // 디버그 출력 (리스트가 올바르게 업데이트되었는지 확인)
      //print('Countries: $countries');
      print('Country Count: $countryCount');
      print('Country Get: $countryGet');
    } catch (e) {
      print("Error: $e");
    }
    updateCountry();
    networkAttractionMain.value = false;
  }

  // 전체 수집률 초기화
  Future<void> ResetValue() async {
    percentValue.value = 0.0;
  }

  // 전체 수집률 업데이트
  Future<void> updateHint() async {
    _openCheck.value = !_openCheck.value;
    print("힌트가 ${openCheck}되었습니다.");
  }

  Future<void> updateCountry() async {
    allCountry.value =
        countryCount.reduce((value, element) => value + element); // 전체 명소 수
    nowCountry.value =
        countryGet.reduce((value, element) => value + element); // 현재 획득 명소 수
    percentValue.value = (nowCountry.value / allCountry.value); // 명소 획득 평균 값

    print(
        "전체 수집률 : ${percentValue.value}%  ${nowCountry.value}/${allCountry.value}");
  }

  // 지도 색상 업데이트
  SMapSouthKoreaColors Mapcolor() {
    int seoul = countries.indexOf('Seoul');
    int busan = countries.indexOf('Busan');
    int daegu = countries.indexOf('Daegu');
    int incheon = countries.indexOf('Incheon');
    int gwangju = countries.indexOf('Gwangju');
    int daejeon = countries.indexOf('Daejeon');
    int ulsan = countries.indexOf('Ulsan');
    int sejong = countries.indexOf('Sejong');
    int gyeonggi = countries.indexOf('Gyeonggido');
    int gangwon = countries.indexOf('Gangwondo');
    int chungcheongNorth = countries.indexOf('Chungcheongbukdo');
    int chungcheongSouth = countries.indexOf('Chungcheongnamdo');
    int jeollaNorth = countries.indexOf('Jeollabukdo');
    int jeollaSouth = countries.indexOf('Jeollanamdo');
    int gyeongsangNorth = countries.indexOf('Gyeonsangbukdo');
    int gyeongsangSouth = countries.indexOf('Gyeonsangnamdo');
    int jeju = countries.indexOf('Jejudo');

    print("지도 색상 업데이트");

    return SMapSouthKoreaColors(
      kr11: changeMapColor(seoul), // 서울
      kr26: changeMapColor(busan), // 부산
      kr27: changeMapColor(daegu), // 대구
      kr28: changeMapColor(incheon), // 인천
      kr29: changeMapColor(gwangju), // 광주
      kr30: changeMapColor(daejeon), // 대전
      kr31: changeMapColor(ulsan), // 울산
      kr41: changeMapColor(gyeonggi), // 경기
      kr42: changeMapColor(gangwon), // 강원
      kr43: changeMapColor(chungcheongNorth), // 충청북도
      kr44: changeMapColor(chungcheongSouth), // 충청남도
      kr45: changeMapColor(jeollaNorth), // 전라북도
      kr46: changeMapColor(jeollaSouth), // 전라남도
      kr47: changeMapColor(gyeongsangNorth), // 경상북도
      kr48: changeMapColor(gyeongsangSouth), // 경상남도
      kr49: changeMapColor(jeju), // 제주
      kr50: changeMapColor(sejong), // 세종
    );
  }

// 진행률 별 색상 강도 조절
  Color? changeMapColor(int index) {
    int percent = (countryGet[index] / countryCount[index] * 100).toInt();
    Color? colorValue;

    if (percent < 10) {
      colorValue = Colors.white;
    } else if (10 <= percent && percent < 20) {
      colorValue = Colors.green[100];
    } else if (20 <= percent && percent < 30) {
      colorValue = Colors.green[100];
    } else if (30 <= percent && percent < 40) {
      colorValue = Colors.green[200];
    } else if (40 <= percent && percent < 50) {
      colorValue = Colors.green[200];
    } else if (50 <= percent && percent < 60) {
      colorValue = Colors.green[300];
    } else if (60 <= percent && percent < 70) {
      colorValue = Colors.green[400];
    } else if (70 <= percent && percent < 80) {
      colorValue = Colors.green[500];
    } else if (80 <= percent && percent < 90) {
      colorValue = Colors.green[500];
    } else if (90 <= percent && percent < 100) {
      colorValue = Colors.green[600];
    } else if (percent == 100) {
      colorValue = Colors.green[800];
    } else {
      colorValue = Colors.white;
    }

    return colorValue;
  }

  Color? attractChageColor(int percent) {
    Color? colorValue;

    if (percent < 10) {
      colorValue = Colors.grey;
    } else if (10 <= percent && percent < 20) {
      colorValue = Colors.red[700];
    } else if (20 <= percent && percent < 30) {
      colorValue = Colors.red[500];
    } else if (30 <= percent && percent < 40) {
      colorValue = Colors.orange[700];
    } else if (40 <= percent && percent < 50) {
      colorValue = Colors.orange[500];
    } else if (50 <= percent && percent < 60) {
      colorValue = Colors.blue[300];
    } else if (60 <= percent && percent < 70) {
      colorValue = Colors.blue[500];
    } else if (70 <= percent && percent < 80) {
      colorValue = Colors.blue[700];
    } else if (80 <= percent && percent < 90) {
      colorValue = Colors.green[300];
    } else if (90 <= percent && percent < 100) {
      colorValue = Colors.green[500];
    } else if (percent == 100) {
      colorValue = Colors.green;
    } else {
      colorValue = Colors.purple;
    }

    return colorValue;
  }
}
