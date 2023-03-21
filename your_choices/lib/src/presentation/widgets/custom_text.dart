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
    required this.color,
    required this.fontSize,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        style: AppTextStyle.googleFont(color, fontSize, fontWeight),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
