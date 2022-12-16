import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:your_choices/src/presentation/views/login_view/login_view.dart';
import 'package:your_choices/src/presentation/views/main_view/main_view.dart';
import 'package:your_choices/utilities/show_snack_bar.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool _isClick = false;
  final auth = FirebaseAuth.instance;
  final firestoreDB = FirebaseFirestore.instance;

  bool get getIsLoading => _isLoading;

  setIsLoading(bool value) {
    _isLoading = value;
  }

  bool get getIsClick => _isClick;

  setIsClick(bool value) {
    _isClick = value;
  }

  handleAuthState() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const MainView();
        } else {
          return const LoginView();
        }
      },
    );
  }

  signInWithEmaillAndPassword(
      String email, String password, BuildContext context) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return showSnackbar(context, e.code);
      } else if (e.code == 'wrong-password') {
        return showSnackbar(context, e.code);
      }
    }
  }

  Future signOut(BuildContext context) async {
    try {
      auth.signOut();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginView(),
          ),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message!);
    }
  }
}
