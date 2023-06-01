import 'package:flutter/material.dart';

class HeightContainer extends StatelessWidget {
  final double height;

  const HeightContainer({
    Key? key,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
