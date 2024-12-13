import 'package:flutter/material.dart';
import 'package:travel_go/Login/repository/loginRepo.dart';

class LoginController{
  late final loginRepo loginrepo = loginRepo();

  nickCheckResult(String nickName) async {
    return await loginrepo.checkNick(nickName);
  }

  signUpResult(String email, String nickName) async {
    return await loginrepo.signUp(email, nickName);
  }

  registCheckResult(String email) async {
    return await loginrepo.checkRegist(email);
  }

}