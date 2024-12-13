import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:http/http.dart' as http;
import 'package:travel_go/Home/function/Geolocation.dart';
import 'package:travel_go/Login/function/apple_login.dart';
import 'package:intl/intl.dart';

class userController extends GetxController {
  RxBool connectingNetwork = false.obs;

  RxString nickname = "".obs; // 사용자 닉네임
  RxInt userLevel = 1.obs; // 사용자 레벨
  RxInt userExperience = 0.obs; // 사용자 현재 경험치 획득수치
  RxInt userNextLevelExp = 1000.obs; // 사용자 다음 레벨까지 필요한 총 경험치 수치
  RxDouble percentage = 0.0.obs; // 현재 경험치 퍼센트
  RxInt questCount = 0.obs; // 사용자 일일 미션 카운트
  RxString userShoes = "".obs; // 사용자 신발 등급
  RxInt userMaxSearch = 10.obs; // 사용자 최대 조사횟수
  RxInt userPossibleSearch = 10.obs; // 사용자 현재 남은 조사횟수
  RxDouble userDetectionRange = 0.0.obs; // 사용자 조사 범위
  RxDouble userExperienceX = 0.0.obs; // 사용자 추가 경험치 획득량
  RxDouble userTgX = 0.0.obs; // 사용자 추가 TG 획득량
  RxInt userTG = 0.obs; // 사용자 현재 TG 보유량
  RxInt missionCount = 0.obs; // 활동 포인트 미션 달성 유무 확인

  RxString city = "".obs; // 사용자 방문 위치 (고양시)
  RxString benefit = "".obs; // 사용자 방문 혜택 (XP X2)
  RxString benefitFull = "".obs; // 사용자 방문 혜택 fullname (레벨 경험치 획득량 2배)
  RxString period = "".obs; // 사용자 방문 혜택 기한 (2024-06-22(토) ~ 2024-06-29(토))

  RxInt tmp = 0.obs;
  RxString weather = "".obs;
  RxString pty = "".obs;

  final naverMap = Get.put(LatLngController()); // 네이버 지도 컨트롤러
  final AppleLogin appleLogin = AppleLogin();

  // 사용자 정보 불러오기
  Future<void> updateUser() async {
    var httpClient = http.Client();
    // String today = DateFormat('yyyyMMdd')
    //     .format(DateTime.now().subtract(const Duration(days: 1)));
    // print("현재날짜에서 하루 뺀 날 : $today");
    // User? user = await UserApi.instance.me(); // 사용자 정보 가져오기 요청
    String? email = await appleLogin.getEmailPrefix();
    var urlPath = dotenv.env['SERVER_URL'];
    final url = Uri.parse('$urlPath/api/user/get-main');
    var headers = {
      "accecpt": '*/*',
      'Content-Type': 'application/json',
    };
    var bodys = jsonEncode({
      "email": email,
      // "date": today,
      "latitude": naverMap.mylatitude.value,
      "longitude": naverMap.mylongitude.value
    });
    //print(bodys);

    try {
      var response = await httpClient.post(url, headers: headers, body: bodys);
      print("사용자 정보 받아오기 responseCode ${response.statusCode}");
      print("사용자 정보 : ${utf8.decode(response.bodyBytes)}");
      var responseData = jsonDecode(utf8.decode(response.bodyBytes));
      userTG.value = responseData['tg'];
      nickname.value = responseData['nickname'];
      userLevel.value = responseData['level'];
      city.value = responseData['visitArea'];
      benefitFull.value = responseData['visitBenefit'];
      userExperience.value = responseData['experience'];
      userNextLevelExp.value = responseData['nextLevelExp'];
      percentage.value = responseData['percentage'];
      userMaxSearch.value = responseData["maxSearch"];
      userPossibleSearch.value = responseData["possibleSearch"];
      benefit.value = responseData['visitBenefit'];
      missionCount.value = responseData['quest'];
      tmp.value = responseData['weatherDto']['tmp'];
      weather.value = responseData['weatherDto']['weather'];
      pty.value = responseData['weatherDto']['pty'];
    } catch (_) {}
  }

  Future<void> updateVisitBenfit() async {
    var httpClient = http.Client();

    // User? user = await UserApi.instance.me(); // 사용자 정보 가져오기 요청
    String? email = await appleLogin.getEmailPrefix();
    var urlPath = dotenv.env['SERVER_URL'];
    final url = Uri.parse(
        '$urlPath/api/geo/reverse?latitude=${naverMap.mylatitude}&longitude=${naverMap.mylongitude}');
    var headers = {
      "accept": '*/*',
      'Content-Type': 'application/json',
    };

    try {
      var response = await httpClient.post(url, headers: headers);
      print("responseCode ${response.statusCode}");
      print("지오코딩 : ${utf8.decode(response.bodyBytes)}");
      var responseData = jsonDecode(utf8.decode(response.bodyBytes));
      print("지오코딩 결과 : $responseData");

      if (city != responseData[1]) {
        print("위치 변경 !");
        updateUser();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> userDelete() async {
    var httpClient = http.Client();

    // User? user = await UserApi.instance.me(); // 사용자 정보 가져오기 요청
    String? email = await appleLogin.getEmailPrefix();
    var urlPath = dotenv.env['SERVER_URL'];
    final url = Uri.parse('$urlPath/api/user/user-delete?email=$email');
    var headers = {
      "accept": '*/*',
      'Content-Type': 'application/json',
    };

    try {
      var response = await httpClient.delete(url, headers: headers);
      print("responseCode ${response.statusCode}");
      print("유저 삭제 : ${utf8.decode(response.bodyBytes)}");
      var responseData = jsonDecode(utf8.decode(response.bodyBytes));
      print("유저 삭제 결과 : $responseData");
    } catch (e) {
      print("유저 삭제 에러 : $e");
    }
  }

  Future<void> updateSearch() async {
    if (0 < userPossibleSearch.value) {
      userPossibleSearch.value -= 1;
    }
  }

  // 조사하기 3회 충전
  Future<void> addSearch() async {
    userPossibleSearch.value += 10;
  }

  // 만약 감소시켰을때 값이 음수라면 0으로 하고, 그게 아니면 그대로 진행
  Future<void> getSearch(int search) async {
    int result = userPossibleSearch.value + search;
    if (result < 0) {
      userPossibleSearch.value = 0;
    } else {
      userPossibleSearch.value = result;
    }
  }

  Future<void> updateEXP() async {
    if (percentage < 100.0) {
      percentage.value += 25.0;
    } else {
      updateLevel();
    }
  }

  Future<void> updateLevel() async {
    percentage.value = 0;
    userLevel.value += 1;
  }
}
