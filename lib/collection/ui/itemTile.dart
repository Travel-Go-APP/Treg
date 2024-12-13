import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_go/Attraction/function/attraction_info.dart';
import 'package:travel_go/collection/function/itemController.dart';
import 'package:xtyle/xtyle.dart';

class itemTile extends GetxController {
  final items = Get.put(inventoryItems());
  final attractInfos = Get.put(attractInfo());

  Widget commonTile(BuildContext context) {
    double commonPercent =
        (items.commonEarn.value / items.commonCount.value) * 100;
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Container(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const XtyleText("공통", style: TextStyle(fontSize: 20)),
                      XtyleText(" ${items.commonEarn} / ${items.commonCount}",
                          style: const TextStyle(
                              fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                  XtyleText(
                      " ${commonPercent.isNaN ? 0 : commonPercent.toInt()}%",
                      style: TextStyle(
                          fontSize: 19,
                          color: attractInfos.attractChageColor(
                              (commonPercent.isNaN
                                  ? 0
                                  : commonPercent.toInt())))),
                ],
              ))),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                contextlist("일반", items.normalEarn.value,
                    items.normalCount.value, Colors.grey, context),
                contextlist("희귀", items.rareEarn.value, items.rareCount.value,
                    Colors.green, context),
                contextlist("영웅", items.epicEarn.value, items.epicCount.value,
                    Colors.purple, context),
                contextlist("전설", items.legendEarn.value,
                    items.legendCount.value, Colors.orange, context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget locationTile(BuildContext context) {
    double locationPercent =
        (items.locationEarn.value / items.locationCount.value) * 100;
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Container(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const XtyleText("지역", style: TextStyle(fontSize: 20)),
                      XtyleText(
                          " ${items.locationEarn.value} / ${items.locationCount.value}",
                          style: const TextStyle(
                              fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                  XtyleText(
                      " ${locationPercent.isNaN ? 0 : locationPercent.toInt()}%",
                      style: TextStyle(
                          fontSize: 19,
                          color: attractInfos.attractChageColor(
                              (locationPercent.isNaN
                                  ? 0
                                  : locationPercent.toInt())))),
                ],
              ))),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                contextlist(
                    "서울",
                    items.seoulCurrentItemCount.value,
                    items.seoulTotalItemCount.value,
                    const Color.fromARGB(255, 255, 81, 0),
                    context),
                contextlist(
                    "부산",
                    items.busanCurrentItemCount.value,
                    items.busanTotalItemCount.value,
                    const Color.fromARGB(255, 255, 81, 0),
                    context),
                contextlist(
                    "대구",
                    items.daeguCurrentItemCount.value,
                    items.daeguTotalItemCount.value,
                    const Color.fromARGB(255, 255, 81, 0),
                    context),
                contextlist(
                    "인천",
                    items.incheonCurrentItemCount.value,
                    items.incheonTotalItemCount.value,
                    const Color.fromARGB(255, 255, 81, 0),
                    context),
                contextlist(
                    "광주",
                    items.gwangjuCurrentItemCount.value,
                    items.gwangjuTotalItemCount.value,
                    const Color.fromARGB(255, 255, 81, 0),
                    context),
                contextlist(
                    "대전",
                    items.daejeonCurrentItemCount.value,
                    items.daejeonTotalItemCount.value,
                    const Color.fromARGB(255, 255, 81, 0),
                    context),
                contextlist(
                    "울산",
                    items.ulsanCurrentItemCount.value,
                    items.ulsanTotalItemCount.value,
                    const Color.fromARGB(255, 255, 81, 0),
                    context),
                contextlist(
                    "세종",
                    items.sejongCurrentItemCount.value,
                    items.sejongTotalItemCount.value,
                    const Color.fromARGB(255, 255, 81, 0),
                    context),
                contextlist(
                    "경기",
                    items.gyeonggiCurrentItemCount.value,
                    items.gyeonggiTotalItemCount.value,
                    const Color.fromARGB(255, 255, 81, 0),
                    context),
                contextlist(
                    "강원",
                    items.gangwonCurrentItemCount.value,
                    items.gangwonTotalItemCount.value,
                    const Color.fromARGB(255, 255, 81, 0),
                    context),
                contextlist(
                    "충청북도",
                    items.chungbukCurrentItemCount.value,
                    items.chungbukTotalItemCount.value,
                    const Color.fromARGB(255, 255, 81, 0),
                    context),
                contextlist(
                    "충청남도",
                    items.chungnamCurrentItemCount.value,
                    items.chungnamTotalItemCount.value,
                    const Color.fromARGB(255, 255, 81, 0),
                    context),
                contextlist(
                    "전라북도",
                    items.jeonbukCurrentItemCount.value,
                    items.jeonbukTotalItemCount.value,
                    const Color.fromARGB(255, 255, 81, 0),
                    context),
                contextlist(
                    "전라남도",
                    items.jeonnamCurrentItemCount.value,
                    items.jeonnamTotalItemCount.value,
                    const Color.fromARGB(255, 255, 81, 0),
                    context),
                contextlist(
                    "경상북도",
                    items.gyeongbukCurrentItemCount.value,
                    items.gyeongbukTotalItemCount.value,
                    const Color.fromARGB(255, 255, 81, 0),
                    context),
                contextlist(
                    "경상남도",
                    items.gyeongnamCurrentItemCount.value,
                    items.gyeongnamTotalItemCount.value,
                    const Color.fromARGB(255, 255, 81, 0),
                    context),
                contextlist(
                    "제주",
                    items.jejuCurrentItemCount.value,
                    items.jejuTotalItemCount.value,
                    const Color.fromARGB(255, 255, 81, 0),
                    context),
              ]))
        ],
      ),
    );
  }

  Widget contextlist(
      String Rating, int earn, int count, Color color, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 3, right: 3),
      padding: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3), // 배경색 설정
        borderRadius: BorderRadius.circular(12), // 외곽을 둥글게 설정
      ),
      height: MediaQuery.of(context).size.height * 0.032,
      child: Row(
        children: [
          XtyleText(Rating,
              style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          XtyleText(" $earn / $count"),
        ],
      ),
    );
  }
}
