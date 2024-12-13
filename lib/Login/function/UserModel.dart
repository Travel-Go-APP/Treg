import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:travel_go/Login/function/apple_login.dart';
import 'package:travel_go/Login/function/social_login.dart';

class UserModel {
  final AppleLogin appleLogin = AppleLogin();
  final social_login _social_login;
  bool isLogined = false; // 로그인이 되어 있는지 체크
  User? user; // 로그인한 사용자 정보
  bool istoken = false; // 토큰이 있는지 체크

  UserModel(this._social_login);

  Future login() async {
    isLogined = await _social_login.login(); // 로그인 시도
    if (isLogined) {
      // 로그인 성공시
      user = await UserApi.instance.me(); // 사용자 정보 가져오기 요청
      print("카카오 로그인 성공, ${user!.kakaoAccount}");
      String? email = user!.kakaoAccount!.email;
      await appleLogin.saveEmailPrefix(email!);
    }
  }

  Future logout() async {
    // 로그아웃
    await _social_login.logout(); // 로그아웃 시도
    isLogined = false;
    user = null; // 사용자 정보 제거
  }

  Future checkToken() async {
    // 토큰 유효성 검사
    istoken = await _social_login.checkToken();
    if (istoken) {
      // 토큰이 유효하다면
      isLogined = true;
      user = await UserApi.instance.me(); // 사용자 정보 가져오기 재요청
      // print("카카오 토큰 확인 완료, ${user!.kakaoAccount}");
      String? email = user!.kakaoAccount!.email;
      await appleLogin.saveEmailPrefix(email!);
    }
  }

  Future nullToken() async {
    // 토큰이 없다면
    istoken = await _social_login.nullToken();
    if (istoken) {
      // 토큰이 유효하다면
      isLogined = true;
      user = await UserApi.instance.me(); // 사용자 정보 가져오기 재요청
      // print("카카오 토큰 발급 완료, ${user!.kakaoAccount}");
      String? email = user!.kakaoAccount!.email;
      await appleLogin.saveEmailPrefix(email!);
    }
  }

  Future Refresh_user() async {
    isLogined = true;
    user = await UserApi.instance.me();
    print("유저 데이터 갱신 완료, ${user!.kakaoAccount}");
    String? email = user!.kakaoAccount!.email;
    await appleLogin.saveEmailPrefix(email!);
  }
}
