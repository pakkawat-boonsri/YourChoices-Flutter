import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:your_choices/src/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:your_choices/src/data/models/customer_model/customer_model.dart';
import 'package:your_choices/src/data/models/vendor_model/add_ons_model/add_ons_model.dart';
import 'package:your_choices/src/data/models/vendor_model/dishes_model/dishes_model.dart';
import 'package:your_choices/src/data/models/vendor_model/filter_option_model/filter_option_model.dart';
import 'package:your_choices/src/data/models/vendor_model/vendor_model.dart';
import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';
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
    final customerCollection =
        firebaseFireStore.collection(FirebaseConst.customer);

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
  Future<String> getCurrentUid() async => firebaseAuth.currentUser!.uid;

  @override
  Stream<List<CustomerEntity>> getSingleCustomer(String uid) {
    final userCollection = firebaseFireStore
        .collection(FirebaseConst.customer)
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
    final restaurantCollection =
        firebaseFireStore.collection(FirebaseConst.restaurant);

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
        type: vendorEntity.type,
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
  Future<String> signInRole(String uid) async {
    List<String> type = [FirebaseConst.customer, FirebaseConst.restaurant];

    Future<String> checkRoleData() async {
      for (var element in type) {
        var data = await firebaseFireStore.collection(element).doc(uid).get();
        if (data.exists) {
          var snapData = data.data();
          if (snapData!['type'] == FirebaseConst.restaurant) {
            return snapData['type'];
          } else {
            return snapData['type'];
          }
        } else {
          log("no data type in database");
        }
      }
      return "";
    }

    return await checkRoleData();
  }

  @override
  Stream<List<VendorEntity>> getSingleVendor(String uid) {
    final vendorCollection = firebaseFireStore
        .collection(FirebaseConst.restaurant)
        .where("uid", isEqualTo: uid)
        .limit(1);

    return vendorCollection.snapshots().map(
          (event) => event.docs
              .map(
                (doc) => VendorModel.fromJson(doc),
              )
              .toList(),
        );
  }

  @override
  Future<void> signInUser(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
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
  Future<void> createMenu(DishesEntity dishesEntity) async {
    final uid = await getCurrentUid();
    final menuSubCollection = firebaseFireStore
        .collection(FirebaseConst.restaurant)
        .doc(uid)
        .collection(FirebaseConst.menu);

    menuSubCollection.doc(dishesEntity.dishesId).get().then((menuDoc) async {
      final newMenu = DishesModel(
        dishesId: dishesEntity.dishesId,
        createdAt: dishesEntity.createdAt,
        isActive: dishesEntity.isActive,
        menuImg: dishesEntity.disheImageFile != null
            ? await uploadImageToStorage(
                dishesEntity.disheImageFile,
                "menuImages_${dishesEntity.dishesId}",
              )
            : "",
        menuName: dishesEntity.menuName,
        menuDescription: dishesEntity.menuDescription,
        menuPrice: dishesEntity.menuPrice,
      ).toJson();

      if (menuDoc.exists) {
        menuSubCollection.doc(dishesEntity.dishesId).update(newMenu);
      } else {
        menuSubCollection.doc(dishesEntity.dishesId).set(newMenu);
      }

      if (dishesEntity.filterOption != null) {
        final filterOptionSubCollection = menuSubCollection
            .doc(dishesEntity.dishesId)
            .collection(FirebaseConst.filterOption);
        for (var filterOption in dishesEntity.filterOption!) {
          final newFilterOption = FilterOptionModel(
            filterId: filterOption.filterId,
            filterName: filterOption.filterName,
            isRequired: filterOption.isRequired,
            isMultiple: filterOption.isMultiple,
            multipleQuantity: filterOption.multipleQuantity,
          ).toJson();

          filterOptionSubCollection
              .doc(filterOption.filterId)
              .get()
              .then((filterOptionDoc) {
            if (filterOptionDoc.exists) {
              filterOptionSubCollection
                  .doc(filterOption.filterId)
                  .update(newFilterOption);
            } else {
              filterOptionSubCollection
                  .doc(filterOption.filterId)
                  .set(newFilterOption);
            }
          });

          if (filterOption.addOns != null) {
            final addOnsSubCollection = filterOptionSubCollection
                .doc(filterOption.filterId)
                .collection(FirebaseConst.addons);

            for (var addOns in filterOption.addOns!) {
              final newAddOns = AddOnsModel(
                addonsId: addOns.addonsId,
                addonsName: addOns.addonsName,
                price: addOns.price,
                priceType: addOns.priceType,
              ).toJson();

              addOnsSubCollection.doc(addOns.addonsId).get().then((addOnsDoc) {
                if (addOnsDoc.exists) {
                  addOnsSubCollection.doc(addOns.addonsId).update(newAddOns);
                } else {
                  addOnsSubCollection.doc(addOns.addonsId).set(newAddOns);
                }
              });
            }
          }
        }
      }
    });
  }

  @override
  Stream<List<DishesEntity>> getMenu(String uid) {
    final menuSubCollection = firebaseFireStore
        .collection(FirebaseConst.restaurant)
        .doc(uid)
        .collection(FirebaseConst.menu);

    return menuSubCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((menuDoc) {
        List<FilterOptionModel> filterOptionsModel = [];

        menuDoc.reference
            .collection(FirebaseConst.filterOption)
            .snapshots()
            .listen((filterOptionSnapshot) {
          filterOptionsModel.clear();
          for (var filterOptionDoc in filterOptionSnapshot.docs) {
            List<AddOnsModel> addOnsModel = [];

            filterOptionDoc.reference
                .collection(FirebaseConst.addons)
                .snapshots()
                .listen((addOnSnapshot) {
              addOnsModel.clear();
              for (var addOnDoc in addOnSnapshot.docs) {
                addOnsModel.add(AddOnsModel(
                  addonsId: addOnDoc['addonsId'],
                  addonsName: addOnDoc['addonsName'],
                  priceType: addOnDoc['priceType'],
                  price: addOnDoc['price'],
                ));
              }
            });

            filterOptionsModel.add(FilterOptionModel(
              filterId: filterOptionDoc['filterId'],
              filterName: filterOptionDoc['filterName'],
              isMultiple: filterOptionDoc['isMultiple'],
              isRequired: filterOptionDoc['isRequired'],
              multipleQuantity: filterOptionDoc['multipleQuantity'],
              addOns: addOnsModel,
            ));
          }
        });

        return DishesModel(
          dishesId: menuDoc['dishesId'],
          createdAt: menuDoc['createdAt'],
          isActive: menuDoc['isActive'],
          menuDescription: menuDoc['menuDescription'],
          menuImg: menuDoc['menuImg'],
          menuName: menuDoc['menuName'],
          menuPrice: menuDoc['menuPrice'],
          filterOption: filterOptionsModel,
        );
      }).toList();
    });
  }

  @override
  Future<void> deleteMenu(DishesEntity dishesEntity) async {
    final uid = await getCurrentUid();
    final menuSubCollection = firebaseFireStore
        .collection(FirebaseConst.restaurant)
        .doc(uid)
        .collection(FirebaseConst.menu);
    try {
      final dishesColRef = menuSubCollection.doc(dishesEntity.dishesId);

      final filterOptionColRef =
          dishesColRef.collection(FirebaseConst.filterOption);

      final filterQuerySnapShot = await filterOptionColRef.get();

      for (final filterDoc in filterQuerySnapShot.docs) {
        final addOnsColRef =
            filterDoc.reference.collection(FirebaseConst.addons);
        final addOnsQuerySnapShot = await addOnsColRef.get();

        for (final addOnsDoc in addOnsQuerySnapShot.docs) {
          await addOnsDoc.reference.delete();
        }
        await filterDoc.reference.delete();
      }
      await dishesColRef.delete();
    } catch (e) {
      showFlutterToast(e.toString());
    }
  }

  @override
  Future<void> updateMenu(DishesEntity dishesEntity) async {
    final uid = await getCurrentUid();
    final menuSubCollection = firebaseFireStore
        .collection(FirebaseConst.restaurant)
        .doc(uid)
        .collection(FirebaseConst.menu);
    final menuDoc = await menuSubCollection.doc(dishesEntity.dishesId).get();

    final Map<String, dynamic> menuInfomation = {};

    if (dishesEntity.menuName != "" && dishesEntity.menuName != null) {
      menuInfomation['menuName'] = dishesEntity.menuName;
    }
    if (dishesEntity.menuDescription != "" &&
        dishesEntity.menuDescription != null) {
      menuInfomation['menuDescription'] = dishesEntity.menuDescription;
    }
    if (dishesEntity.menuPrice != null) {
      menuInfomation['menuPrice'] = dishesEntity.menuPrice;
    }
    if (dishesEntity.menuImg != "" && dishesEntity.menuImg != null) {
      menuInfomation['menuImg'] = dishesEntity.menuImg;
    }
    if (dishesEntity.isActive != null) {
      menuInfomation['isActive'] = dishesEntity.isActive;
    }

    if (menuDoc.exists) {
      try {
        await menuSubCollection
            .doc(dishesEntity.dishesId)
            .update(menuInfomation);
      } catch (_) {
        showFlutterToast(_.toString());
      }
    } else {
      showFlutterToast("Can't Update Restaurant Infomation right now");
    }
  }

  @override
  Future<void> openAndCloseRestaurant(VendorEntity vendorEntity) async {
    final vendorCollection =
        firebaseFireStore.collection(FirebaseConst.restaurant);
    final vendorDoc = await vendorCollection.doc(vendorEntity.uid).get();
    if (vendorDoc.exists) {
      try {
        vendorCollection
            .doc(vendorEntity.uid)
            .update({"isActive": vendorEntity.isActive});
      } catch (_) {
        showFlutterToast(_.toString());
      }
    } else {
      showFlutterToast("Something went wrong");
    }
  }

  @override
  Future<void> updateRestaurantInfo(VendorEntity vendorEntity) async {
    final vendorCollection =
        firebaseFireStore.collection(FirebaseConst.restaurant);
    final vendorDoc = await vendorCollection.doc(vendorEntity.uid).get();

    final Map<String, dynamic> restaurantInfomation = {};

    if (vendorEntity.username != "" && vendorEntity.username != null) {
      restaurantInfomation['username'] = vendorEntity.username;
    }
    if (vendorEntity.profileUrl != "" && vendorEntity.profileUrl != null) {
      restaurantInfomation['profileUrl'] = vendorEntity.profileUrl;
    }
    if (vendorEntity.resName != "" && vendorEntity.resName != null) {
      restaurantInfomation['resName'] = vendorEntity.resName;
    }
    if (vendorEntity.resProfileUrl != "" &&
        vendorEntity.resProfileUrl != null) {
      restaurantInfomation['resProfileUrl'] = vendorEntity.resProfileUrl;
    }
    if (vendorEntity.description != "" && vendorEntity.description != null) {
      restaurantInfomation['description'] = vendorEntity.description;
    }

    if (vendorDoc.exists) {
      try {
        await vendorCollection
            .doc(vendorEntity.uid)
            .update(restaurantInfomation);
      } catch (_) {
        showFlutterToast(_.toString());
      }
    } else {
      showFlutterToast("Can't Update Restaurant Infomation right now");
    }
  }

  @override
  Future<void> createFilterOption(FilterOptionEntity filterOptionEntity) async {
    final uid = await getCurrentUid();
    final filterOptionSubCollection = firebaseFireStore
        .collection(FirebaseConst.restaurant)
        .doc(uid)
        .collection(FirebaseConst.filterOption);

    filterOptionSubCollection
        .doc(filterOptionEntity.filterId)
        .get()
        .then((filterOptionDoc) {
      final newFilterOptionModel = FilterOptionModel(
        filterId: filterOptionEntity.filterId,
        filterName: filterOptionEntity.filterName,
        isMultiple: filterOptionEntity.isMultiple,
        isRequired: filterOptionEntity.isRequired,
        isSelected: filterOptionEntity.isSelected,
        multipleQuantity: filterOptionEntity.multipleQuantity,
      ).toJson();

      if (filterOptionDoc.exists) {
        filterOptionSubCollection
            .doc(filterOptionEntity.filterId)
            .update(newFilterOptionModel);
      } else {
        filterOptionSubCollection
            .doc(filterOptionEntity.filterId)
            .set(newFilterOptionModel);
      }

      if (filterOptionEntity.addOns != null) {
        final addOnsSubCollection = filterOptionSubCollection
            .doc(filterOptionEntity.filterId)
            .collection(FirebaseConst.addons);

        for (var addOnsEntity in filterOptionEntity.addOns!) {
          final newAddOnsModel = AddOnsModel(
            addonsId: addOnsEntity.addonsId,
            addonsName: addOnsEntity.addonsName,
            priceType: addOnsEntity.priceType,
            price: addOnsEntity.price,
          ).toJson();

          addOnsSubCollection
              .doc(addOnsEntity.addonsId)
              .get()
              .then((addOnsDoc) {
            if (addOnsDoc.exists) {
              addOnsSubCollection
                  .doc(addOnsEntity.addonsId)
                  .update(newAddOnsModel);
            } else {
              addOnsSubCollection
                  .doc(addOnsEntity.addonsId)
                  .set(newAddOnsModel);
            }
          });
        }
      }
    });
  }

  @override
  Stream<List<FilterOptionEntity>> readFilterOption(String uid) {
    final filterOptionSubCollection = firebaseFireStore
        .collection(FirebaseConst.restaurant)
        .doc(uid)
        .collection(FirebaseConst.filterOption);
    return filterOptionSubCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((filterOptionDoc) {
        List<AddOnsModel> addOnsModel = [];

        filterOptionDoc.reference
            .collection(FirebaseConst.addons)
            .snapshots()
            .listen((addOnsSnapshot) {
          addOnsModel.clear();

          for (var addOnsDoc in addOnsSnapshot.docs) {
            addOnsModel.add(AddOnsModel(
              addonsId: addOnsDoc['addonsId'],
              addonsName: addOnsDoc['addonsName'],
              priceType: addOnsDoc['priceType'],
              price: addOnsDoc['price'],
            ));
          }
        });

        return FilterOptionModel(
          filterId: filterOptionDoc['filterId'],
          filterName: filterOptionDoc['filterName'],
          isMultiple: filterOptionDoc['isMultiple'],
          isRequired: filterOptionDoc['isRequired'],
          isSelected: filterOptionDoc['isSelected'],
          multipleQuantity: filterOptionDoc['multipleQuantity'],
          addOns: addOnsModel,
        );
      }).toList();
    });
  }

  @override
  Future<void> deleteFilterOption(
    FilterOptionEntity filterOptionEntity,
  ) async {
    final uid = await getCurrentUid();
    final filterOptionSubCollection = firebaseFireStore
        .collection(FirebaseConst.restaurant)
        .doc(uid)
        .collection(FirebaseConst.filterOption);
    try {
      final filterDocRef =
          filterOptionSubCollection.doc(filterOptionEntity.filterId);
      final addOnsColRef = filterDocRef.collection(FirebaseConst.addons);
      final addOnsQuerySnapShot = await addOnsColRef.get();

      for (DocumentSnapshot addOnsDoc in addOnsQuerySnapShot.docs) {
        await addOnsDoc.reference.delete();
      }
      await filterDocRef.delete();
    } catch (e) {
      showFlutterToast(e.toString());
    }
  }

  @override
  Future<void> updateFilterOption(
    FilterOptionEntity filterOptionEntity,
  ) async {
    final uid = await getCurrentUid();
    final filterSubCollection = firebaseFireStore
        .collection(FirebaseConst.restaurant)
        .doc(uid)
        .collection(FirebaseConst.filterOption);
    final filterOptionDoc =
        await filterSubCollection.doc(filterOptionEntity.filterId).get();

    final Map<String, dynamic> filterOptionInfo = {};

    if (filterOptionEntity.filterName != "" &&
        filterOptionEntity.filterName != null) {
      filterOptionInfo['filterName'] = filterOptionEntity.filterName;
    }
    if (filterOptionEntity.isRequired != null) {
      filterOptionInfo['isRequired'] = filterOptionEntity.isRequired;
    }
    if (filterOptionEntity.isMultiple != null) {
      filterOptionInfo['isMultiple'] = filterOptionEntity.isMultiple;
    }
    if (filterOptionEntity.isSelected != null) {
      filterOptionInfo['isSelected'] = filterOptionEntity.isSelected;
    }
    if (filterOptionEntity.multipleQuantity != null) {
      filterOptionInfo['multipleQuantity'] =
          filterOptionEntity.multipleQuantity;
    }

    if (filterOptionDoc.exists) {
      try {
        await filterSubCollection
            .doc(filterOptionEntity.filterId)
            .update(filterOptionInfo);
      } catch (_) {
        showFlutterToast(_.toString());
      }
    } else {
      showFlutterToast("Can't Update Restaurant Infomation right now");
    }
  }

  @override
  Future<void> updateAllFilterOptionIsSelectedToFalse() async {
    final uid = await getCurrentUid();
    final filterSubCollection = firebaseFireStore
        .collection(FirebaseConst.restaurant)
        .doc(uid)
        .collection(FirebaseConst.filterOption);

    final querySnapshot = await filterSubCollection.get();

    final batch = firebaseFireStore.batch();
    for (var doc in querySnapshot.docs) {
      final updateData = {
        'isSelected': false,
      };
      final docRef = filterSubCollection.doc(doc.id);
      batch.update(docRef, updateData);
    }

    await batch.commit();
  }
}

class FirebaseConst {
  static const String menu = "menu";
  static const String customer = "customer";
  static const String restaurant = "restuarant";
  static const String addons = "addons";
  static const String filterOption = "filterOption";
}
