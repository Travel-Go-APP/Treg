import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:travel_go/Login/function/UserModel.dart';
import 'package:travel_go/Login/function/apple_login.dart';
import 'package:travel_go/Login/function/kakao_login.dart';
import 'package:travel_go/Home/ui/home.dart';
import 'package:travel_go/Login/function/loginController.dart';
import 'package:travel_go/Login/ui/new_user.dart';
import 'package:travel_go/style.dart';
import 'package:xtyle/xtyle.dart';

class login_Page extends StatefulWidget {
  const login_Page({super.key});

  @override
  State<login_Page> createState() => _login_PageState();
}

class _login_PageState extends State<login_Page> {
  final LoginController loginController = LoginController();
  final AppleLogin appleLogin = AppleLogin();
  var loginModel = UserModel(Kakao_Login()); // 카카오 로그인

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              'assets/images/Logo.png',
              scale: 3,
            ),
            Column(
              children: [
                // IOS만 애플 로그인 버튼 보이게 만듬
                Platform.isIOS
                    ? InkWell(
                        child: Image.asset('assets/images/apple_login.png',
                            scale: 2.3),
                        onTap: () async {
                          await appleLogin.firstloginApple(); // 첫 애플 로그인
                        },
                      )
                    : Container(),
                const SizedBox(height: 20),
                InkWell(
                  child:
                      Image.asset('assets/images/kakao_login.png', scale: 2.3),
                  onTap: () async {
                    // print("값은 ${await KakaoSdk.origin}");
                    await loginModel.login();
                    if (loginModel.isLogined) {
                      // SNS 로그인에 성공했으면,
                      bool check = await loginController.registCheckResult(
                          loginModel.user!.kakaoAccount!.email!);
                      if (check) {
                        // 서버에 등록된 유저이면,
                        Get.off(() => const logined_Page()); // 메인화면
                      } else {
                        // 서버에 등록되지 않은 유저라면,
                        print("서버에 등록되지 않은 카카오 유저입니다.");
                        Get.off(() => NewUser(
                            email: loginModel
                                .user!.kakaoAccount!.email!)); // 닉네임 생성 페이지
                      }
                    } else {
                      print("SNS 로그인에 실패했습니다.");
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
