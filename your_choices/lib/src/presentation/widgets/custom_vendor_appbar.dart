
import 'package:flutter/material.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/utilities/hex_color.dart';

import '../../../utilities/text_style.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onTap;
  final double hight;
  const CustomAppbar({
    super.key,
    required this.title,
    required this.onTap,
    this.hight = 56,
  });

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
          Colors.black,
          24,
          FontWeight.w500,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(hight);
}
