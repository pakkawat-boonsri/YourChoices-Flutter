import 'package:flutter/material.dart';
import 'package:your_choices/utilities/text_style.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  const CustomText({
    super.key,
    required this.text,
    this.color = Colors.black,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyle.googleFont(color, fontSize, fontWeight),
      overflow: TextOverflow.ellipsis,
    );
  }
}
