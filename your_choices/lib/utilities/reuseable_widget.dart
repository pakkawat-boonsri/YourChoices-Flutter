import 'package:flutter/material.dart';

BoxShadow boxShadow() {
  return BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 5,
    blurRadius: 7,
    offset: const Offset(0, 2),
  );
}

TextFormField textFormField(
  TextEditingController controller,
  TextInputType type,
  bool isPassword,
  String text,
  String validateText,
) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    autocorrect: !isPassword,
    obscureText: isPassword,
    enableSuggestions: !isPassword,
    decoration: InputDecoration(
      hintText: text,
      labelText: text,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.amber.shade900,
          width: 1.5,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.amber.shade900,
          width: 1.5,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      prefixIcon: const Icon(
        Icons.lock_outline,
        color: Colors.black,
      ),
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return validateText;
      }
      return null;
    },
  );
}
