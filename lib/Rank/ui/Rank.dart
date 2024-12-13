import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:travel_go/Home/function/Geolocation.dart';
import 'package:travel_go/Login/function/apple_login.dart';
import 'package:travel_go/Rank/ui/rankController.dart';
import 'package:xtyle/xtyle.dart';
import 'package:http/http.dart' as http;
import '../../Home/function/userController.dart';

class rankPage extends StatefulWidget {
  const rankPage({super.key});

  @override
  State<rankPage> createState() => _RankPageState();
}

class _RankPageState extends State<rankPage> {
  final userLatLong = Get.put(LatLngController());
  final userData = Get.put(userController());
  final AppleLogin appleLogin = AppleLogin();
  final Rank rankController = Get.put(Rank(
    rankId: 0,
    email: '',
    nickname: '',
    level: 0,
    totalItem: 0,
    totalVisit: 0,
    score: 0,
  ));

  late Timer _timer;
  RxString remainingTime = "00:00:00".obs;
  RxDouble progressValue = 0.0.obs;

  @override
  void initState() {
    super.initState();
    rankController.myRankList();
    rankController.fetchRankList();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateRemainingTime();
    });
  }

  void _updateRemainingTime() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final duration = nextMidnight.difference(now);
    final totalDuration = Duration(hours: 24);

    if (duration.inSeconds <= 0) {
      rankController.fetchRankList();
    } else {
      remainingTime.value = _formatDuration(duration);
      progressValue.value =
          1.0 - (duration.inSeconds / totalDuration.inSeconds);
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          title: RichText(
            text: TextSpan(
              children: [
                const WidgetSpan(child: Icon(Icons.trending_up_outlined)),
                WidgetSpan(
                  child: Text(
                    " 랭킹",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Obx(() => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      XtyleText(
                        "랭킹 갱신까지 남은 시간: ${remainingTime.value}",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                        ),
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: 1.0 - progressValue.value,
                        backgroundColor: Colors.grey[300],
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.blue),
                        minHeight: 10,
                      ),
                    ],
                  ),
                )),
            Expanded(
              child: Obx(() {
                if (rankController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!rankController.rankNetwork.value) {
                  return Center(
                      child: Text('오류: ${rankController.errorMessage.value}'));
                } else if (rankController.rankList.isEmpty) {
                  return const Center(child: Text('데이터가 없습니다.'));
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: rankController.rankList.map((rank) {
                        return Container(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Card(
                            color: _getRankColor(rank.rankId),
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: ListTile(
                                contentPadding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                leading: Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 10),
                                  child: rank.rankId == 1
                                      ? Image.asset(
                                          "assets/images/ranks/Rank1.png",
                                          scale: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02,
                                        )
                                      : rank.rankId == 2
                                          ? Image.asset(
                                              "assets/images/ranks/Rank2.png",
                                              scale: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02,
                                            )
                                          : rank.rankId == 3
                                              ? Image.asset(
                                                  "assets/images/ranks/Rank3.png",
                                                  scale: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.02,
                                                )
                                              : CircleAvatar(
                                                  backgroundColor:
                                                      _getRankColor(rank.rankId,
                                                          isBackground: true),
                                                  child: XtyleText(
                                                      rank.rankId.toString()),
                                                ),
                                ),
                                title: XtyleText(rank.nickname,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w100,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.045)),
                                subtitle: XtyleText(
                                    '명소: ${rank.totalVisit}개 / 아이템: ${rank.totalItem}개'),
                                trailing: Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 30),
                                  child: XtyleText('Lv. ${rank.level}',
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05)),
                                )),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              }),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.11,
              decoration: const BoxDecoration(color: Colors.white),
            ),
          ],
        ),
        bottomSheet: Obx(() => Container(
              height: MediaQuery.of(context).size.height * 0.11,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.02),
              color: rankController.myRankData.isEmpty
                  ? Colors.white
                  : rankController.myRankData[0].rankId == 1
                      ? const Color.fromARGB(255, 255, 248, 189)
                      : rankController.myRankData[0].rankId == 2
                          ? const Color.fromARGB(255, 190, 190, 190)
                          : rankController.myRankData[0].rankId == 3
                              ? const Color.fromARGB(255, 195, 149, 134)
                              : Colors.white,
              child: _buildMyRankList(),
            )));
  }

  Color _getRankColor(int rankId, {bool isBackground = false}) {
    if (rankId == 1) {
      return isBackground
          ? Colors.yellow
          : const Color.fromARGB(255, 255, 248, 189);
    } else if (rankId == 2) {
      return isBackground
          ? const Color.fromARGB(255, 205, 205, 205)
          : const Color.fromARGB(255, 190, 190, 190);
    } else if (rankId == 3) {
      return isBackground
          ? const Color.fromARGB(255, 172, 122, 103)
          : const Color.fromARGB(255, 195, 149, 134);
    }
    return Colors.white;
  }

  Widget _buildMyRankList() {
    return Obx(() {
      if (rankController.myRankData.isEmpty) {
        return const Center(child: Text('내 랭킹 데이터가 없습니다.'));
      } else {
        final rank = rankController.myRankData.first; // 첫 번째 랭크 데이터 가져오기
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              XtyleText(
                rank.nickname,
                style: TextStyle(
                  fontSize: rank.nickname.length >= 5
                      ? MediaQuery.of(context).size.width * 0.05
                      : MediaQuery.of(context).size.width * 0.07,
                  fontWeight: FontWeight.bold,
                ),
              ),
              XtyleText(
                "현재 순위 : ${rank.rankId}등",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    fontWeight: FontWeight.w100),
              ),
            ],
          ),
        );
      }
    });
  }
}
