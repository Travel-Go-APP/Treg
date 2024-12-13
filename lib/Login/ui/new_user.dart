import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:travel_go/Home/ui/home.dart';
import 'package:travel_go/Login/function/loginController.dart';
import 'package:travel_go/style.dart';
import 'package:xtyle/xtyle.dart';

class NewUser extends StatefulWidget {
  final String? email;
  const NewUser({super.key, this.email});

  @override
  State<NewUser> createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  TextEditingController nicknameController = TextEditingController();
  bool fillForm = false; // 텍스트 필드가 채워져있는가?
  bool validatorNickname = false; // 1차 유효성 검사를 통과한 닉네임
  bool completeNickname = false; // 생성이 가능한 닉네임
  bool checking = false;
  String? nickname = '';
  String? errorname = '';
  String? stateText = '닉네임을 입력해주세요.';
  Timer? _timer;
  Color fieldColor = Colors.black;
  Color labelColor = Colors.grey;
  final LoginController loginController = LoginController();
  late String? userEmail = widget.email;

  // 이용약관 및 개인정보 처리방침 내용
  final String termsText = '''
제1조 (목적)

이 약관은 "Treg!"(이하 "서비스"라 함)의 제공과 이용에 관한 사항을 규정함을 목적으로 합니다.

제2조 (정의)

"서비스"란 TravelGo가 제공하는 "Treg!"의 모든 기능 및 서비스를 의미합니다.
"이용자"란 본 약관에 동의하고 서비스를 이용하는 자를 의미합니다.
"회원"은 서비스에 회원가입을 한 이용자를 의미합니다.
제3조 (약관의 효력 및 변경)

본 약관은 서비스에 공지하거나 기타 방법으로 이용자에게 통지함으로써 효력을 발생합니다.
TravelGo는 필요에 따라 약관을 변경할 수 있으며, 변경된 약관은 공지된 날로부터 효력이 발생합니다.
제4조 (회원가입)

회원가입은 본 약관에 동의한 후 이용자가 신청할 수 있습니다.
TravelGo는 가입신청에 대해 승낙할 의무가 있으며, 다음 각 호에 해당하는 경우에는 승낙을 하지 않을 수 있습니다.
신청 내용에 허위, 기재누락, 오기가 있는 경우
기타 TravelGo가 정한 이용신청 요건을 충족하지 못한 경우
제5조 (회원의 의무)

회원은 서비스 이용 시 다음 사항을 준수해야 합니다.
이용자의 정보를 정확하게 기재할 것
서비스의 이용 목적에 맞게 서비스를 이용할 것
타인의 권리를 침해하지 않을 것
제6조 (서비스의 중단)

TravelGo는 다음 각 호에 해당하는 경우 서비스의 전부 또는 일부를 중단할 수 있습니다.

시스템 점검, 보수 또는 공사로 인한 경우
기타 불가항력적인 사유로 서비스 제공이 불가능한 경우
제7조 (면책조항)

TravelGo는 천재지변, 불가항력적인 사유로 인한 서비스 중단에 대해 책임을 지지 않습니다.

개인정보 처리방침
제1조 (개인정보의 수집 및 이용 목적)

TravelGo는 회원가입 및 서비스 제공을 위해 아래와 같은 개인정보를 수집합니다.

이름, 이메일 주소, 위치 정보 등
제2조 (개인정보의 보유 및 이용 기간)

회원의 개인정보는 회원가입 시 수집되며, 회원 탈퇴 시 즉시 삭제됩니다.

제3조 (개인정보의 제3자 제공)

TravelGo는 이용자의 개인정보를 제3자에게 제공하지 않습니다. 단, 법률에 의한 요청이 있을 경우에는 예외로 합니다.

제4조 (이용자의 권리)

이용자는 언제든지 자신의 개인정보를 열람하거나 수정할 수 있으며, 개인정보 삭제를 요청할 수 있습니다.

제5조 (개인정보의 안전성 확보 조치)

TravelGo는 이용자의 개인정보를 안전하게 보호하기 위해 기술적, 관리적 조치를 취합니다.
  ''';

