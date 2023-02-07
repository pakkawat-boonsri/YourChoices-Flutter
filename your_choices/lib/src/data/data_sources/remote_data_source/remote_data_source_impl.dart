import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:your_choices/src/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:your_choices/src/data/models/customer_model/customer_model.dart';
import 'package:your_choices/src/data/models/vendor_model/vendor_model.dart';
import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';

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
    CustomerEntity customer,
    String profileUrl,
  ) async {
    final customerCollection = firebaseFireStore.collection("customer");

    final uid = await getCurrentUid();

    customerCollection.doc(uid).get().then((value) {
      final newCustomer = CustomerModel(
        uid: uid,
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
          (data) => data.docs
              .map(
                (e) => CustomerModel.fromJson(e),
              )
              .toList(),
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
            uploadImageToStorage(customer.imageFile, "profileImage")
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
    File? file,
    String childName,
  ) async {
    final uid = await getCurrentUid();

    final String imgUrl =
        await firebaseStorage.ref(uid).child(childName).putFile(file!).then(
              (p0) => p0.ref.getDownloadURL(),
            );

    return imgUrl;
  }

  @override
  Future<void> signInVendor(VendorEntity vendorEntity) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: vendorEntity.email!,
        password: vendorEntity.password!,
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
  Future<void> signUpVendor(VendorEntity vendorEntity) async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(
        email: vendorEntity.email!,
        password: vendorEntity.password!,
      )
          .then((value) async {
        if (value.user?.uid != null) {
          if (vendorEntity.imageFile != null &&
              vendorEntity.resImageFile != null) {
            String profileUrl = await uploadImageToStorage(
                vendorEntity.imageFile, "profileImage");
            String resProfileUrl = await uploadImageToStorage(
                vendorEntity.resImageFile, "resProfileImage");
            await createVendorWithImage(
                vendorEntity, profileUrl, resProfileUrl);
          } else {
            createVendorWithImage(vendorEntity, "", "");
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

  Future<void> createVendorWithImage(
    VendorEntity vendorEntity,
    String profileUrl,
    String resProfileUrl,
  ) async {
    final restaurantCollection = firebaseFireStore.collection("restuarant");

    final uid = await getCurrentUid();

    restaurantCollection.doc(uid).get().then((value) {
      final newVendor = VendorModel(
        uid: uid,
        description: vendorEntity.description,
        dishes: vendorEntity.dishes,
        email: vendorEntity.email,
        isActive: vendorEntity.isActive,
        onQueue: vendorEntity.onQueue,
        resName: vendorEntity.resName,
        resProfileUrl: resProfileUrl,
        totalPriceSell: vendorEntity.totalPriceSell,
        profileUrl: profileUrl,
        username: vendorEntity.username,
      ).toJson();
      if (!value.exists) {
        restaurantCollection.doc(uid).set(newVendor);
      } else {
        restaurantCollection.doc(uid).update(newVendor);
      }
    }).catchError((error) {
      showFlutterToast(
        error.toString(),
      );
    });
  }

  @override
  Future<String> signinRole(String uid) async {
    List<String> type = ["customer", "restuarant"];

    Future<String> checkRoleData() async {
      for (var element in type) {
        var data = await firebaseFireStore.collection(element).doc(uid).get();

        if (data.exists) {
          var snapData = data.data();
          if (snapData!['type'] == "customer") {
            return snapData['type'];
          } else {
            return snapData['type'];
          }
        } else {
          log("no data in database");
        }
      }
      return "";
    }

    return await checkRoleData();
  }
}
