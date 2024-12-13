import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:travel_go/Login/function/social_login.dart';

class Kakao_Login implements social_login {
  @override
  Future<bool> login() async {
    // 로그인
    try {
      bool isInstalled = await isKakaoTalkInstalled(); // 카카오톡이 설치되어있는지 확인
      if (isInstalled) {
        // 설치가 되어있다면
        try {
          await UserApi.instance.loginWithKakaoTalk(); // 카카오톡으로 로그인 진행
          print("카카오톡 로그인 시도");
          return true;
        } catch (e) {
          print("카카오톡 로그인을 시도했지만, 실패했습니다.");
          return false;
        }
      } else {
        // 설치가 되어있지않다면
        try {
          await UserApi.instance.loginWithKakaoAccount(); // 카카오계정으로 로그인 진행 (웹)
          print("카카오계정으로 로그인 시도");
          return true;
        } catch (e) {
          print("카카오계정으로 로그인을 시도했지만, 실패했습니다.");
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    // 로그아웃
    try {
      await UserApi.instance.unlink(); // 로그아웃
      /* 로그아웃을 성공하면, SDK에서 저장하고 있던 토큰이 자동으로 삭제됩니다. */
      print("카카오 로그아웃 시도");
      return true;
    } catch (e) {
      print("카카오 로그아웃을 시도했지만, 실패했습니다.");
      return false;
    }
  }

  @override
  Future<bool> checkToken() async {
    // 토큰 유효성 검사
    try {
      AccessTokenInfo tokenInfo =
          await UserApi.instance.accessTokenInfo(); // 토큰 검사
      print(
          '토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn} ${tokenInfo.appId}');
      if (tokenInfo.expiresIn >= 60) {
        print("남은 시간 : ${(tokenInfo.expiresIn / 60).ceil()}분");
      } else {
        print("남은 시간 : ${tokenInfo.expiresIn}초");
      }
      return true;
    } catch (error) {
      if (error is KakaoException && error.isInvalidTokenError()) {
        print('토큰 만료 $error');
      } else {
        print('토큰 정보 조회 실패 $error');
      }

      try {
        // 토큰 만료시, 카카오계정으로 로그인하여 토큰 재발행
        await UserApi.instance.loginWithKakaoAccount();
        print('로그인 성공');
        return true;
      } catch (error) {
        print('로그인 실패 $error');
        return false;
      }
    }
  }

  @override
  Future<bool> nullToken() async {
    // 발급된 토큰이 없다면 (=즉 아마, 로그인을 한 이력이 없을때?) ! 현재 사용하지 않음 !
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      print('로그인 성공 ${token.accessToken}');
      return true;
    } catch (error) {
      print('로그인 실패 $error');
      return false;
    }
  }
}
