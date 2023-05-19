import 'package:flutter/material.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/utilities/hex_color.dart';

class CustomBackArrow extends StatelessWidget {
  const CustomBackArrow({super.key});

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: "B44121".toColor(),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_back,
          size: 25,
        ),
      ),
    );
  }
}
