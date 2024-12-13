import 'package:flutter/material.dart';
import 'package:get/get.dart';

class inventoryPage extends StatefulWidget {
  const inventoryPage({super.key});

  @override
  State<inventoryPage> createState() => _inventoryPageState();
}

class _inventoryPageState extends State<inventoryPage> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: MediaQuery.of(context).size.width * 0.06,
        crossAxisSpacing: MediaQuery.of(context).size.width * 0.06,
      ),
      itemCount: 100,
      itemBuilder: (BuildContext context, int index) {
        return ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(0),
                side: const BorderSide(width: 1, color: Colors.black),
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.04))),
            onPressed: () {},
            child: Image.asset("assets/item/한라봉.png",
                scale: MediaQuery.of(context).size.width * 0.018));
      },
    );
  }
}
