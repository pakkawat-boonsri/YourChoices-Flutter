import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:your_choices/utilities/show_snack_bar.dart';
import 'package:your_choices/view_model/register_view_model/register_view_model.dart';

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

  Stream<User?> get authState => auth.authStateChanges();

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

  Future<void> signInWithGoogle(BuildContext context) async {
    // bool result = false;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.idToken != null && googleAuth?.accessToken != null) {
        final credential = GoogleAuthProvider.credential(
            idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);

        UserCredential userCredential =
            await auth.signInWithCredential(credential);

        User? user = userCredential.user;

        final role = Provider.of<RegisterViewModel>(context, listen: false);

        if (user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {
            if (role.getSelectedType == 1) {
              await firestoreDB.collection("customer").doc(user.uid).set({
              "balance": 0,
              "username": user.displayName,
              "imgAvatar": user.photoURL,
              "role": "101",
              "transaction": [{}],
              });
            } else if (role.getSelectedType == 2) {
              await firestoreDB.collection("restaurant").doc(user.uid).set({
                
              });
            }
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message!);
    }
  }

  Future signOut(BuildContext context) async {
    try {
      auth.signOut();
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message!);
    }
  }
}
