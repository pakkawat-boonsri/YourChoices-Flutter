import 'package:flutter/material.dart';

TextFormField reuseableTextFormField(TextEditingController controller,
    bool isPasswordType, String text, IconData icon) {
  return TextFormField(
    controller: controller,
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
    autocorrect: !isPasswordType,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
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
      prefixIcon: Icon(
        icon,
        color: Colors.black,
      ),
    ),
  );
}
