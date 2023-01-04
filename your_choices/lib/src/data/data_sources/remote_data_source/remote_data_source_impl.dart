import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:your_choices/src/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:your_choices/src/data/models/customer_model/customer_model.dart';
import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';

import '../../../../utilities/show_flutter_toast.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseFirestore firebaseFireStore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  FirebaseRemoteDataSourceImpl({
    required this.firebaseStorage,
    required this.firebaseFireStore,
    required this.firebaseAuth,
  });

  Future<void> createCustomerWithImage(
      CustomerEntity customer, String profileUrl) async {
    final customerCollection = firebaseFireStore.collection("customer");

    final uid = await getCurrentUid();

    customerCollection.doc(uid).get().then((value) {
      final newCustomer = CustomerModel(
        uid: customer.uid,
        balance: customer.balance,
        email: customer.email,
        profileUrl: profileUrl,
        type: customer.type,
        transaction: customer.transaction,
        username: customer.username,
      ).toJson();
      if (!value.exists) {
        customerCollection.doc(uid).set(newCustomer);
      } else {
        customerCollection.doc(uid).update(newCustomer);
      }
    }).catchError((error) {
      showFlutterToast(
        error.toString(),
      );
    });
  }

  @override
  Future<void> createCustomer(CustomerEntity customer) async {
    final customerCollection = firebaseFireStore.collection("customer");

    final uid = await getCurrentUid();

    customerCollection.doc(uid).get().then((value) {
      final newCustomer = CustomerModel(
        uid: customer.uid,
        balance: customer.balance,
        email: customer.email,
        profileUrl: customer.profileUrl,
        type: customer.type,
        transaction: customer.transaction,
        username: customer.username,
      ).toJson();
      if (!value.exists) {
        customerCollection.doc(uid).set(newCustomer);
      } else {
        customerCollection.doc(uid).update(newCustomer);
      }
    }).catchError((error) {
      showFlutterToast(
        error.toString(),
      );
    });
  }

  @override
  Future<String> getCurrentUid() async => firebaseAuth.currentUser!.uid;

  @override
  Stream<List<CustomerEntity>> getSingleCustomer(String uid) {
    final userCollection = firebaseFireStore
        .collection("customer")
        .where("uid", isEqualTo: uid)
        .limit(1);
    return userCollection.snapshots().map(
          (event) => event.docs.map((e) => CustomerModel.fromJson(e)).toList(),
        );
  }

  @override
  Future<bool> isSignIn() async {
    return firebaseAuth.currentUser?.uid != null;
  }

  @override
  Future<void> signInCustomer(CustomerEntity customer) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: customer.email!,
        password: customer.password!,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showFlutterToast(e.code);
      } else if (e.code == 'wrong-password') {
        showFlutterToast(e.code);
      }
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> signUpCustomer(CustomerEntity customer) async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(
        email: customer.email!,
        password: customer.password!,
      )
          .then((value) async {
        if (value.user?.uid != null) {
          if (customer.imageFile != null) {
            uploadImageToStorage(customer.imageFile, false, "profileImage")
                .then((profileUrl) {
              createCustomerWithImage(customer, profileUrl);
            });
          } else {
            createCustomerWithImage(customer, "");
          }
        }
      });
      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showFlutterToast("Password is too weak! Change it!");
      } else if (e.code == 'email-already-in-use') {
        showFlutterToast("Email is already in use");
      } else if (e.code == 'invalid-email') {
        showFlutterToast("Invalid Email");
      }
    }
  }

  @override
  Future<void> updateCustomer(CustomerEntity customer) async {
    final customerCollection = firebaseFireStore.collection("customer");
    Map<String, dynamic> customerInformation = {};

    if (customer.email != "" && customer.email != null) {
      customerInformation["email"] = customer.email;
    }
    if (customer.username != "" && customer.username != null) {
      customerInformation["username"] = customer.username;
    }
    if (customer.type != "" && customer.type != null) {
      customerInformation["type"] = customer.type;
    }
    if (customer.profileUrl != "" && customer.profileUrl != null) {
      customerInformation["profileUrl"] = customer.profileUrl;
    }
    if (customer.balance != null) {
      customerInformation["balance"] = customer.balance;
    }
    if (customer.transaction != null) {
      customerInformation["transaction"] = customer.transaction;
    }

    customerCollection.doc(customer.uid).update(customerInformation);
  }

  @override
  Future<String> uploadImageToStorage(
      File? file, bool isPost, String childName) async {
    Reference ref = firebaseStorage
        .ref()
        .child(childName)
        .child(firebaseAuth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    final uploadTask = ref.putFile(file!);

    final imageUrl =
        (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return await imageUrl;
  }
}
