import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:travel_go/Login/function/apple_login.dart';

class visitInfo extends GetxController {
  final AppleLogin appleLogin = AppleLogin();
  RxBool networkVisitList = false.obs;

  // 각 지역별 획득한 명소 리스트
  RxList<Map<String, dynamic>> visitList = <Map<String, dynamic>>[].obs;

  // Fetching data and updating the RxList
  Future<void> fetchVisitList(String area) async {
    var httpClient = http.Client();

    networkVisitList.value = true;

    var urlPath = dotenv.env['SERVER_URL'];
    String? email = await appleLogin.getEmailPrefix();
    final url = Uri.parse('$urlPath/api/visit/list?email=$email&area=$area');

    var headers = {
      "accept": '*/*',
      'Content-Type': 'application/json',
    };

    try {
      var response = await httpClient.get(url, headers: headers);
      var responseData =
          jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;

      // Update the RxList with new data
      visitList.assignAll(
          responseData.map((data) => data as Map<String, dynamic>).toList());

      print("획득한 지역 데이터 : $visitList");
    } catch (e) {
      print("Error: $e");
    }

    networkVisitList.value = false;
  }
}
