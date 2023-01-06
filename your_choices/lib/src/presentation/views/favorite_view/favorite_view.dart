import 'package:flutter/material.dart';
import 'package:your_choices/utilities/text_style.dart';

class FavoriteView extends StatefulWidget {
  final String uid;
  const FavoriteView({super.key, required this.uid});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "รายการร้านอาหารที่ชอบ",
          style: AppTextStyle.googleFont(
            Colors.black,
            20,
            FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.blueGrey,
            )
          ],
        ),
      ),
    );
  }
}