  final String privacyPolicyText = '''
제1조 (목적)

이 약관은 "Treg!"(이하 "서비스"라 함)에서 제공하는 위치 기반 서비스의 이용에 관한 사항을 규정함을 목적으로 합니다.

제2조 (정의)

"위치 기반 서비스"란 이용자의 위치 정보를 기반으로 제공되는 서비스 및 기능을 의미합니다.
"이용자"란 본 약관에 동의하고 위치 기반 서비스를 이용하는 자를 의미합니다.
제3조 (위치 정보의 수집 및 이용)

TravelGo는 서비스 제공을 위해 이용자의 위치 정보를 수집합니다.
위치 정보는 다음과 같은 목적으로 사용됩니다.
근처 명소 및 이벤트 정보 제공
개인화된 서비스 제공
서비스 이용 통계 분석
제4조 (위치 정보의 저장 및 보유)

TravelGo는 수집한 위치 정보를 서비스 개선 및 제공을 위해 필요한 기간 동안만 보유하며, 그 이후에는 즉시 삭제합니다.

제5조 (위치 정보의 제3자 제공)

TravelGo는 이용자의 동의 없이 위치 정보를 제3자에게 제공하지 않습니다.
단, 법률에 의한 요청이 있을 경우에는 예외로 합니다.
제6조 (이용자의 권리)

이용자는 언제든지 위치 정보의 수집 및 이용에 대한 동의를 철회할 수 있으며, 이 경우 서비스 이용에 제한이 있을 수 있습니다.

제7조 (위치 정보의 안전성 확보 조치)

TravelGo는 위치 정보를 안전하게 보호하기 위해 기술적, 관리적 조치를 취합니다.

제8조 (면책조항)

TravelGo는 위치 정보의 수집 및 이용과 관련하여 발생할 수 있는 모든 문제에 대해 책임을 지지 않습니다. 단, 고의 또는 중대한 과실이 있는 경우는 제외합니다.

제9조 (약관의 변경)

TravelGo는 필요에 따라 본 약관을 변경할 수 있으며, 변경된 약관은 서비스에 공지함으로써 효력을 발생합니다.
  ''';

  checkfill() {
    // 닉네임 필드가 채워져 있는지 검사
    if (nicknameController.text.isNotEmpty &&
        nicknameController.text.length >= 2) {
      fillForm = true;
      errorname = '';
    } else {
      fillForm = false;
      errorname = "최소 2자 이상 작성해주세요.";
    }
  }

  checkvalidator() {
    // 1차 유효성 검사
    if (nicknameController.text
        .contains(RegExp(r'[^\uAC00-\uD7A3A-Za-z0-9\s]', unicode: true))) {
      // 완성형 한글, 알파벳, 숫자, 공백을 제외한 모든 문자
      validatorNickname = false;
      errorname = "특수문자가 포함되어 있습니다.";
    } else if (nicknameController.text.contains(RegExp(r'[\s]'))) {
      // 공백 문자
      validatorNickname = false;
      errorname = "공백이 있어서는 안됩니다.";
    } else {
      // 문제 없다면
      validatorNickname = true;
    }
  }

  bool termsAccepted = false; // 이용약관 동의 상태
  bool locationServiceAccepted = false; // 위치 서비스 동의 상태

