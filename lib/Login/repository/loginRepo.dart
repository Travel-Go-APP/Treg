import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_go/Login/provider/loginAPI.dart';

class loginRepo extends GetxController {
  late final LoginAPI login = LoginAPI();

  checkRegist(String email) async {
    if (await login.checkRegist(email) == 200) {
      return true;
    } else {
      return false;
    }
  }

  checkNick(String nickName) async {
    return login.checkNick(nickName);
    // if (await login.checkNick(nickName) == 200) {

    //     return true;
    //   } else{
    //     return false;
    // }
  }

  signUp(String email, String nickName) async {
    if (await login.signUp(email, nickName) == 200) {
      return true;
    } else {
      return false;
    }
  }
}
