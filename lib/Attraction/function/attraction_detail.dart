import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:travel_go/Login/function/apple_login.dart';

class attractDetail extends GetxController {
  // final AppleLogin appleLogin = AppleLogin();
  RxBool networkDetail = false.obs;
  RxString name = "".obs;
  RxString city = "".obs;
  RxString address = "".obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxString imageUrl = "".obs;
  RxString description = "".obs;

  // Fetching data and updating the RxList
  Future<void> visitDetail(int id) async {
    var httpClient = http.Client();

    var urlPath = dotenv.env['SERVER_URL'];
    // String? email = await appleLogin.getEmailPrefix();
    final url = Uri.parse('$urlPath/api/attraction/$id');

    networkDetail.value = true;

    var headers = {
      "accept": '*/*',
      'Content-Type': 'application/json',
    };

    try {
      var response = await httpClient.get(url, headers: headers);
      var responseData = jsonDecode(utf8.decode(response.bodyBytes));

      name.value = responseData['attractionName'];
      latitude.value = responseData['latitude'];
      longitude.value = responseData['longitude'];
      address.value = responseData['address'];
      imageUrl.value = responseData['attractionImageUrl'];
      description.value = responseData['description'];
    } catch (e) {
      print("Error: $e");
    }

    networkDetail.value = false;
  }
}
