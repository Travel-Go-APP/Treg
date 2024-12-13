import 'package:flutter/material.dart';
import 'package:xtyle/xtyle.dart';

class userPage extends StatefulWidget {
  const userPage({super.key});

  @override
  State<userPage> createState() => _userPageState();
}

class _userPageState extends State<userPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.only(left: 20),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            XtyleText("USER", style: TextStyle(fontSize: 35))
          ],
        ),
      ),
    );
  }
}