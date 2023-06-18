import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:your_choices/global.dart';
import 'package:your_choices/src/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:your_choices/src/data/models/admin_model/admin_transaction_model.dart';
import 'package:your_choices/src/data/models/customer_model/confirm_order_model/confirm_order_model.dart';
import 'package:your_choices/src/data/models/customer_model/customer_model.dart';
import 'package:your_choices/src/data/models/customer_model/transaction_model/transaction_model.dart';
import 'package:your_choices/src/data/models/vendor_model/add_ons_model/add_ons_model.dart';
import 'package:your_choices/src/data/models/vendor_model/dishes_model/dishes_model.dart';
import 'package:your_choices/src/data/models/vendor_model/filter_option_model/filter_option_model.dart';
import 'package:your_choices/src/data/models/vendor_model/order_model/order_model.dart';
import 'package:your_choices/src/data/models/vendor_model/vendor_model.dart';
import 'package:your_choices/src/domain/entities/admin/admin_transaction_entity.dart';
import 'package:your_choices/src/domain/entities/customer/cart/cart_entity.dart';
import 'package:your_choices/src/domain/entities/customer/confirm_order/confirm_order_entity.dart';
import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/domain/entities/customer/transaction/transaction_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/add_ons/add_ons_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/order/order_entity.dart';
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
    final customerCollection = firebaseFireStore.collection(FirebaseConst.customer);

    final uid = await getCurrentUid();

    customerCollection.doc(uid).get().then((value) {
      final newCustomer = CustomerModel(
        uid: uid,
        balance: customer.balance,
        email: customer.email,
        profileUrl: profileUrl,
        type: customer.type,
        username: customer.username,
      ).toMap();
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
  Stream<CustomerEntity> getSingleCustomer(String uid) {
    final userCollection = firebaseFireStore.collection(FirebaseConst.customer);

    return userCollection.snapshots().asyncExpand((userSnapshot) async* {
      final userDoc = userSnapshot.docs.firstWhere((element) => element['uid'] == uid);

      final transactionCollection = userDoc.reference.collection(FirebaseConst.transaction);

      final transactionSnapshot = await transactionCollection.get();

      final transactionModels =
          transactionSnapshot.docs.map((transactionDoc) => TransactionModel.fromMap(transactionDoc.data())).toList();

      final userModels = CustomerModel(
        balance: userDoc['balance'],
        email: userDoc['email'],
        profileUrl: userDoc['profileUrl'],
        transaction: transactionModels,
        type: userDoc['type'],
        uid: userDoc['uid'],
        username: userDoc['username'],
      );

      yield userModels;
    });
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
            uploadImageToStorage(customer.imageFile, "profileImage").then((profileUrl) {
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

    final String imgUrl = await firebaseStorage.ref(uid).child(childName).putFile(file!).then(
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
          if (vendorEntity.imageFile != null && vendorEntity.resImageFile != null) {
            String profileUrl = await uploadImageToStorage(vendorEntity.imageFile, "profileImage");
            String resProfileUrl = await uploadImageToStorage(vendorEntity.resImageFile, "resProfileImage");
            await createVendorWithImage(vendorEntity, profileUrl, resProfileUrl);
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
    final restaurantCollection = firebaseFireStore.collection(FirebaseConst.restaurant);

    final uid = await getCurrentUid();

    restaurantCollection.doc(uid).get().then((value) {
      final newVendor = VendorModel(
        uid: uid,
        description: vendorEntity.description,
        email: vendorEntity.email,
        isActive: vendorEntity.isActive,
        onQueue: vendorEntity.onQueue,
        resName: vendorEntity.resName,
        resProfileUrl: resProfileUrl,
        totalPriceSell: vendorEntity.totalPriceSell,
        profileUrl: profileUrl,
        username: vendorEntity.username,
        type: vendorEntity.type,
        restaurantType: vendorEntity.restaurantType,
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
    List<String> types = [FirebaseConst.customer, FirebaseConst.restaurant, FirebaseConst.admin];

    Future<String> checkRoleData() async {
      for (var type in types) {
        var snapshot = await firebaseFireStore.collection(type).doc(uid).get();
        if (snapshot.exists) {
          var data = snapshot.data();
          var role = data?['type'];
          if (role == FirebaseConst.restaurant) {
            return role;
          } else if (role == FirebaseConst.customer) {
            return role;
          } else {
            return role;
          }
        } else {
          log("No data for type $type in the database");
        }
      }
      return "";
    }

    return await checkRoleData();
  }

  @override
  Stream<List<VendorEntity>> getSingleVendor(String uid) {
    final vendorCollection = firebaseFireStore.collection(FirebaseConst.restaurant).where("uid", isEqualTo: uid).limit(1);

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
    final menuSubCollection = firebaseFireStore.collection(FirebaseConst.restaurant).doc(uid).collection(FirebaseConst.menu);

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
            : dishesEntity.menuImg != ""
                ? dishesEntity.menuImg
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
        final filterOptionSubCollection =
            menuSubCollection.doc(dishesEntity.dishesId).collection(FirebaseConst.filterOption);
        for (var filterOption in dishesEntity.filterOption!) {
          final newFilterOption = FilterOptionModel(
            filterId: filterOption.filterId,
            filterName: filterOption.filterName,
            isRequired: filterOption.isRequired,
            isMultiple: filterOption.isMultiple,
            multipleQuantity: filterOption.multipleQuantity,
          ).toJson();

          filterOptionSubCollection.doc(filterOption.filterId).get().then((filterOptionDoc) {
            if (filterOptionDoc.exists) {
              filterOptionSubCollection.doc(filterOption.filterId).update(newFilterOption);
            } else {
              filterOptionSubCollection.doc(filterOption.filterId).set(newFilterOption);
            }
          });

          if (filterOption.addOns != null) {
            final addOnsSubCollection =
                filterOptionSubCollection.doc(filterOption.filterId).collection(FirebaseConst.addons);

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
    final menuSubCollection = firebaseFireStore.collection(FirebaseConst.restaurant).doc(uid).collection(FirebaseConst.menu);

    return menuSubCollection.snapshots().asyncMap((querySnapshot) async {
      final dishesList = <DishesModel>[];

      for (var menuDoc in querySnapshot.docs) {
        final filterOptionsModel = <FilterOptionModel>[];

        final filterOptionSnapshot = await menuDoc.reference.collection(FirebaseConst.filterOption).get();

        for (var filterOptionDoc in filterOptionSnapshot.docs) {
          final addOnsModel = <AddOnsModel>[];

          final addOnSnapshot = await filterOptionDoc.reference.collection(FirebaseConst.addons).get();

          for (var addOnDoc in addOnSnapshot.docs) {
            final addOnsEntity = AddOnsModel(
              addonsId: addOnDoc['addonsId'],
              addonsName: addOnDoc['addonsName'],
              priceType: addOnDoc['priceType'],
              price: addOnDoc['price'],
            );
            addOnsModel.add(addOnsEntity);
          }

          final filterOptionEntity = FilterOptionModel(
            filterId: filterOptionDoc['filterId'],
            filterName: filterOptionDoc['filterName'],
            isMultiple: filterOptionDoc['isMultiple'],
            isRequired: filterOptionDoc['isRequired'],
            multipleQuantity: filterOptionDoc['multipleQuantity'],
            addOns: addOnsModel,
          );
          filterOptionsModel.add(filterOptionEntity);
        }

        final dishesEntity = DishesModel(
          dishesId: menuDoc['dishesId'],
          createdAt: menuDoc['createdAt'],
          isActive: menuDoc['isActive'],
          menuDescription: menuDoc['menuDescription'],
          menuImg: menuDoc['menuImg'],
          menuName: menuDoc['menuName'],
          menuPrice: menuDoc['menuPrice'],
          filterOption: filterOptionsModel,
        );
        dishesList.add(dishesEntity);
      }

      return dishesList;
    });
  }

  @override
  Future<void> deleteMenu(DishesEntity dishesEntity) async {
    final uid = await getCurrentUid();
    final menuSubCollection = firebaseFireStore.collection(FirebaseConst.restaurant).doc(uid).collection(FirebaseConst.menu);
    try {
      final dishesColRef = menuSubCollection.doc(dishesEntity.dishesId);

      final filterOptionColRef = dishesColRef.collection(FirebaseConst.filterOption);

      final filterQuerySnapShot = await filterOptionColRef.get();

      for (final filterDoc in filterQuerySnapShot.docs) {
        final addOnsColRef = filterDoc.reference.collection(FirebaseConst.addons);
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
    final menuSubCollection = firebaseFireStore.collection(FirebaseConst.restaurant).doc(uid).collection(FirebaseConst.menu);
    final menuDoc = await menuSubCollection.doc(dishesEntity.dishesId).get();

    final Map<String, dynamic> menuInfomation = {};

    if (dishesEntity.menuName != "" && dishesEntity.menuName != null) {
      menuInfomation['menuName'] = dishesEntity.menuName;
    }
    if (dishesEntity.menuDescription != "" && dishesEntity.menuDescription != null) {
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
        await menuSubCollection.doc(dishesEntity.dishesId).update(menuInfomation);
      } catch (_) {
        showFlutterToast(_.toString());
      }
    } else {
      showFlutterToast("Can't Update Restaurant Infomation right now");
    }
  }

  @override
  Future<void> openAndCloseRestaurant(VendorEntity vendorEntity) async {
    final vendorCollection = firebaseFireStore.collection(FirebaseConst.restaurant);
    final vendorDoc = await vendorCollection.doc(vendorEntity.uid).get();
    if (vendorDoc.exists) {
      try {
        await vendorCollection.doc(vendorEntity.uid).update({"isActive": vendorEntity.isActive}).then((_) async {
          final orderCollection = firebaseFireStore.collection(FirebaseConst.orders);
          // Retrieve all orders
          final querySnapshot = await orderCollection.get();

          if (vendorEntity.isActive == false && querySnapshot.size > 0) {
            // Process each order
            for (final doc in querySnapshot.docs) {
              if (doc['orderTypes'] == OrderTypes.pending.toString() && vendorEntity.uid == doc['restaurantId']) {
                final onQuereDocument =
                    await firebaseFireStore.collection(FirebaseConst.restaurant).doc(doc['restaurantId']).get();
                firebaseFireStore
                    .collection(FirebaseConst.restaurant)
                    .doc(doc['restaurantId'])
                    .update({"onQueue": (onQuereDocument['onQueue'] as int) - 1});

                final customerId = doc['customerId'] ?? "";
                final currentBalance = await getAccountBalance(customerId);

                // Calculate and return money to the customer's balance
                final totalPrice = (doc['cartItems'] as List<dynamic>)
                    .fold(0.0, (previousValue, element) => previousValue + (element['totalPrice'] ?? 0.0))
                    .floor();
                final totalBalance = currentBalance + totalPrice;

                // Update the customer's balance
                await firebaseFireStore
                    .collection(FirebaseConst.customer)
                    .doc(customerId)
                    .update({"balance": totalBalance}).catchError((e) {
                  log(e.toString());
                });

                final customerHistoryCollection = firebaseFireStore
                    .collection(FirebaseConst.customer)
                    .doc(customerId)
                    .collection(FirebaseConst.customerHistory);
                final restaurantHistoryCollection = firebaseFireStore
                    .collection(FirebaseConst.restaurant)
                    .doc(doc['restaurantId'])
                    .collection(FirebaseConst.restaurantHistory);

                //create customer history and restaurant history
                final newOrderHistory = OrderModel(
                  orderId: doc['orderId'],
                  customerId: doc['customerId'],
                  restaurantId: doc['restaurantId'],
                  createdAt: doc['createdAt'],
                  customerName: doc['customerName'],
                  orderTypes: OrderTypes.failure.toString(),
                  vendorEntity: doc['vendorEntity'] != null ? VendorEntity.fromMap(doc['vendorEntity']) : null,
                  cartItems: List<CartItemEntity>.from(doc['cartItems']?.map((x) => CartItemEntity.fromMap(x))),
                ).toMap();

                await customerHistoryCollection.doc(doc['orderId']).get().then((customerHistoryDoc) async {
                  if (customerHistoryDoc.exists) {
                    await customerHistoryCollection.doc(doc['orderId']).update(newOrderHistory);
                  } else {
                    await customerHistoryCollection.doc(doc['orderId']).set(newOrderHistory);
                  }
                });

                await restaurantHistoryCollection.doc(doc['orderId']).get().then((restaurantHistoryDoc) async {
                  if (restaurantHistoryDoc.exists) {
                    await restaurantHistoryCollection.doc(doc['orderId']).update(newOrderHistory);
                  } else {
                    await restaurantHistoryCollection.doc(doc['orderId']).set(newOrderHistory);
                  }
                });
                // Delete the order
                await doc.reference.delete();
              }
            }
          }
        });
      } catch (_) {
        log(_.toString());
      }
    } else {
      log("Something went wrong");
    }
  }

  @override
  Future<void> updateRestaurantInfo(VendorEntity vendorEntity) async {
    final vendorCollection = firebaseFireStore.collection(FirebaseConst.restaurant);
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
    if (vendorEntity.resProfileUrl != "" && vendorEntity.resProfileUrl != null) {
      restaurantInfomation['resProfileUrl'] = vendorEntity.resProfileUrl;
    }
    if (vendorEntity.description != "" && vendorEntity.description != null) {
      restaurantInfomation['description'] = vendorEntity.description;
    }
    if (vendorEntity.restaurantType != "" && vendorEntity.restaurantType != null) {
      restaurantInfomation['restaurantType'] = vendorEntity.restaurantType;
    }

    if (vendorDoc.exists) {
      try {
        await vendorCollection.doc(vendorEntity.uid).update(restaurantInfomation);
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
    final filterOptionSubCollection =
        firebaseFireStore.collection(FirebaseConst.restaurant).doc(uid).collection(FirebaseConst.filterOption);

    final newFilterOptionModel = FilterOptionModel(
      filterId: filterOptionEntity.filterId,
      filterName: filterOptionEntity.filterName,
      isMultiple: filterOptionEntity.isMultiple,
      isRequired: filterOptionEntity.isRequired,
      multipleQuantity: filterOptionEntity.multipleQuantity,
    ).toJson();

    filterOptionSubCollection.doc(filterOptionEntity.filterId).get().then((filterOptionDoc) async {
      if (filterOptionDoc.exists) {
        await filterOptionSubCollection.doc(filterOptionEntity.filterId).update(newFilterOptionModel);
      } else {
        await filterOptionSubCollection.doc(filterOptionEntity.filterId).set(newFilterOptionModel);
      }

      if (filterOptionEntity.addOns != null) {
        final addOnsSubCollection =
            filterOptionSubCollection.doc(filterOptionEntity.filterId).collection(FirebaseConst.addons);

        for (var addOnsEntity in filterOptionEntity.addOns!) {
          final newAddOnsModel = AddOnsModel(
            addonsId: addOnsEntity.addonsId,
            addonsName: addOnsEntity.addonsName,
            priceType: addOnsEntity.priceType,
            price: addOnsEntity.price,
          ).toJson();

          addOnsSubCollection.doc(addOnsEntity.addonsId).get().then((addOnsDoc) async {
            if (addOnsDoc.exists) {
              await addOnsSubCollection.doc(addOnsEntity.addonsId).update(newAddOnsModel);
            } else {
              await addOnsSubCollection.doc(addOnsEntity.addonsId).set(newAddOnsModel);
            }
          });
        }
      }
    });
  }

  @override
  Stream<List<FilterOptionEntity>> readFilterOption(String uid) {
    final filterOptionSubCollection =
        firebaseFireStore.collection(FirebaseConst.restaurant).doc(uid).collection(FirebaseConst.filterOption);
    return filterOptionSubCollection.snapshots().asyncMap((querySnapshot) async {
      final filterOptionModels = await Future.wait(querySnapshot.docs.map((filterOptionDoc) async {
        final addOnsSnapshot = await filterOptionDoc.reference.collection(FirebaseConst.addons).get();
        final addOnsModel = addOnsSnapshot.docs.map((addOnsDoc) {
          return AddOnsModel(
            addonsId: addOnsDoc['addonsId'],
            addonsName: addOnsDoc['addonsName'],
            priceType: addOnsDoc['priceType'],
            price: addOnsDoc['price'],
          );
        }).toList();

        return FilterOptionModel(
          filterId: filterOptionDoc['filterId'],
          filterName: filterOptionDoc['filterName'],
          isMultiple: filterOptionDoc['isMultiple'],
          isRequired: filterOptionDoc['isRequired'],
          multipleQuantity: filterOptionDoc['multipleQuantity'],
          addOns: addOnsModel,
        );
      }).toList());

      return filterOptionModels;
    });
  }

  @override
  Future<void> onDeletingAddOnsInFilterOptionDetail(FilterOptionEntity filterOptionEntity, AddOnsEntity addOnsEntity) async {
    final uid = await getCurrentUid();
    final filterOptionSubCollection =
        firebaseFireStore.collection(FirebaseConst.restaurant).doc(uid).collection(FirebaseConst.filterOption);
    try {
      final filterDocRef = filterOptionSubCollection.doc(filterOptionEntity.filterId);
      final addOnsColRef = filterDocRef.collection(FirebaseConst.addons);
      await addOnsColRef.doc(addOnsEntity.addonsId).delete();
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<void> onDeletingAddOnsInFilterOptionInMenu(
      DishesEntity dishesEntity, FilterOptionEntity filterOptionEntity, AddOnsEntity addOnsEntity) async {
    final uid = await getCurrentUid();

    try {
      await firebaseFireStore
          .collection(FirebaseConst.restaurant)
          .doc(uid)
          .collection(FirebaseConst.menu)
          .doc(dishesEntity.dishesId)
          .collection(FirebaseConst.filterOption)
          .doc(filterOptionEntity.filterId)
          .collection(FirebaseConst.addons)
          .doc(addOnsEntity.addonsId)
          .delete();
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<void> deleteFilterOption(
    FilterOptionEntity filterOptionEntity,
  ) async {
    final uid = await getCurrentUid();
    final filterOptionSubCollection =
        firebaseFireStore.collection(FirebaseConst.restaurant).doc(uid).collection(FirebaseConst.filterOption);
    try {
      final filterDocRef = filterOptionSubCollection.doc(filterOptionEntity.filterId);
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
    final filterSubCollection =
        firebaseFireStore.collection(FirebaseConst.restaurant).doc(uid).collection(FirebaseConst.filterOption);
    final filterOptionDoc = await filterSubCollection.doc(filterOptionEntity.filterId).get();

    final Map<String, dynamic> filterOptionInfo = {};

    if (filterOptionEntity.filterName != "" && filterOptionEntity.filterName != null) {
      filterOptionInfo['filterName'] = filterOptionEntity.filterName;
    }
    if (filterOptionEntity.isRequired != null) {
      filterOptionInfo['isRequired'] = filterOptionEntity.isRequired;
    }
    if (filterOptionEntity.isMultiple != null) {
      filterOptionInfo['isMultiple'] = filterOptionEntity.isMultiple;
    }
    if (filterOptionEntity.multipleQuantity != null) {
      filterOptionInfo['multipleQuantity'] = filterOptionEntity.multipleQuantity;
    }

    if (filterOptionDoc.exists) {
      try {
        await filterSubCollection.doc(filterOptionEntity.filterId).update(filterOptionInfo);
      } catch (_) {
        showFlutterToast(_.toString());
      }
    } else {
      showFlutterToast("Can't Update Restaurant Infomation right now");
    }
  }

  @override
  Future<void> addFilterOptionInMenu(
    final DishesEntity dishesEntity,
    final FilterOptionEntity filterOptionEntity,
  ) async {
    final uid = await getCurrentUid();

    final menuCollection = firebaseFireStore.collection(FirebaseConst.restaurant).doc(uid).collection(FirebaseConst.menu);

    final menuDoc = await menuCollection.doc(dishesEntity.dishesId).get();

    final filterOptionCollectionRef = menuDoc.reference.collection(FirebaseConst.filterOption);

    filterOptionCollectionRef.doc(filterOptionEntity.filterId).get().then((filterOptionDoc) async {
      final newFilterOptionModel = FilterOptionModel(
        filterId: filterOptionEntity.filterId,
        filterName: filterOptionEntity.filterName,
        isMultiple: filterOptionEntity.isMultiple,
        isRequired: filterOptionEntity.isRequired,
        isSelected: filterOptionEntity.isSelected,
        multipleQuantity: filterOptionEntity.multipleQuantity,
      ).toJson();

      if (filterOptionDoc.exists) {
        await filterOptionCollectionRef.doc(filterOptionEntity.filterId).update(newFilterOptionModel);
      } else {
        await filterOptionCollectionRef.doc(filterOptionEntity.filterId).set(newFilterOptionModel);
      }

      if (filterOptionEntity.addOns != null) {
        final addOnsSubCollection =
            filterOptionCollectionRef.doc(filterOptionEntity.filterId).collection(FirebaseConst.addons);

        for (var addOnsEntity in filterOptionEntity.addOns!) {
          final newAddOnsModel = AddOnsModel(
            addonsId: addOnsEntity.addonsId,
            addonsName: addOnsEntity.addonsName,
            priceType: addOnsEntity.priceType,
            price: addOnsEntity.price,
          ).toJson();

          addOnsSubCollection.doc(addOnsEntity.addonsId).get().then((addOnsDoc) async {
            if (addOnsDoc.exists) {
              await addOnsSubCollection.doc(addOnsEntity.addonsId).update(newAddOnsModel);
            } else {
              await addOnsSubCollection.doc(addOnsEntity.addonsId).set(newAddOnsModel);
            }
          });
        }
      }
    });
  }

  @override
  Future<void> deleteFilterOptionInMenu(
    FilterOptionEntity filterOptionEntity,
  ) async {
    final uid = await getCurrentUid();

    final menuCollection = firebaseFireStore.collection(FirebaseConst.restaurant).doc(uid).collection(FirebaseConst.menu);

    final menuQuerySnapshot = await menuCollection.get();

    final menuDocId = menuQuerySnapshot.docs.firstWhere((element) =>
        element.reference.collection(FirebaseConst.filterOption).doc(filterOptionEntity.filterId).id ==
        filterOptionEntity.filterId);

    final menuDoc = await menuCollection.doc(menuDocId.id).get();

    final filterOptionDocRef = menuDoc.reference.collection(FirebaseConst.filterOption).doc(filterOptionEntity.filterId);

    final addOnsColRef = filterOptionDocRef.collection(FirebaseConst.addons);
    final addOnsAllDoc = await addOnsColRef.get();
    for (DocumentSnapshot addOns in addOnsAllDoc.docs) {
      await addOns.reference.delete();
    }
    await filterOptionDocRef.delete();
  }

  @override
  Future<void> updateFilterOptionInMenu(
    FilterOptionEntity filterOptionEntity,
  ) async {}

  @override
  Stream<List<FilterOptionEntity>> getFilterOptionInMenu(
    DishesEntity dishesEntity,
  ) async* {
    final uid = await getCurrentUid();
    final menuDocRef = FirebaseFirestore.instance
        .collection(FirebaseConst.restaurant)
        .doc(uid)
        .collection(FirebaseConst.menu)
        .doc(dishesEntity.dishesId);

    final filterOptionSnapshot = menuDocRef.collection(FirebaseConst.filterOption).snapshots();

    await for (var querySnapshot in filterOptionSnapshot) {
      final List<FilterOptionModel> filterOptionModels = [];

      for (var filterOptionDoc in querySnapshot.docs) {
        final addOnsSnapshot = await filterOptionDoc.reference.collection(FirebaseConst.addons).get();

        final addOnsModels = addOnsSnapshot.docs.map((addOnsDoc) {
          return AddOnsModel(
            addonsId: addOnsDoc['addonsId'],
            addonsName: addOnsDoc['addonsName'],
            priceType: addOnsDoc['priceType'],
            price: addOnsDoc['price'],
          );
        }).toList();

        filterOptionModels.add(FilterOptionModel(
          filterId: filterOptionDoc['filterId'],
          filterName: filterOptionDoc['filterName'],
          isMultiple: filterOptionDoc['isMultiple'],
          isRequired: filterOptionDoc['isRequired'],
          multipleQuantity: filterOptionDoc['multipleQuantity'],
          addOns: addOnsModels,
        ));
      }

      yield filterOptionModels;
    }
  }

  @override
  Stream<List<VendorEntity>> getAllRestaurants() {
    final restaurantCollection = firebaseFireStore.collection(FirebaseConst.restaurant);
    final restaurantStream = restaurantCollection.snapshots();

    return restaurantStream.asyncMap((restaurantDocs) async {
      final restaurantModels = await Future.wait(
        restaurantDocs.docs.map((restaurantDoc) async {
          final menuColRef = restaurantDoc.reference.collection(FirebaseConst.menu);
          final menuDocs = await menuColRef.get();
          final menuModels = await Future.wait(
            menuDocs.docs.map((menuDoc) async {
              final filteroptionColRef = menuDoc.reference.collection(FirebaseConst.filterOption);
              final filterOptionDocs = await filteroptionColRef.get();
              final filterOptionModels = await Future.wait(
                filterOptionDocs.docs.map((filterOptionDoc) async {
                  final addOnsColRef = filterOptionDoc.reference.collection(FirebaseConst.addons);
                  final addOnsDocs = await addOnsColRef.get();
                  final addOnsModels = addOnsDocs.docs.map((addOnsDoc) {
                    return AddOnsModel(
                      addonsId: addOnsDoc['addonsId'],
                      addonsName: addOnsDoc['addonsName'],
                      price: addOnsDoc['price'],
                      priceType: addOnsDoc['priceType'],
                    );
                  }).toList();
                  return FilterOptionModel(
                    filterId: filterOptionDoc['filterId'],
                    filterName: filterOptionDoc['filterName'],
                    isMultiple: filterOptionDoc['isMultiple'],
                    isRequired: filterOptionDoc['isRequired'],
                    multipleQuantity: filterOptionDoc['multipleQuantity'],
                    addOns: addOnsModels,
                  );
                }),
              );
              return DishesModel(
                dishesId: menuDoc['dishesId'],
                createdAt: menuDoc['createdAt'],
                isActive: menuDoc['isActive'],
                menuImg: menuDoc['menuImg'],
                menuName: menuDoc['menuName'],
                menuDescription: menuDoc['menuDescription'],
                menuPrice: menuDoc['menuPrice'],
                filterOption: filterOptionModels,
              );
            }).toList(),
          );
          return VendorModel(
            uid: restaurantDoc['uid'],
            description: restaurantDoc['description'],
            email: restaurantDoc['email'],
            isActive: restaurantDoc['isActive'],
            onQueue: restaurantDoc['onQueue'],
            profileUrl: restaurantDoc['profileUrl'],
            resName: restaurantDoc['resName'],
            resProfileUrl: restaurantDoc['resProfileUrl'],
            restaurantType: restaurantDoc['restaurantType'],
            totalPriceSell: restaurantDoc['totalPriceSell'],
            type: restaurantDoc['type'],
            username: restaurantDoc['username'],
            dishes: menuModels,
          );
        }).toList(),
      );
      return restaurantModels;
    });
  }

  @override
  Future<void> updateCustomerInfo(CustomerEntity customerEntity) async {
    final uid = await getCurrentUid();
    final customerCollection = firebaseFireStore.collection(FirebaseConst.customer).doc(uid);

    final menuDoc = await customerCollection.get();

    final Map<String, dynamic> customerInfomation = {};

    if (customerEntity.balance != null) {
      customerInfomation['balance'] = customerEntity.balance;
    }
    if (customerEntity.username != "" && customerEntity.username != null) {
      customerInfomation['username'] = customerEntity.username;
    }
    if (customerEntity.profileUrl != "" && customerEntity.profileUrl != null) {
      customerInfomation['profileUrl'] = customerEntity.profileUrl;
    }

    if (menuDoc.exists) {
      try {
        await customerCollection.update(customerInfomation);
      } catch (_) {
        showFlutterToast(_.toString());
      }
    } else {
      showFlutterToast("Can't Update Restaurant Infomation right now");
    }
  }

  @override
  Future<void> sendConfirmOrderToRestaurants(ConfirmOrderEntity confirmOrderEntity) async {
    final orderCollection = firebaseFireStore.collection(FirebaseConst.orders);
    await orderCollection.doc(confirmOrderEntity.orderId).get().then((orderDoc) async {
      final newConfirmOrder = ConfirmOrderModel(
        vendorEntity: confirmOrderEntity.vendorEntity,
        orderId: confirmOrderEntity.orderId,
        customerId: confirmOrderEntity.customerId,
        restaurantId: confirmOrderEntity.restaurantId,
        createdAt: confirmOrderEntity.createdAt,
        orderTypes: confirmOrderEntity.orderTypes,
        cartItems: confirmOrderEntity.cartItems,
        customerName: confirmOrderEntity.customerName,
      ).toMap();

      if (orderDoc.exists) {
        await orderCollection.doc(confirmOrderEntity.orderId).update(newConfirmOrder);
      } else {
        await orderCollection.doc(confirmOrderEntity.orderId).set(newConfirmOrder);
      }

      final currentBalance = await getAccountBalance(confirmOrderEntity.customerId ?? "");
      final totalPrice = confirmOrderEntity.cartItems
          ?.fold(0.0, (previousValue, element) => previousValue + (element.totalPrice ?? 0.0))
          .floor() as num;
      final totalBalance = currentBalance - totalPrice;

      await firebaseFireStore
          .collection(FirebaseConst.customer)
          .doc(confirmOrderEntity.customerId)
          .update({"balance": totalBalance}).catchError((e) {
        log(e.toString());
      });
    });
  }

  @override
  Future<void> confirmOrder(OrderEntity orderEntity) async {
    final orderCollection = firebaseFireStore.collection(FirebaseConst.orders);
    final uid = await getCurrentUid();
    final onQuereDocument = await firebaseFireStore.collection(FirebaseConst.restaurant).doc(uid).get();

    final restaurantHistoryCollection = firebaseFireStore
        .collection(FirebaseConst.restaurant)
        .doc(orderEntity.restaurantId)
        .collection(FirebaseConst.restaurantHistory);
    final customerHistoryCollection = firebaseFireStore
        .collection(FirebaseConst.customer)
        .doc(orderEntity.customerId)
        .collection(FirebaseConst.customerHistory);

    if (orderEntity.orderTypes == OrderTypes.processing.toString()) {
      await firebaseFireStore
          .collection(FirebaseConst.restaurant)
          .doc(uid)
          .update({"onQueue": (onQuereDocument['onQueue'] as int) + 1});
    }

    await orderCollection.doc(orderEntity.orderId).get().then((orderDoc) async {
      final newOrderModel = OrderModel(
        vendorEntity: orderEntity.vendorEntity,
        orderId: orderEntity.orderId,
        customerId: orderEntity.customerId,
        restaurantId: orderEntity.restaurantId,
        createdAt: orderEntity.createdAt,
        orderTypes: orderEntity.orderTypes,
        cartItems: orderEntity.cartItems,
        customerName: orderEntity.customerName,
      ).toMap();

      if (orderDoc.exists) {
        await orderCollection.doc(orderEntity.orderId).update(newOrderModel);
        if (orderEntity.orderTypes == OrderTypes.completed.toString()) {
          await firebaseFireStore
              .collection(FirebaseConst.restaurant)
              .doc(uid)
              .update({"onQueue": (onQuereDocument['onQueue'] as int) - 1});
          await customerHistoryCollection.doc(orderEntity.orderId).get().then((customerHistoryDoc) async {
            final collectConfirmOrderCompleted = OrderModel(
              vendorEntity: orderEntity.vendorEntity,
              orderId: orderEntity.orderId,
              customerId: orderEntity.customerId,
              restaurantId: orderEntity.restaurantId,
              createdAt: orderEntity.createdAt,
              orderTypes: OrderTypes.completed.toString(),
              cartItems: orderEntity.cartItems,
              customerName: orderEntity.customerName,
            ).toMap();
            if (customerHistoryDoc.exists) {
              await customerHistoryCollection.doc(orderEntity.orderId).update(collectConfirmOrderCompleted);
            } else {
              await customerHistoryCollection.doc(orderEntity.orderId).set(collectConfirmOrderCompleted);
            }
          });
        }
        if (orderEntity.orderTypes == OrderTypes.collectToHistory.toString()) {
          await restaurantHistoryCollection.doc(orderEntity.orderId).get().then((restaurantHistoryDoc) async {
            final collectionConfirmOrder = OrderModel(
              vendorEntity: orderEntity.vendorEntity,
              orderId: orderEntity.orderId,
              customerId: orderEntity.customerId,
              restaurantId: orderEntity.restaurantId,
              createdAt: orderEntity.createdAt,
              orderTypes: OrderTypes.collectToHistory.toString(),
              cartItems: orderEntity.cartItems,
              customerName: orderEntity.customerName,
            ).toMap();
            if (restaurantHistoryDoc.exists) {
              await restaurantHistoryCollection.doc(orderEntity.orderId).update(collectionConfirmOrder);
            } else {
              await restaurantHistoryCollection.doc(orderEntity.orderId).set(collectionConfirmOrder);
            }
          });
          await deleteOrder(orderEntity);
        }
      } else {
        await orderCollection.doc(orderEntity.orderId).set(newOrderModel);

        if (orderEntity.orderTypes == OrderTypes.pending.toString()) {
          await customerHistoryCollection.doc(orderEntity.orderId).get().then((orderHistoryDoc) async {
            final collectionConfirmOrder = OrderModel(
              vendorEntity: orderEntity.vendorEntity,
              orderId: orderEntity.orderId,
              customerId: orderEntity.customerId,
              restaurantId: orderEntity.restaurantId,
              createdAt: orderEntity.createdAt,
              orderTypes: OrderTypes.accept.toString(),
              cartItems: orderEntity.cartItems,
              customerName: orderEntity.customerName,
            ).toMap();
            if (orderHistoryDoc.exists) {
              await customerHistoryCollection.doc(orderEntity.orderId).update(collectionConfirmOrder);
            } else {
              await customerHistoryCollection.doc(orderEntity.orderId).set(collectionConfirmOrder);
            }
          });
        }
      }
    });
  }

  @override
  Stream<List<OrderEntity>> receiveOrderItemFromCustomer(String uid, String orderType) {
    final orderCollection = firebaseFireStore.collection(FirebaseConst.orders);
    return orderCollection
        .where("restaurantId", isEqualTo: uid)
        .where("orderTypes", isEqualTo: orderType)
        .snapshots()
        .map<List<OrderEntity>>(
            (querySnapShot) => querySnapShot.docs.map<OrderEntity>((e) => OrderModel.fromMap(e.data())).toList());
  }

  @override
  Future<void> deleteOrder(OrderEntity orderEntity) async {
    final orderCollection = firebaseFireStore.collection(FirebaseConst.orders);
    await orderCollection.doc(orderEntity.orderId).delete();

    if (orderEntity.orderTypes == OrderTypes.pending.toString()) {
      final returnTotalPrice =
          orderEntity.cartItems!.fold(0.0, (previousValue, element) => previousValue + element.totalPrice!).floor();

      final currentBalance = await getAccountBalance(orderEntity.customerId ?? "");

      final totalBalance = currentBalance + returnTotalPrice;

      await firebaseFireStore
          .collection(FirebaseConst.customer)
          .doc(orderEntity.customerId)
          .update({"balance": totalBalance}).catchError((e) {
        log(e.toString());
      });
      final restaurantHistoryCollection = firebaseFireStore
          .collection(FirebaseConst.restaurant)
          .doc(orderEntity.restaurantId)
          .collection(FirebaseConst.restaurantHistory);
      final customerHistoryCollection = firebaseFireStore
          .collection(FirebaseConst.customer)
          .doc(orderEntity.customerId)
          .collection(FirebaseConst.customerHistory);

      final cancelOrderEntity = OrderModel(
        vendorEntity: orderEntity.vendorEntity,
        orderId: orderEntity.orderId,
        customerId: orderEntity.customerId,
        restaurantId: orderEntity.restaurantId,
        createdAt: orderEntity.createdAt,
        orderTypes: OrderTypes.failure.toString(),
        cartItems: orderEntity.cartItems,
        customerName: orderEntity.customerName,
      ).toMap();

      await customerHistoryCollection.doc(orderEntity.orderId).get().then((customerHistoryDoc) async {
        if (customerHistoryDoc.exists) {
          await customerHistoryCollection.doc(orderEntity.orderId).update(cancelOrderEntity);
        } else {
          await customerHistoryCollection.doc(orderEntity.orderId).set(cancelOrderEntity);
        }
      });
      await restaurantHistoryCollection.doc(orderEntity.orderId).get().then((restaurantHistoryDoc) async {
        if (restaurantHistoryDoc.exists) {
          await restaurantHistoryCollection.doc(orderEntity.orderId).update(cancelOrderEntity);
        } else {
          await restaurantHistoryCollection.doc(orderEntity.orderId).set(cancelOrderEntity);
        }
      });
    }
  }

  @override
  Stream<List<ConfirmOrderEntity>> receiveOrderItemFromRestaurants(String uid) {
    final orderCollection = firebaseFireStore.collection(FirebaseConst.orders);

    return orderCollection
        .where("customerId", isEqualTo: uid)
        .snapshots()
        .map<List<ConfirmOrderEntity>>((querySnapShot) => querySnapShot.docs
            .map<ConfirmOrderEntity>(
              (e) => ConfirmOrderModel.fromMap(
                e.data(),
              ),
            )
            .toList());
  }

  @override
  Stream<List<ConfirmOrderEntity>> receiveCompletedOrderItemFromRestaurants(String uid) {
    final customerHistoryCollection =
        firebaseFireStore.collection(FirebaseConst.customer).doc(uid).collection(FirebaseConst.customerHistory);
    return customerHistoryCollection
        .where("customerId", isEqualTo: uid)
        .snapshots()
        .map<List<ConfirmOrderEntity>>((querySnapShot) => querySnapShot.docs
            .map<ConfirmOrderEntity>(
              (e) => ConfirmOrderModel.fromMap(
                e.data(),
              ),
            )
            .toList());
  }

  @override
  Future<void> createTransaction(TransactionEntity transactionEntity) async {
    final transactionCollection = firebaseFireStore
        .collection(FirebaseConst.customer)
        .doc(transactionEntity.customerId)
        .collection(FirebaseConst.transaction);
    try {
      if (transactionEntity.type == "paid") {
        final newPaidTransaction = TransactionModel(
          id: transactionEntity.id,
          date: transactionEntity.date,
          menuName: transactionEntity.menuName,
          resName: transactionEntity.resName,
          totalPrice: transactionEntity.totalPrice,
          type: transactionEntity.type,
        ).toMap();
        await transactionCollection.doc(transactionEntity.id).get().then((transactionDoc) async {
          if (transactionDoc.exists) {
            await transactionCollection.doc(transactionEntity.id).update(newPaidTransaction);
          } else {
            await transactionCollection.doc(transactionEntity.id).set(newPaidTransaction);
          }
        });
      } else if (transactionEntity.type == "deposit") {
        final newDepositTransaction = TransactionModel(
          id: transactionEntity.id,
          customerId: transactionEntity.customerId,
          date: transactionEntity.date,
          name: transactionEntity.name,
          type: transactionEntity.type,
          deposit: transactionEntity.deposit,
        ).toMap();
        await transactionCollection.doc(transactionEntity.id).get().then((transactionDoc) async {
          if (transactionDoc.exists) {
            await transactionCollection.doc(transactionEntity.id).update(newDepositTransaction);
          } else {
            await transactionCollection.doc(transactionEntity.id).set(newDepositTransaction);
          }
        });
      } else {
        final newWithDrawTransaction = TransactionModel(
          id: transactionEntity.id,
          customerId: transactionEntity.customerId,
          date: transactionEntity.date,
          name: transactionEntity.name,
          type: transactionEntity.type,
          withdraw: transactionEntity.withdraw,
        ).toMap();
        await transactionCollection.doc(transactionEntity.id).get().then((transactionDoc) async {
          if (transactionDoc.exists) {
            await transactionCollection.doc(transactionEntity.id).update(newWithDrawTransaction);
          } else {
            await transactionCollection.doc(transactionEntity.id).set(newWithDrawTransaction);
          }
        });
      }
    } catch (e) {
      log("in rdsImpl: ${e.toString()}");
    }
  }

  @override
  Future<num> getAccountBalance(String uid) async {
    return await firebaseFireStore
        .collection(FirebaseConst.customer)
        .doc(uid)
        .get()
        .then((customerDoc) => customerDoc['balance']);
  }

  @override
  Stream<List<OrderEntity>> receiveOrderByDateTime(Timestamp timestamp) async* {
    final uid = await getCurrentUid();
    final restaurantHistoryCollection =
        firebaseFireStore.collection(FirebaseConst.restaurant).doc(uid).collection(FirebaseConst.restaurantHistory);
    final startOfDay = DateTime(timestamp.toDate().year, timestamp.toDate().month, timestamp.toDate().day);
    final endOfDay = DateTime(timestamp.toDate().year, timestamp.toDate().month, timestamp.toDate().day + 1);

    final querySnapshot = await restaurantHistoryCollection
        .where("createdAt", isGreaterThanOrEqualTo: startOfDay)
        .where("createdAt", isLessThan: endOfDay)
        .get();

    final orderEntities = querySnapshot.docs.map<OrderEntity>((orderDoc) => OrderModel.fromMap(orderDoc.data())).toList();
    yield orderEntities;
  }

  @override
  Future<void> approveCustomerDepositOrWithdraw(CustomerEntity customerEntity) async {
    final customerCollection = firebaseFireStore.collection(FirebaseConst.customer).doc(customerEntity.uid);
    final customerSnapshot = await customerCollection.get();
    final currentBalance = (customerSnapshot.data()?['balance'] ?? 0) as num;

    num newBalance = 0;
    if (customerEntity.depositAmount != null && customerEntity.withdrawAmount == null) {
      num amount = num.parse(customerEntity.depositAmount ?? "0");
      newBalance = currentBalance + amount;
    } else if (customerEntity.depositAmount == null && customerEntity.withdrawAmount != null) {
      num amount = num.parse(customerEntity.withdrawAmount ?? "0");
      newBalance = currentBalance - amount;
      if (newBalance < 0) {
        showFlutterToast("ไม่สามารถทำธุรกรรมได้เนื่องจากจำนวนเงินไม่เพียงพอต่อการถอน");
        return;
      }
    } else {
      log("ไม่มี transaction อันนี้ในระบบ");
    }
    // Update the balance in Firestore
    await customerCollection.update({'balance': newBalance});
  }

  @override
  Future<void> createTransactionFromAdminHistory(AdminTransactionEntity adminTransactionEntity) async {
    final uid = await getCurrentUid();
    final adminHistoryCollection =
        firebaseFireStore.collection(FirebaseConst.admin).doc(uid).collection(FirebaseConst.adminHistory);

    if (adminTransactionEntity.transactionType == "deposit") {
      final newAdminTransactionModel = AdminTransactionModel(
        id: adminTransactionEntity.id,
        date: adminTransactionEntity.date,
        customerName: adminTransactionEntity.customerName,
        deposit: adminTransactionEntity.deposit,
        transactionType: adminTransactionEntity.transactionType,
        withdraw: adminTransactionEntity.withdraw,
      ).toMap();

      await adminHistoryCollection.doc(adminTransactionEntity.id).get().then((adminTransactionDoc) async {
        if (adminTransactionDoc.exists) {
          await adminHistoryCollection.doc(adminTransactionEntity.id).update(newAdminTransactionModel);
        } else {
          await adminHistoryCollection.doc(adminTransactionEntity.id).set(newAdminTransactionModel);
        }
      });
    } else if (adminTransactionEntity.transactionType == "withdraw") {
      final newAdminTransactionModel = AdminTransactionModel(
        id: adminTransactionEntity.id,
        date: adminTransactionEntity.date,
        customerName: adminTransactionEntity.customerName,
        deposit: adminTransactionEntity.deposit,
        transactionType: adminTransactionEntity.transactionType,
        withdraw: adminTransactionEntity.withdraw,
      ).toMap();

      await adminHistoryCollection.doc(adminTransactionEntity.id).get().then((adminTransactionDoc) async {
        if (adminTransactionDoc.exists) {
          await adminHistoryCollection.doc(adminTransactionEntity.id).update(newAdminTransactionModel);
        } else {
          await adminHistoryCollection.doc(adminTransactionEntity.id).set(newAdminTransactionModel);
        }
      });
    }
  }

  @override
  Stream<List<AdminTransactionEntity>> getTransactionFromAdminHistoryByDateTime(Timestamp timestamp) async* {
    final uid = await getCurrentUid();
    final adminHistoryCollection =
        firebaseFireStore.collection(FirebaseConst.admin).doc(uid).collection(FirebaseConst.adminHistory);
    final startOfDay = DateTime(timestamp.toDate().year, timestamp.toDate().month, timestamp.toDate().day);
    final endOfDay = DateTime(timestamp.toDate().year, timestamp.toDate().month, timestamp.toDate().day + 1);

    final querySnapshot = await adminHistoryCollection
        .where("date", isGreaterThanOrEqualTo: startOfDay)
        .where("date", isLessThan: endOfDay)
        .get();

    final adminTransactionEntities =
        querySnapshot.docs.map((adminTransactionDoc) => AdminTransactionModel.fromMap(adminTransactionDoc.data())).toList();

    yield adminTransactionEntities;
  }

  @override
  Stream<List<VendorEntity>> getFavoriteRestaurants() {
    final favoritesSnapshot = firebaseFireStore.collection(FirebaseConst.favorites).snapshots();

    return favoritesSnapshot.map((querySnapshot) => querySnapshot.docs.map((e) => VendorEntity.fromMap(e.data())).toList());
  }

  @override
  Future<void> onAddFavoriteRestaurant(VendorEntity vendorEntity) async {
    final favoriteCollection = firebaseFireStore.collection(FirebaseConst.favorites);
    final favoriteDoc = await favoriteCollection.doc(vendorEntity.uid).get();
    if (favoriteDoc.exists) {
      await favoriteCollection.doc(vendorEntity.uid).update(vendorEntity.toMap());
    } else {
      await favoriteCollection.doc(vendorEntity.uid).set(vendorEntity.toMap());
    }
  }

  @override
  Future<void> onRemoveFavorite(VendorEntity vendorEntity) async {
    log("${vendorEntity.uid}");
    final docSnapshot = await firebaseFireStore.collection(FirebaseConst.favorites).doc(vendorEntity.uid).get();

    if (docSnapshot.exists) {
      await docSnapshot.reference.delete().then((_) {
        log('Document successfully deleted.');
      }).catchError((error) {
        log('Error deleting document: $error');
      });
    }
  }
}

class FirebaseConst {
  static const String menu = "menu";
  static const String customer = "customer";
  static const String favorites = "favorites";
  static const String restaurant = "restuarant";
  static const String admin = "admin";
  static const String adminHistory = "adminHistory";
  static const String addons = "addons";
  static const String filterOption = "filterOption";
  static const String transaction = "transaction";
  static const String orders = "orders";
  static const String customerHistory = "customerHistory";
  static const String restaurantHistory = "restaurantHistory";
}
