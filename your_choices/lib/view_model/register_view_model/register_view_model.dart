import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_choices/utilities/show_snack_bar.dart';

class RegisterViewModel extends ChangeNotifier {
  int? _selectedType;
  bool _isClick = false;
  bool _checkRadioError = false;
  bool isShowUsername = false;
  bool isShowEmail = false;
  bool isShowPassword = false;
  bool isShowConfirmPassword = false;
  String _state = "";

  bool _obscureText = true;
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  get getObscureText => _obscureText;

  setObscureText(bool value) {
    _obscureText = value;
  }

  get getRadioState => _checkRadioError;

  set setRadioState(bool value) {
    _checkRadioError = value;
  }

  get getStateValue => _state;

  setRadioValue(String value) {
    _state = value;
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
      String email, String password) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
        (value) async {
          final currentUser = auth.currentUser;
          if (_selectedType == 1) {
            db.collection("customer").doc(currentUser!.uid).set({
              "balance": 0,
              "username": username,
              "imgAvatar": "",
              "role": "101",
              "transaction": [{}],
            });
          } else if (_selectedType == 2) {
            db.collection("restaurant").doc(currentUser!.uid).set({
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
