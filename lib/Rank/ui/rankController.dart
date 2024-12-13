import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:travel_go/Home/function/Geolocation.dart';
import 'package:travel_go/Home/function/userController.dart';
import 'package:travel_go/Login/function/apple_login.dart';

class Rank extends GetxController {
  // 네트워크 상태와 랭킹 리스트를 관리하는 Rx 변수들
  RxBool rankNetwork = false.obs; // 네트워크 상태 플래그
  RxList<Rank> rankList = <Rank>[].obs; // 전체 랭킹 리스트
  RxList<Rank> myRankData = <Rank>[].obs; // 내 랭킹 데이터
  RxBool isLoading = true.obs; // 로딩 상태 플래그
  RxString errorMessage = ''.obs; // 에러 메시지

  final userlatlong = Get.put(LatLngController());
  final userDate = Get.put(userController());
  final AppleLogin appleLogin = AppleLogin();

  final int rankId;
  final String email;
  final String nickname;
  final int level;
  final int totalItem;
  final int totalVisit;
  final int score;

  Rank({
    required this.rankId,
    required this.email,
    required this.nickname,
    required this.level,
    required this.totalItem,
    required this.totalVisit,
    required this.score,
  });

  // JSON을 Dart 객체로 변환하는 팩토리 생성자
  factory Rank.fromJson(Map<String, dynamic> json) {
    return Rank(
      rankId: json['rankId'],
      email: json['email'],
      nickname: json['nickname'],
      level: json['level'],
      totalItem: json['totalItem'],
      totalVisit: json['totalVisit'],
      score: json['score'],
    );
  }

  // 전체 랭킹을 가져오는 함수
  Future<void> fetchRankList() async {
    print("랭킹 시작");
    var httpClient = http.Client();
    var urlPath = dotenv.env['SERVER_URL'];
    final url = Uri.parse('$urlPath/api/rank/all-user-rank');

    var headers = {
      "accept": '*/*',
      'Content-Type': 'application/json',
    };

    try {
      isLoading.value = true; // 로딩 시작
      var response = await httpClient.get(url, headers: headers);
      print("전체 랭킹 responseCode ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseData = jsonDecode(utf8.decode(response.bodyBytes));
        //print(responseData);
        // JSON 데이터를 List<Rank>로 변환
        rankList.value =
            (responseData as List).map((item) => Rank.fromJson(item)).toList();
        rankNetwork.value = true; // 네트워크 성공
        errorMessage.value = ''; // 에러 메시지 초기화
      } else {
        rankNetwork.value = false; // 네트워크 실패
        errorMessage.value = "서버 응답 오류: ${response.statusCode}";
      }
    } catch (e) {
      rankNetwork.value = false; // 네트워크 실패
      errorMessage.value = "랭킹 에러: $e";
    } finally {
      isLoading.value = false; // 로딩 끝
      httpClient.close(); // HTTP 클라이언트 종료
    }
  }

  // 내 랭킹을 가져오는 함수
  Future<void> myRankList() async {
    String? email = await appleLogin.getEmailPrefix();
    var urlPath = dotenv.env['SERVER_URL'];
    var httpClient = http.Client();
    final url = Uri.parse('$urlPath/api/rank/user-rank?email=$email');

    var headers = {
      "accept": '*/*',
      'Content-Type': 'application/json',
    };

    try {
      var response = await httpClient.get(url, headers: headers);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(utf8.decode(response.bodyBytes));
        myRankData.assignAll([Rank.fromJson(responseData)]); // RxList로 업데이트
        //print("내 랭킹: $myRankData");
      } else {
        print("Error fetching my rank data: ${response.statusCode}");
      }
    } catch (e) {
      print("랭킹 에러: $e");
    } finally {
      httpClient.close(); // HTTP 클라이언트 종료
    }
  }
}
