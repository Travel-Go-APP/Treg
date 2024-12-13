import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:xtyle/xtyle.dart';

class LoginAPI {
  var httpClient = http.Client();
  late FToast fToast;

  _showToast(String text) {
    fToast = FToast();
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.orange,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const Icon(Icons.warning),
          const SizedBox(
            width: 12.0,
          ),
          XtyleText(text),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

// 로그인
  checkRegist(String email,
      {int retryCount = 3, int timeoutSeconds = 30}) async {
    var urlPath = dotenv.env['SERVER_URL'];
    final url = Uri.parse('$urlPath/api/user/login?email=$email');
    var headers = {
      "accept": '*/*', // 오타 수정
    };
    var body = jsonEncode({"email": email});

    for (int attempt = 0; attempt < retryCount; attempt++) {
      print("$attempt 번째 요청 시도");
      try {
        // 요청에 타임아웃 설정
        var response = await httpClient
            .post(url, headers: headers, body: body)
            .timeout(Duration(seconds: timeoutSeconds));

        // 응답이 성공적일 때
        print("로그인 성공! responseCode: ${response.statusCode}");
        return response.statusCode;
      } on TimeoutException catch (_) {
        // 타임아웃 예외 처리
        print("요청이 ${timeoutSeconds}초 동안 응답이 없어 타임아웃되었습니다.");
        //_showToast("서버 연결을 재시도 합니다. (${attempt + 1}/$retryCount)");
      } catch (error) {
        print("기타 에러 발생");
        // 기타 오류 발생 시
        //_showToast("서버 연결을 재시도 합니다. (${attempt + 1}/$retryCount)");
      }

      // 재시도 횟수를 모두 소진한 경우 처리
      if (attempt == retryCount - 1) {
        print("재시도를 모두 소모했지만 연결 실패");
        //_showToast("서버와 연결을 실패했습니다.");
        return null;
      }

      // 재시도 전 일정 시간 대기 (예: 2초)
      await Future.delayed(const Duration(seconds: 2));
    }
  }

// 닉네임 유효성 검사
  checkNick(String nickName, {int retryCount = 3}) async {
    var urlPath = dotenv.env['SERVER_URL'];
    final url =
        Uri.parse('$urlPath/api/user/check-nickname?nickName=$nickName');
    var headers = {
      "accept": '*/*', // 오타 수정
      'Content-Type': 'application/json'
    };
    var bodys = jsonEncode({"nickname": nickName});

    for (int attempt = 0; attempt < retryCount; attempt++) {
      try {
        var response =
            await httpClient.post(url, headers: headers, body: bodys);

        print("닉네임 유효성 검사 성공! responseCode: ${response.statusCode}");

        return response.statusCode;
      } catch (error) {
        // 오류 발생 시 Toast로 표시
        _showToast("서버 연결을 재시도 합니다. (${attempt + 1}/$retryCount)");

        // 재시도 횟수를 모두 소진한 경우 처리
        if (attempt == retryCount - 1) {
          _showToast("닉네임 유효성 검사에 실패했습니다.");
          return null; // 실패 시 반환 값
        }

        // 재시도 전 일정 시간 대기 (예: 2초)
        await Future.delayed(Duration(seconds: 2));
      }
    }
  }

// 회원가입
  signUp(String email, String nickName, {int retryCount = 3}) async {
    var urlPath = dotenv.env['SERVER_URL'];
    final url = Uri.parse('$urlPath/api/user/signup');
    var headers = {
      "accept": '*/*', // 오타 수정
      'Content-Type': 'application/json'
    };
    var bodys = jsonEncode({"email": email, "nickname": nickName});

    for (int attempt = 0; attempt < retryCount; attempt++) {
      try {
        var response =
            await httpClient.post(url, headers: headers, body: bodys);

        print("회원가입 성공! responseCode: ${response.statusCode}");

        // 성공 시 response 코드와 함께 Toast 메시지 표시

        // Fluttertoast.showToast(
        //   msg: "회원가입에 성공하셨습니다.",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.BOTTOM,
        // );

        return response.statusCode;
      } catch (error) {
        // 오류 발생 시 Toast로 표시
        _showToast("서버 연결을 재시도 합니다. (${attempt + 1}/$retryCount)");

        // 재시도 횟수를 모두 소진한 경우 처리
        if (attempt == retryCount - 1) {
          _showToast("회원가입에 실패했습니다. 다시 시도해주세요.");
          return null; // 실패 시 반환 값
        }

        // 재시도 전 일정 시간 대기 (예: 2초)
        await Future.delayed(Duration(seconds: 2));
      }
    }
  }
}
