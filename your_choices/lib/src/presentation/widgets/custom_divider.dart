// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final double horizontal;
  const CustomDivider({
    Key? key,
    this.horizontal = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal),
      child: const Divider(
        thickness: 1.5,
        color: Colors.grey,
      ),
    );
  }
}
