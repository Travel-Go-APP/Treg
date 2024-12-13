import 'dart:convert';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:travel_go/Home/function/Geolocation.dart';
import 'package:travel_go/Home/function/userController.dart';
import 'package:travel_go/Login/function/apple_login.dart';
import 'package:travel_go/collection/ui/SelectedItemDetail.dart';
import 'package:travel_go/store/ui/draw.dart';
import 'package:travel_go/store/ui/tg_shop.dart';
import 'package:xtyle/xtyle.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class bottomNavStorePage extends StatefulWidget {
  const bottomNavStorePage({super.key});

  @override
  State<bottomNavStorePage> createState() => _bottomNavStorePageState();
}

class _bottomNavStorePageState extends State<bottomNavStorePage> {
  final userDate = Get.put(userController()); // 유저 컨트롤러
  final geoController = Get.put((LatLngController())); // 게이지 컨트롤러
  final AppleLogin appleLogin = AppleLogin();
  late FToast fToast;

  int _selectedIndex = 0;
  RxBool storeCheckNetwork = false.obs;

  final List<Widget> _widgetOptions = <Widget>[
    const tgShop(),
    const drawPage(),
  ];

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  _showToast(String text) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: const Color.fromARGB(255, 92, 150, 250),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const Icon(Icons.check),
          const SizedBox(
            width: 12.0,
          ),
          Text(text),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String tgCount = NumberFormat("###,###").format(userDate.userTG.value);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: RichText(
              text: TextSpan(children: [
                const WidgetSpan(child: Icon(Icons.store)),
                WidgetSpan(
                  child: XtyleText(
                    " 상점",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05),
                  ),
                ),
              ]),
            ),
            actions: [
              Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // XtyleText(tgCount),
                      Obx(() => AnimatedFlipCounter(
                            curve: Curves.easeInOutQuad,
                            wholeDigits:
                                userDate.userTG.value.toString().length,
                            value: userDate.userTG.value,
                            // suffix: " TG",
                            // decimalSeparator: ".",
                            thousandSeparator: ",",
                            duration: const Duration(
                                milliseconds: 1000), // 퍼센트와 시간을 맞추기 위해
                            textStyle: TextStyle(
                                // fontWeight: FontWeight.bold,
                                fontFamily: 'GmarketSans',
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035),
                          )),
                      const SizedBox(width: 3),
                      Text("TG",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 1, 113, 206),
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035))
                    ],
                  ))
            ],
            centerTitle: true,
          ),
          body: Container(
              child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/gift1.png",
                        scale: MediaQuery.of(context).size.width * 0.012,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const XtyleText("그냥그런 가죽 주머니",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Color.fromARGB(255, 104, 104, 104))),
                          const XtyleText("좋은건 잘 안뜰거 같다",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w300)),
                          ElevatedButton(
                              onPressed: userDate.userTG.value >= 3000
                                  ? () {
                                      alertBuyRandomBox(1);
                                    }
                                  : null,
                              child: const Text("3000 TG"))
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/gift2.png",
                        scale: MediaQuery.of(context).size.width * 0.012,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const XtyleText("지극히 평범한 박스",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Color.fromARGB(255, 65, 151, 68))),
                          const XtyleText("뭐가 나올지 모르는 박스다",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w300)),
                          ElevatedButton(
                              onPressed: userDate.userTG.value >= 5000
                                  ? () {
                                      alertBuyRandomBox(2);
                                    }
                                  : null,
                              child: const Text("5000 TG"))
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/gift4.png",
                        scale: MediaQuery.of(context).size.width * 0.012,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const XtyleText("전?설의 보물상자",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Color.fromARGB(255, 213, 196, 48))),
                          const XtyleText("가장 높은등급이 나올거 같다",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w300)),
                          ElevatedButton(
                              onPressed: userDate.userTG.value >= 9999
                                  ? () {
                                      alertBuyRandomBox(3);
                                    }
                                  : null,
                              child: const Text("9999 TG"))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
        ),
        Obx(
          () => Offstage(
            offstage: !storeCheckNetwork.value, // false면 감춰
            child: const Stack(children: <Widget>[
              //다시 stack
              Opacity(
                //뿌옇게~
                opacity: 0.1, //0.5만큼~
                child: ModalBarrier(
                    dismissible: false, color: Colors.black), //클릭 못하게~
              ),
              Center(
                child: CircularProgressIndicator(color: Colors.blue), //무지성 돌돌이~
              ),
            ]),
          ),
        )
      ],
    );
  }

  Future<void> alertBuyRandomBox(int gachaLevel) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: XtyleText(
                gachaLevel == 1
                    ? "그냥그런 가죽 주머니"
                    : gachaLevel == 2
                        ? "지극히 평범한 박스"
                        : "전?설의 보물상자",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                      gachaLevel == 1
                          ? "assets/images/gift1.png"
                          : gachaLevel == 2
                              ? "assets/images/gift2.png"
                              : "assets/images/gift4.png",
                      scale: MediaQuery.of(context).size.width * 0.012),
                  const SizedBox(height: 20),
                  Text(
                    gachaLevel == 1
                        ? "일반 ~ 지역 아이템 뽑기 (40%)\n2000 ~ 5000 TG (30%)\n30 ~ 80 EXP (30%)"
                        : gachaLevel == 2
                            ? "일반 ~ 지역 아이템 뽑기 (50%)\n3000 ~ 8000 TG (25%)\n50 ~ 110 EXP (25%)"
                            : "일반 ~ 지역 아이템 뽑기 (60%)\n6000 ~ 18000 TG (20%)\n80 ~ 200 EXP (20%)",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Text(
                      gachaLevel == 1
                          ? "3000 TG로 구매하시겠습니까?"
                          : gachaLevel == 2
                              ? "5000 TG로 구매하시겠습니까?"
                              : "9999 TG로 구매하시겠습니까?",
                      style: const TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold)),
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                Container(
                  width: context.width * 0.25,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // 알림창을 닫고
                      },
                      child: const XtyleText(
                        "취소",
                      )),
                ),
                Container(
                  width: context.width * 0.25,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () {
                        Navigator.of(context).pop();
                        randomBox(gachaLevel);
                      },
                      child: const XtyleText("구매",
                          style: TextStyle(color: Colors.white))),
                ),
              ],
            ));
  }

  Future<void> randomBox(int level) async {
    final AppleLogin appleLogin = AppleLogin();
    storeCheckNetwork.value = true; // 화면 움직이지 못하게 금지

    var httpClient = http.Client();

    // User? user = await UserApi.instance.me(); // 사용자 정보 가져오기 요청
    String? email = await appleLogin.getEmailPrefix();
    var urlPath = dotenv.env['SERVER_URL'];

    // GET 요청에서는 데이터를 쿼리 매개변수로 추가
    final url = Uri.parse(
        '$urlPath/api/item/shop?email=$email&gachaLevel=$level&latitude=${geoController.mylatitude}&longitude=${geoController.mylongitude}');

    var headers = {
      "accept": '*/*',
      'Content-Type': 'application/json',
    };

    try {
      var response = await httpClient.get(url, headers: headers);
      var responseData = jsonDecode(utf8.decode(response.bodyBytes));
      print("$level단계 뽑기 결과 : $responseData");

      int chageTG = 0;
      int chageEXP = 0;

      if (responseData["tgChange"] != null) {
        userDate.userTG.value = responseData["currentTg"];
        chageTG = responseData["tgChange"];
        int itemId = responseData["itemId"]; // 선택된 아이템 id
        int selectedItemRank = responseData["itemRank"]; // 선택된 아이템 등급
        String selectedItemName = responseData["itemName"]; // 선택된 아이템 이름
        // String selectedItemArea = responseData["area"]; // 선택된 아이템 지역
        String selectedItemSummary =
            responseData["itemSummary"]; // 선택된 아이템 간략글?
        String selectedItemDescription =
            responseData["itemDescription"]; // 선택된 아이템 내용?
        int itemPiece = responseData["itemPiece"];

        selectedItemDetail(
            context,
            itemId,
            selectedItemRank,
            selectedItemName,
            selectedItemSummary,
            selectedItemDescription,
            itemPiece,
            chageTG,
            chageEXP);
      } else if (responseData["itemName"] != null &&
          responseData["expChange"] != null) {
        userDate.userTG.value = responseData["currentTg"];
        userDate.userLevel.value = responseData["level"];
        userDate.userExperience.value = responseData["currentExperience"];
        userDate.userNextLevelExp.value = responseData["nextLevelExp"];
        userDate.percentage.value = responseData["experiencePercent"];
        chageEXP = responseData["expChange"];

        int itemId = responseData["itemId"]; // 선택된 아이템 id
        int selectedItemRank = responseData["itemRank"]; // 선택된 아이템 등급
        String selectedItemName = responseData["itemName"]; // 선택된 아이템 이름
        // String selectedItemArea = responseData["area"]; // 선택된 아이템 지역
        String selectedItemSummary =
            responseData["itemSummary"]; // 선택된 아이템 간략글?
        String selectedItemDescription =
            responseData["itemDescription"]; // 선택된 아이템 내용?
        int itemPiece = responseData["itemPiece"];

        selectedItemDetail(
            context,
            itemId,
            selectedItemRank,
            selectedItemName,
            selectedItemSummary,
            selectedItemDescription,
            itemPiece,
            chageTG,
            chageEXP);
      } else if (responseData["moneyChange"] != null &&
          responseData["moneyChange"] > 0) {
        userDate.userTG.value = responseData["currentTg"];
        _showToast("${responseData["moneyChange"]} TG 를 획득했습니다.");
      } else if (responseData["itemName"] == null &&
          responseData["expChange"] != null) {
        userDate.userTG.value = responseData["currentTg"];
        userDate.userLevel.value = responseData["level"];
        userDate.userExperience.value = responseData["currentExperience"];
        userDate.userNextLevelExp.value = responseData["nextLevelExp"];
        userDate.percentage.value = responseData["experiencePercent"];
        _showToast("${responseData["expChange"]} EXP 를 획득했습니다.");
      } else {
        userDate.userTG.value = responseData["currentTg"];
        int itemId = responseData["itemId"]; // 선택된 아이템 id
        int selectedItemRank = responseData["itemRank"]; // 선택된 아이템 등급
        String selectedItemName = responseData["itemName"]; // 선택된 아이템 이름
        // String selectedItemArea = responseData["area"]; // 선택된 아이템 지역
        String selectedItemSummary =
            responseData["itemSummary"]; // 선택된 아이템 간략글?
        String selectedItemDescription =
            responseData["itemDescription"]; // 선택된 아이템 내용?
        int itemPiece = responseData["itemPiece"];

        selectedItemDetail(
            context,
            itemId,
            selectedItemRank,
            selectedItemName,
            selectedItemSummary,
            selectedItemDescription,
            itemPiece,
            chageTG,
            chageEXP);
      }
    } catch (e) {
      print("랜덤 박스 결과 오류 : $e");
    }

    storeCheckNetwork.value = false; // 화면 움직이지 못하게 금지
  }
}
