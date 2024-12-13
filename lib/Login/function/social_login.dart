abstract class social_login {
  Future<bool> login(); // 로그인
  Future<bool> logout(); // 로그아웃
  Future<bool> checkToken(); // 토큰 확인
  Future<bool> nullToken(); // 토큰이 없다면
}

/* 이후, 추가될 수 있는 플랫폼(구글, 네이버 등)을 생각해서,
동일하게 사용이 가능하게 만들기 위해 추상클래스로 정의해서 구현. (확장성) */

// bool 함수로 로그인 성공 유무 판단