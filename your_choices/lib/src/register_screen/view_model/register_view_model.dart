import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:your_choices/utilities/show_snack_bar.dart';
import 'package:uuid/uuid.dart';

class RegisterViewModel extends ChangeNotifier {
  String _selectedType = "customer";
  bool _isClick = false;
  bool _obscureText = true;
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  get getObscureText => _obscureText;

  File? imageFile;

  setImageFile(File file) {
    imageFile = file;
    notifyListeners();
  }

  setObscureText(bool value) {
    _obscureText = value;
    notifyListeners();
  }

  bool get getIsClick => _isClick;

  setIsClick(bool value) {
    _isClick = value;
    notifyListeners();
  }

  get getSelectedType => _selectedType;

  setSelectedType(checked) {
    _selectedType = checked;
    notifyListeners();
  }

  Future pickImageFromGallery() async {
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file == null) {
        return null;
      } else {
        imageFile = File(file.path);
        notifyListeners();
      }
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
    }
  }

  Future<bool> uploadImage({
    required File file,
    required String userId,
  }) =>
      FirebaseStorage.instance
          .ref(userId)
          .child(const Uuid().v4())
          .putFile(file)
          .then((_) => true)
          .catchError((_) => false);

  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listResult) => listResult.items);

  createUserWithEmailAndpassword(BuildContext context, String username,
      String email, String password, String type) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
        (value) async {
          await uploadImage(file: imageFile!, userId: value.user!.uid);
          final image = await _getImages(value.user!.uid);
          if (type == "customer") {
            await db.collection("customer").doc(value.user!.uid).set({
              "balance": 0,
              "username": username,
              "imgAvatar": image,
              "role": "101",
              "transaction": [{}],
            });
          } else if (type == "restaurant") {
            await db.collection("restaurant").doc(value.user!.uid).set(
              {
                "res_name": "",
                "description": "",
                "menu_list": [{}],
                "username": username,
                "imgAvatar": image,
                "role": "101",
                "transaction": [{}],
              },
            );
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
