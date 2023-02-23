import 'package:flutter/material.dart';

class BoxShadowStyle {
  static BoxShadow boxShadow1() {
    return BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 5,
      blurRadius: 7,
      offset: const Offset(0, 2),
    );
  }

  static BoxShadow boxShadow2() {
    return BoxShadow(
      color: Colors.amberAccent.withOpacity(0.5),
      spreadRadius: 2,
      blurRadius: 2,
      // offset: const Offset(0, 2),
    );
  }
}
