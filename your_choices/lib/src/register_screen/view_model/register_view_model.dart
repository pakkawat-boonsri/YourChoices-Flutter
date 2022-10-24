import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_choices/src/utilities/show_snack_bar.dart';

class RegisterViewModel extends ChangeNotifier {
  String _selectedType = "customer";
  bool _isClick = false;
  bool _obscureText = true;
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  get getObscureText => _obscureText;

  setObscureText(bool value) {
    _obscureText = value;
  }

  bool get getIsClick => _isClick;

  setIsClick(bool value) {
    _isClick = value;
  }

  get getSelectedType => _selectedType;

  setSelectedType(checked) {
    _selectedType = checked;
    notifyListeners();
  }

  createUserWithEmailAndpassword(BuildContext context, String username,
      String email, String password , String type) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
        (value) async {
          final currentUser = auth.currentUser;
          if (type == "customer") {
            await db.collection("customer").doc(currentUser!.uid).set({
              "balance": 0,
              "username": username,
              "imgAvatar": "",
              "role": "101",
              "transaction": [{}],
            });
          } else if (type == "restaurant") {
            await db.collection("restaurant").doc(currentUser!.uid).set({
              "res_name": "",
              "description": "",
              "menu_list": [{}],
              "username": username,
              "imgAvatar": "",
              "role": "101",
              "transaction": [{}],
            });
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackbar(context, "Password is too weak! Change it!");
      } else if (e.code == 'email-already-in-use') {
        showSnackbar(context, "Email is already in use");
      } else if (e.code == 'invalid-email') {
        showSnackbar(context, "Invalid Email");
      }
    }
  }
}
