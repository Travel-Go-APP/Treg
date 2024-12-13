import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:travel_go/Home/ui/home.dart';
import 'package:travel_go/Login/function/loginController.dart';
import 'package:travel_go/Login/ui/new_user.dart';

class AppleLogin {
  // 변경된 이메일 로컬 저장
  Future<void> saveEmailPrefix(String emailPrefix) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('emailPrefix', emailPrefix);
    print("Email prefix 저장됨");
  }

  // 로컬에 저장된 이메일 정보 가져오기
  Future<String?> getEmailPrefix() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('emailPrefix');
  }

  // 로컬에 저장된 이메일 정보 삭제하기
  Future<void> removeEmailPrefix() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('emailPrefix');
  }

  // 애플 토큰 로컬 저장
  Future<void> saveIdentityToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('identityToken', token);
    // print("Identity Token 저장됨");
  }

  // 로컬에 저장된 애플 토큰 정보 가져오기
  Future<String?> getIdentityToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('identityToken');
  }

  // 로컬에 저장된 애플 토큰 정보 삭제하기
  Future<void> removeIdentityToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('identityToken');
  }

  final LoginController loginController = LoginController();

  // 첫 애플 로그인
  Future<void> firstloginApple() async {
    SignInWithApple.getAppleIDCredential(scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ]).then((AuthorizationCredentialAppleID user) async {
      await saveIdentityToken(user.identityToken!);

      List<String> jwt = user.identityToken?.split('.') ?? [];
      String payload = jwt[1];
      payload = base64.normalize(payload);

      final List<int> jsonData = base64.decode(payload);
      final userInfo = jsonDecode(utf8.decode(jsonData));
      // print(userInfo);

      String email = userInfo['email'];

      // 이메일에서 '@' 앞부분만 추출
      String emailPrefix = "${email.split('@')[0]}@appleid.com";
      // print("저장되는 애플 이메일 : $emailPrefix");

      // emailPrefix를 로컬에 저장
      await saveEmailPrefix(emailPrefix);

      String? appleEmail = await getEmailPrefix();
      bool check = await loginController.registCheckResult(appleEmail!);
      if (check) {
        // 서버에 등록된 유저이면,
        // print("등록된 애플 유저입니다 : $emailPrefix");
        Get.off(() => const logined_Page()); // 메인화면
      } else {
        // 서버에 등록되지 않은 유저라면,
        // print("등록안된 애플 유저입니다 : $emailPrefix");
        Get.off(() => NewUser(email: emailPrefix)); // 닉네임 생성 페이지
      }
    }).onError((error, stackTrace) {
      if (error is PlatformException) return;
      print(error);
    });
  }
}
