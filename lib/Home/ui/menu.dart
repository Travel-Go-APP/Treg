// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:travel_go/Attraction/ui/Attraction.dart';
// import 'package:travel_go/Rank/ui/Rank.dart';
// import 'package:travel_go/collection/ui/collection.dart';
// import 'package:travel_go/package_Info.dart';
// import 'package:travel_go/setting.dart';
// import 'package:xtyle/xtyle.dart';

// final List<String> name = <String>["상점", "명소", "아이템", "랭킹", "설정"];
// final List<IconData> icons = <IconData>[Icons.store, Icons.account_balance_outlined, Icons.auto_awesome_outlined, Icons.trending_up_outlined, Icons.settings_outlined];
// final List<Color> colors = <Color>[Colors.red, Colors.green, Colors.blue, Colors.yellow, Colors.grey];
// final List page = [const attractionPage(), const collectionPage(), const rankPage(), const settingPage()];

// Widget menuList(BuildContext context) {
//   final packinfos = Get.put(packinfo()); // 걸음수 컨트롤러

//   return Positioned(
//     left: MediaQuery.of(context).size.width / 6,
//     bottom: MediaQuery.of(context).size.height * 0.15,
//     child: Column(
//       children: [
//         Image.asset('assets/images/Logo.png', scale: MediaQuery.of(context).devicePixelRatio * 1),
//         XtyleText("현재 버전: ${packinfos.version}"),
//         SizedBox(height: MediaQuery.of(context).size.height * 0.1),
//         for (int index = 0; index < 5; index++) menuButton(context, name[index], icons[index], colors[index], page[index]),
//       ],
//     ),
//   );
// }

// Widget menuButton(BuildContext context, String name, IconData icon, Color color, Widget page) {
//   return Container(
//     margin: const EdgeInsets.only(top: 10),
//     width: MediaQuery.of(context).size.width / 1.5,
//     height: MediaQuery.of(context).size.height * 0.09,
//     child: ElevatedButton(
//       style: ElevatedButton.styleFrom(side: BorderSide(width: 1, color: color), backgroundColor: color, elevation: 3),
//       onPressed: () {
//         Get.to(() => page);
//       },
//       child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
//         Icon(icon, size: MediaQuery.of(context).size.height * 0.04, color: Colors.white),
//         Stack(
//           children: [
//             XtyleText(name,
//                 style: TextStyle(
//                     fontSize: MediaQuery.of(context).size.width * 0.045,
//                     foreground: Paint()
//                       ..style = PaintingStyle.stroke
//                       ..strokeWidth = 2
//                       ..color = const Color.fromARGB(255, 114, 114, 114))),
//             XtyleText(name, style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.045, color: Colors.white)),
//           ],
//         )
//       ]),
//     ),
//   );
// }
