// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/utilities/hex_color.dart';

import '../../../utilities/text_style.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onTap;
  final double hight;
  final double textSize;
  final FontWeight fontWeight;
  final Color textColor;
  const CustomAppbar({
    Key? key,
    required this.title,
    required this.onTap,
    this.hight = 56,
    this.textSize = 24,
    this.fontWeight = FontWeight.w500,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: TouchableOpacity(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: "B44121".toColor(),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back,
            size: 22,
          ),
        ),
      ),
      centerTitle: true,
      title: Text(
        title,
        style: AppTextStyle.googleFont(
          textColor,
          textSize,
          fontWeight,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(hight);
}
