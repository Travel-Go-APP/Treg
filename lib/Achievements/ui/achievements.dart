import 'package:flutter/material.dart';
import 'package:xtyle/xtyle.dart';

class achievementsPage extends StatefulWidget {
  const achievementsPage({super.key});

  @override
  State<achievementsPage> createState() => _achievementsPageState();
}

class _achievementsPageState extends State<achievementsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(children: [
            const WidgetSpan(child: Icon(Icons.star_border)),
            WidgetSpan(
              child: XtyleText(
                " 업적",
                style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),
              ),
            ),
          ]),
        ),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
