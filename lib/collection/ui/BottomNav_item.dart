import 'dart:io';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:travel_go/Attraction/function/attraction_info.dart';
import 'package:travel_go/Home/function/events/getitem.dart';
import 'package:travel_go/Home/function/userController.dart';
import 'package:travel_go/Home/ui/event_examine.dart';
import 'package:travel_go/collection/function/itemController.dart';
import 'package:travel_go/collection/ui/SelectedItemDetail.dart';
import 'package:travel_go/collection/ui/itemTile.dart';
import 'package:xtyle/xtyle.dart';

class bottomNavItemPage extends StatefulWidget {
  const bottomNavItemPage({super.key});

  @override
  State<bottomNavItemPage> createState() => _bottomNavItemPageState();
}

class _bottomNavItemPageState extends State<bottomNavItemPage> {
  // 지역별 리스트
  final items = Get.put(inventoryItems());
  final item_list = Get.put(itemTile());
  final events = Get.put(event()); // 이벤트 컨트롤러
  late ScrollController? _scrollController;
  bool lastStatus = true;
  final GlobalKey _key = GlobalKey(); // 위치
  final attractInfos = Get.put(attractInfo());

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_isShrink != lastStatus) {
          setState(() {
            lastStatus = _isShrink;
          });
        }
      }); // 상단 스크롤 검사
    items.updateUseritem(); // 아이템 정보 불러오기
  }

  bool get _isShrink {
    return _scrollController != null &&
        _scrollController!.hasClients &&
        _scrollController!.offset >
            (MediaQuery.of(context).size.height *
                    (items.openListCommon.value ? 0.9 : 0.4) -
                kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              Obx(() => SliverAppBar(
                    // toolbarHeight: kToolbarHeight,
                    // forceElevated: true,
                    backgroundColor: Colors.white,
                    shadowColor: Colors.black, // 상단 스크롤 했을때 그림자
                    floating: false, // 스크롤을 했을시 bottom만 보이게 하고 싶을때
                    pinned: true, // 스크롤을 했을시, 상단이 고정되게 하고 싶을때
                    stretch: true, // 오버 스크롤시 영역을 채우는가?
                    title: RichText(
                      text: TextSpan(children: [
                        const WidgetSpan(
                            child: Icon(Icons.auto_awesome_outlined)),
                        WidgetSpan(
                          child: XtyleText(
                            " 아이템",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          ),
                        ),
                      ]),
                    ),
                    // actions: [],
                    centerTitle: true,
                    // 상단 높이
                    expandedHeight: MediaQuery.of(context).size.height * 0.4,
                    flexibleSpace: FlexibleSpaceBar(
                      // expandedTitleScale: 2,
                      centerTitle: true,
                      background: Container(
                          color: Colors.white,
                          margin: Platform.isAndroid
                              ? EdgeInsets.only(
                                  top: MediaQuery.of(context).padding.top * 3)
                              : EdgeInsets.only(
                                  top: MediaQuery.of(context).padding.top * 2),
                          child: Container(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    XtyleText("전체 수집률",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.07)),
                                    Obx(() => AnimatedFlipCounter(
                                          curve: Curves.easeInOutQuad,
                                          wholeDigits: 1,
                                          value: items.earnPercentage.toInt(),
                                          suffix: "%",
                                          duration: const Duration(
                                              milliseconds:
                                                  2500), // 퍼센트와 시간을 맞추기 위해
                                          textStyle: TextStyle(
                                              color: attractInfos
                                                  .attractChageColor(items
                                                      .earnPercentage
                                                      .toInt()),
                                              fontFamily: 'GmarketSans',
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.07),
                                        )),
                                  ],
                                ),
                                LinearPercentIndicator(
                                  center: XtyleText(
                                      "${items.earnItemCount} / ${items.totalItemCount}"),
                                  padding: const EdgeInsets.all(0),
                                  lineHeight:
                                      MediaQuery.of(context).size.height * 0.03,
                                  barRadius: Radius.circular(
                                      MediaQuery.of(context).size.width * 0.1),
                                  progressColor: attractInfos.attractChageColor(
                                      items.earnPercentage.toInt()),
                                  backgroundColor: Colors.white,
                                  percent: items.earnPercentage * 0.01,
                                  animation: true,
                                  animationDuration: 2500,
                                  animateFromLastPercent: true,
                                ),

                                item_list.commonTile(context), // 공통 아이템 리스트
                                item_list.locationTile(context), // 지역 아이템 리스트
                                Divider(
                                    height: MediaQuery.of(context).size.height *
                                        0.05),
                              ],
                            ),
                          )),
                    ),
                  )),
              Obx(() => items.itemPiece.isNotEmpty
                  ? SliverPadding(
                      key: _key,
                      padding: const EdgeInsets.only(
                          left: 20, right: 20), // 원하는 padding 설정
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16.0, // 간격 설정
                          crossAxisSpacing: 16.0, // 간격 설정
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Obx(() => (items.getItem.isNotEmpty &&
                                    items.itemPiece.isNotEmpty)
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 176, 217, 251),
                                      padding: const EdgeInsets.all(10),
                                      side: const BorderSide(
                                          width: 1.5, color: Colors.white),
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.width *
                                                0.06),
                                      ),
                                    ),
                                    onPressed: items.itemPiece[index] >= 10
                                        ? () {
                                            items.selectedUseritem(
                                                context, items.getItem[index]);
                                          }
                                        : null,
                                    child: Obx(() =>
                                        (items.getItem.isNotEmpty &&
                                                items.itemPiece.isNotEmpty)
                                            ? Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Image.asset(
                                                    "assets/item/${items.getItem[index]}.png",
                                                    color: items.itemPiece[
                                                                index] <
                                                            10
                                                        ? const Color.fromARGB(
                                                            255, 229, 229, 229)
                                                        : null,
                                                    colorBlendMode:
                                                        BlendMode.color,
                                                    // color: items.itemPiece[index] < 10
                                                    //     ? Colors.grey
                                                    //     : null,
                                                  ),
                                                  items.itemPiece[index] < 10
                                                      ? Positioned(
                                                          bottom: 0,
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.18,
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        189,
                                                                        189,
                                                                        189),
                                                                borderRadius: BorderRadius.circular(
                                                                    MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.04)),
                                                            child: XtyleText(
                                                                "${10 - items.itemPiece[index]}개 남음",
                                                                style: TextStyle(
                                                                    fontSize: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.03,
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        41,
                                                                        41,
                                                                        41))),
                                                          ))
                                                      : Container()
                                                ],
                                              )
                                            : Image.asset(
                                                "assets/images/Logo.png",
                                              )))
                                : Container());
                          },
                          childCount: items.getItem.length,
                        ),
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: Container(
                        alignment: Alignment.center,
                        child: const XtyleText("획득한 아이템이 없습니다.",
                            style: TextStyle(color: Colors.grey)),
                      ),
                    )),
              // 여백
              const SliverToBoxAdapter(
                child: SizedBox(height: 150),
              ),
            ],
          ),
          floatingActionButton: _isShrink
              ? FloatingActionButton.extended(
                  onPressed: () {
                    // 상단으로 이동
                    Scrollable.ensureVisible(
                      _key.currentContext!,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                    );
                  },
                  label: const XtyleText("상단으로"))
              : null,
        ),
        Obx(
          () => Offstage(
            offstage: !items.itemNetwork.value, // false면 감춰
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
}
