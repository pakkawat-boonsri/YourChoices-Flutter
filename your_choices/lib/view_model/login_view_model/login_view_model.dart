import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:your_choices/utilities/show_snack_bar.dart';
import 'package:your_choices/view/login_view/login_view.dart';
import 'package:your_choices/view/main_view.dart';

class LoginViewModel extends ChangeNotifier {
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

  handleUserLogin() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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

  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