  // 약관 보기 함수
  void showTermsDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(content),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("확인"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 70), // 외부여백
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            XtyleText(
              "닉네임 생성",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.1),
            ),
            XtyleText(
              "서비스 이용할때 사용할 닉네임을 작성해주세요",
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
            ),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 30), // 외부여백
                  padding: const EdgeInsets.only(top: 30), // 외부여백,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontFamily: 'GmarketSans', color: Colors.black),
                    controller: nicknameController,
                    maxLength: 8, // 8자 제한
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(
                                MediaQuery.of(context).size.width * 0.03))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: fieldColor, width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(
                                MediaQuery.of(context).size.width * 0.1))),
                        labelText: stateText,
                        labelStyle: TextStyle(
                            fontFamily: 'GmarketSans',
                            fontWeight: FontWeight.bold,
                            color: labelColor),
                        contentPadding:
                            const EdgeInsets.all(5), // 텍스트 가려지는것을 방지?
                        suffixIcon: GestureDetector(
                            onTap: fillForm // 텍스트 필드 지우기
                                ? () {
                                    setState(() {
                                      fieldColor = Colors.black;
                                      labelColor = Colors.grey;
                                      nicknameController.clear();
                                      validatorNickname = false;
                                      completeNickname = false;
                                      stateText = '닉네임을 입력해주세요.';
                                      errorname = '';
                                      checkfill(); // 필드 검사
                                    });
                                  }
                                : null,
                            child: Icon(Icons.close,
                                color: fillForm ? showButton : hideButton))),
                    // 텍스트가 입력될때마다 검사
                    onChanged: (value) async {
                      // 초기에는 경고창 문구 공백, 버튼 비활성화
                      setState(() {
                        checking = false;
                        stateText = "";
                        completeNickname = false;
                        fieldColor = Colors.black;
                        labelColor = Colors.grey;
                      });

                      await checkfill(); // 필드 검사
                      await checkvalidator(); // 유효성 검사

                      // 이전 타이머가 존재한다면 취소합니다.
                      if (_timer != null) {
                        setState(() {
                          checking = false;
                        });
                        _timer!.cancel();
                      }
                      // 필드 & 유효성 검사 통과시
                      if (fillForm && validatorNickname) {
                        _timer =
                            Timer(const Duration(milliseconds: 1000), () async {
                          print("1.5초가 지났습니다");

                          setState(() {
                            checking = true;
                          });

                          int isNick = await loginController
                              .nickCheckResult(nicknameController.text);
                          if (isNick == 200) {
                            setState(() {
                              fieldColor = const Color.fromARGB(255, 0, 109, 4);
                              labelColor = const Color.fromARGB(255, 0, 87, 3);
                              completeNickname = true;
                              stateText = "사용이 가능한 닉네임 입니다.";
                            });
                          } else if (isNick == 404) {
                            setState(() {
                              labelColor = Colors.red;
                              fieldColor = Colors.red;
                              stateText = "이미 존재하는 닉네임입니다.";
                              completeNickname = false;
                            });
                          } else if (isNick == 400) {
                            setState(() {
                              labelColor = Colors.red;
                              fieldColor = Colors.red;
                              stateText = "부적절한 닉네임입니다.";
                              completeNickname = false;
                            });
                          } else {
                            setState(() {
                              labelColor = Colors.red;
                              fieldColor = Colors.red;
                              stateText = "오류 발생 : $isNick";
                              completeNickname = false;
                            });
                          }
                          setState(() {
                            checking = false;
                          });
                        });
                      } else if (value.isEmpty) {
                        setState(() {
                          fieldColor = Colors.black;
                          labelColor = Colors.grey;
                          stateText = '닉네임을 입력해주세요.';
                        });
                      } else {
                        setState(() {
                          labelColor = Colors.red;
                          fieldColor = Colors.red;
                          stateText = errorname;
                          completeNickname = false;
                        });
                      }
                      setState(() {
                        checking = false;
                      });
                    },
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  textAlign: TextAlign.start,
                  text: const TextSpan(children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.top,
                      child: Icon(Icons.trip_origin_sharp, size: 10),
                    ),
                    WidgetSpan(
                      child: XtyleText(" 특수문자, 공백 제외 2~8자",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                    WidgetSpan(
                      child: XtyleText("만 생성이 가능합니다."),
                    ),
                  ]),
                ),
                RichText(
                  textAlign: TextAlign.start,
                  text: const TextSpan(children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.top,
                      child: Icon(Icons.trip_origin_sharp, size: 10),
                    ),
                    WidgetSpan(
                      child: XtyleText(" 부적절한 닉네임은 고지없이 변경됩니다."),
                    ),
                  ]),
                ),
                RichText(
                  textAlign: TextAlign.start,
                  text: const TextSpan(children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.top,
                      child: Icon(Icons.trip_origin_sharp, size: 10),
                    ),
                    WidgetSpan(
                      child: XtyleText(" 닉네임은 최초 1회로 신중히 선택해주세요.",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold)),
                    ),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: termsAccepted,
                        onChanged: (value) {
                          setState(() {
                            termsAccepted = value!;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          // "이용약관 및 개인정보 처리방침 동의" 버튼 클릭 시 해당 페이지로 이동하게 할 수 있음
                          print("이용약관 및 개인정보 처리방침 보기");
                          showTermsDialog("이용약관", termsText);
                        },
                        child: RichText(
                          text: const TextSpan(children: [
                            TextSpan(
                              text: '이용약관 및 개인정보 처리방침 동의',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: locationServiceAccepted,
                        onChanged: (value) {
                          setState(() {
                            locationServiceAccepted = value!;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          // "위치 기반 서비스 이용약관 동의" 버튼 클릭 시 해당 페이지로 이동하게 할 수 있음
                          print("위치 기반 서비스 이용약관 보기");
                          showTermsDialog("위치 기반 서비스 이용약관", privacyPolicyText);
                        },
                        child: RichText(
                          text: const TextSpan(children: [
                            TextSpan(
                              text: '위치 기반 서비스 이용약관 동의',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(40),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: (completeNickname &&
                        termsAccepted &&
                        locationServiceAccepted)
                    ? () async {
                        print("이메일 : $userEmail");
                        bool iscomplete = await loginController.signUpResult(
                            userEmail!, nicknameController.text);
                        setState(() {
                          if (iscomplete) {
                            Get.off(() => const logined_Page()); // 메인 페이지로 이동
                          } else {
                            print(
                                "생성하기 실패 : \n 생성할려는 이메일 = $userEmail \n 생성할려는 닉네임 = ${nicknameController.text}");
                          }
                        });
                      }
                    : null,
                child: checking
                    ? const SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(color: Colors.blue),
                      )
                    : completeNickname
                        ? RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              WidgetSpan(
                                child: Text("\"${nicknameController.text}\" ",
                                    style: TextStyle(
                                        fontFamily: 'GmarketSans',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04)),
                              ),
                              WidgetSpan(
                                child: XtyleText("생성하기",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04)),
                              ),
                            ]),
                          )
                        : XtyleText('생성하기',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
