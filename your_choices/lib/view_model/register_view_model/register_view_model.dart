import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_choices/utilities/show_snack_bar.dart';

class RegisterViewModel extends ChangeNotifier {
  int? _selectedType;
  bool _isLoading = false;
  bool _isClick = false;
  final auth = FirebaseAuth.instance;
  bool get getIsLoading => _isLoading;

  setIsLoading(bool value) {
    _isLoading = value;
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

  final List<Map> data = [
    {'value': 1, 'display': 'Customer'},
    {'value': 2, 'display': 'Restaurant'},
  ];

  createUserWithEmailAndpassword(BuildContext context, String username,
      String email, String password) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
        (value) async {
          final currentUser = auth.currentUser;

          if (_selectedType == 1) {
          } else if (_selectedType == 2) {}
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
