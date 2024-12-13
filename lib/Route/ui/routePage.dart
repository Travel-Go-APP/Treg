import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:xtyle/xtyle.dart';

class routePage extends StatefulWidget {
  const routePage({super.key});

  @override
  State<routePage> createState() => _routePageState();
}

class _routePageState extends State<routePage> {
  bool check = false;
  int pageindex = 0;
  final CarouselController _PageController = CarouselController();

  List<Widget> page = [
    const Card(color: Colors.black),
    const Card(color: Colors.yellow),
    const Card(color: Colors.blue),
  ];

  @override
  Widget build(BuildContext context) {
    double widthsize = MediaQuery.of(context).size.width;
    double heightsize = MediaQuery.of(context).size.height * 0.055;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: check
            ? Container(
                child: SearchBar(
                  trailing: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
                  constraints: BoxConstraints(maxWidth: widthsize, maxHeight: heightsize),
                  hintText: "검색어를 입력해주세요.",
                  textStyle: MaterialStateProperty.all(const TextStyle(fontFamily: 'GmarketSans')),
                  elevation: const MaterialStatePropertyAll(0),
                ),
              )
            : Appbarwidget(),
        centerTitle: true,
      ),
      body: Top10(),
    );
  }

  Widget Appbarwidget() {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(children: [
                const WidgetSpan(child: Icon(Icons.navigation_outlined)),
                WidgetSpan(
                  child: XtyleText(
                    " 경로",
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),
                  ),
                ),
              ]),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        check = !check;
                      });
                    },
                    icon: const Icon(Icons.search_rounded)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.person_outline_rounded)),
              ],
            )
          ],
        ));
  }

  Widget Top10() {
    return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.25,
          child: Stack(
            children: [
              CarouselSlider.builder(
                carouselController: _PageController,
                options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.24,
                    initialPage: 0,
                    autoPlay: true,
                    viewportFraction: 0.8,
                    enlargeCenterPage: true, // 중앙 페이지 크게
                    enableInfiniteScroll: true, // 무한 스크롤
                    pauseAutoPlayOnTouch: true, // 터치시, 일시 중지
                    onPageChanged: (index, reason) {
                      setState(() {
                        pageindex = index;
                      });
                    }),
                itemCount: page.length,
                itemBuilder: (context, viewindex, index) => SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: page[viewindex],
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 201, 201, 201),
                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.05)
                  ),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.03,
                  child: Text("${pageindex + 1} / ${page.length}"),
                ),
              )
            ],
          ));
  }

}
