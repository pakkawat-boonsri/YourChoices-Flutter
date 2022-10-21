import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_choices/utilities/show_snack_bar.dart';

class RegisterViewModel extends ChangeNotifier {
  var _isCustomerCheck = 1;
  var _isRestaurantCheck = 2;
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

  get getCustomerCheck => _isCustomerCheck;

  set setCustomerCheck(checked) {
    _isCustomerCheck = checked;
    notifyListeners();
  }

  get getRestaurantCheck => _isRestaurantCheck;

  setRestaurantCheck(checked) {
    _isRestaurantCheck = checked;
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
          
          if (getCustomerCheck == 1) {

          } else if (getRestaurantCheck == 2) {}
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
