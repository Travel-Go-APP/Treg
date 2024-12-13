import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:travel_go/Home/function/Geolocation.dart';
import 'package:travel_go/Home/model/StepCountModelAdapter.dart';
import 'package:travel_go/Home/ui/home.dart';
import 'package:travel_go/Login/function/UserModel.dart';
import 'package:travel_go/Login/function/apple_login.dart';
import 'package:travel_go/Login/function/kakao_login.dart';
import 'package:travel_go/Login/function/loginController.dart';
import 'package:travel_go/Login/ui/loginPage.dart';
import 'package:travel_go/Login/ui/new_user.dart';
import 'package:travel_go/style.dart';
import 'package:xtyle/xtyle.dart';
import 'package:travel_go/Home/model/StepCountModel.dart';

void main() async {
  await dotenv.load(fileName: 'assets/env/.env');
  WidgetsFlutterBinding.ensureInitialized(); // 위젯 바인딩
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark); // 상태바 색상
  await Hive.initFlutter(); // 데이터베이스 초기화
  // Hive.registerAdapter(StepCountModelAdapter());
  await Hive.openBox('stepBox'); // 데이터베이스 로딩
  KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_NATIVEAPPKEY']); // 카카오 초기화
  await NaverMapSdk.instance
      .initialize(clientId: dotenv.env['NAVERMAP_CLIENTID']); // 네이버맵 초기화
  Xtyle.init(
      configuration: XtyleConfig(mapper: {
    XtyleRegExp.korean: 'GmarketSans', // 한글 폰트
    XtyleRegExp.digit: 'GmarketSans', // 숫자 폰트
  }, defaultFontFamily: 'Inter' // 그 외 폰트 (영문)
          ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // builder: FToastBuilder(),
      debugShowCheckedModeBanner: false,
      color: Colors.blue,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: const LoadingPage(),
    );
  }
}

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final geoController = Get.put((LatLngController())); // 게이지 컨트롤러
  final LoginController loginController = LoginController();
  final AppleLogin appleLogin = AppleLogin();
  var loginModel = UserModel(Kakao_Login()); // 카카오 로그인
  String loadText = "";
  Timer? _timer;
  int _dotCount = 0;
  Timer? _loadingTimer;

  @override
  void initState() {
    // 주기적으로 로딩 텍스트 업데이트 (500ms마다)
    _loadingTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _dotCount = (_dotCount + 1) % 4; // 0, 1, 2, 3 반복
        loadText = "서버 연결중${"." * _dotCount}";
      });
    });

    // 1초 후 초기 설정 텍스트 표시
    Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        loadText = "서버 연결중..";
      });
    });

    Timer(const Duration(milliseconds: 2000), () async {
      // 로딩화면을 보여주기 위한 딜레이 (Splash Screen)

      // Get.off(() => const logined_Page()); // 메인화면

      // 먼저 IOS 유저라면, 애플 로그인 먼저 검사
      if (Platform.isIOS) {
        // 마지막 로그인이 애플인지 확인
        String? email = await appleLogin.getEmailPrefix();
        if (email != null && email.split('@')[1] == "appleid.com") {
          String? appletoken = await appleLogin.getIdentityToken();

          // 만약 애플 토큰이 있다면?
          if (appletoken != null) {
            List<String> jwtParts = appletoken.split('.');

            if (jwtParts.length == 3) {
              String payload = jwtParts[1];
              payload = base64.normalize(payload);

              final List<int> jsonData = base64.decode(payload);
              final Map<String, dynamic> userInfo =
                  jsonDecode(utf8.decode(jsonData));

              // exp 클레임 추출
              int exp = userInfo['exp'];

              // 현재 시간과 비교
              DateTime tokenExpiryDate =
                  DateTime.fromMillisecondsSinceEpoch(exp * 1000);
              DateTime now = DateTime.now();

              if (now.isAfter(tokenExpiryDate)) {
                print("토큰이 만료되었습니다.");
                appleLogin.firstloginApple();
              } else {
                print("토큰은 유효합니다.");
                String? appleEmail = await appleLogin.getEmailPrefix();
                bool check =
                    await loginController.registCheckResult(appleEmail!);
                if (check) {
                  // 서버에 등록된 유저이면,
                  print("등록된 애플 유저입니다 : $appleEmail");
                  Get.off(() => const logined_Page()); // 메인화면
                } else {
                  // 서버에 등록되지 않은 유저라면,
                  print("등록안된 애플 유저입니다 : $appleEmail");
                  Get.off(() => NewUser(email: appleEmail)); // 닉네임 생성 페이지
                }
              }
            } else {
              print("JWT 형식이 잘못되었습니다.");
              appleLogin.firstloginApple();
            }
          } else {
            print("저장된 애플 Identity Token이 없습니다.");
            await kakaoChech(); // 카카오 로그인 토큰 검사
            await kakaoLogin();
          }
        } else {
          await kakaoChech(); // 카카오 로그인 토큰 검사
          await kakaoLogin();
        }
        // 안드로이드는 카카오 로그인만 지원
      } else {
        await kakaoChech(); // 카카오 로그인 토큰 검사
        await kakaoLogin();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _loadingTimer?.cancel(); // 타이머 정리
    super.dispose();
  }

  Future kakaoLogin() async {
    if (loginModel.isLogined) {
      // 카카오에 로그인이 되어있는가?
      // 서버 데이터베이스에 등록이 되어있는가?
      bool check = await loginController
          .registCheckResult(loginModel.user!.kakaoAccount!.email!);
      if (check) {
        // 서버에 등록된 유저이면,
        Get.off(() => const logined_Page()); // 메인화면
      } else {
        // 서버에 등록되지 않은 카카오 유저라면,
        Get.off(() => NewUser(
            email: loginModel.user!.kakaoAccount!.email!)); // 닉네임 생성 페이지
      }
    } else {
      // 카카오에 로그인이 되어있지않다면,
      Get.off(() => const login_Page()); // SNS 로그인 페이지
    }
  }

  // kakaoChech 함수 수정
  Future kakaoChech() async {
    setState(() {
      loadText = "로그인 확인중"; // 로그인 확인 중일 때 텍스트 변경
    });

    if (await AuthApi.instance.hasToken()) {
      await loginModel.checkToken(); // 토큰 유효성 검사
      setState(() {
        // loadText = "토큰 유효성 검사 완료";
      });
    } else {
      _loadingTimer?.cancel(); // 더 이상 애니메이션 필요 없음
      Get.off(() => const login_Page()); // 로그인 페이지로 이동
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Logo.png',
              scale: 3,
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.05,
              child: XtyleText(loadText,
                  style: loadingText), // 값이 변하기에 const를 사용하지 않음
            )
          ],
        ),
      ),
    );
  }
}
