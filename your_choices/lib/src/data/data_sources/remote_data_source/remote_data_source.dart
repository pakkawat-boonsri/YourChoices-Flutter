import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choices/src/domain/entities/admin/admin_transaction_entity.dart';
import 'package:your_choices/src/domain/entities/customer/confirm_order/confirm_order_entity.dart';
import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/domain/entities/customer/transaction/transaction_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/order/order_entity.dart';

import '../../../domain/entities/vendor/dishes_menu/dishes_entity.dart';
import '../../../domain/entities/vendor/filter_options/filter_option_entity.dart';
import '../../../domain/entities/vendor/vendor_entity.dart';

abstract class FirebaseRemoteDataSource {
  //for admin
  Future<void> approveCustomerDepositOrWithdraw(CustomerEntity customerEntity);
  Future<void> createTransactionFromAdminHistory(AdminTransactionEntity adminTransactionEntity);
  Stream<List<AdminTransactionEntity>> getTransactionFromAdminHistoryByDateTime(Timestamp timestamp);

  //for Customer
  Future<void> signUpCustomer(CustomerEntity customer);
  Stream<List<CustomerEntity>> getSingleCustomer(String uid);
  Stream<List<VendorEntity>> getAllRestaurants();
  Future<num> getAccountBalance(String uid);
  Future<void> createTransaction(TransactionEntity transactionEntity);
  Future<void> updateCustomerInfo(CustomerEntity customerEntity);
  Future<void> sendConfirmOrderToRestaurants(ConfirmOrderEntity confirmOrderEntity);
  Stream<List<ConfirmOrderEntity>> receiveOrderItemFromRestaurants(String uid);

  //for vendor
  Future<void> signUpVendor(VendorEntity vendorEntity);
  Stream<List<VendorEntity>> getSingleVendor(String uid);
  Future<void> openAndCloseRestaurant(VendorEntity vendorEntity);
  Future<void> updateRestaurantInfo(VendorEntity vendorEntity);
  Stream<List<OrderEntity>> receiveOrderItemFromCustomer(String uid, String orderType);
  Stream<List<OrderEntity>> receiveOrderByDateTime(Timestamp timestamp);
  Future<void> confirmOrder(OrderEntity orderEntity);
  Future<void> deleteOrder(OrderEntity orderEntity);
  //menu features
  Future<void> createMenu(DishesEntity dishesEntity);
  Stream<List<DishesEntity>> getMenu(String uid);
  Stream<List<FilterOptionEntity>> getFilterOptionInMenu(DishesEntity dishesEntity);
  Future<void> updateMenu(DishesEntity dishesEntity);
  Future<void> deleteMenu(DishesEntity dishesEntity);

  //menuDetail features
  Future<void> addFilterOptionInMenu(FilterOptionEntity filterOptionEntity);
  Future<void> deleteFilterOptionInMenu(FilterOptionEntity filterOptionEntity);
  Future<void> updateFilterOptionInMenu(FilterOptionEntity filterOptionEntity);

  //filter option features
  Future<void> createFilterOption(FilterOptionEntity filterOptionEntity);
  Stream<List<FilterOptionEntity>> readFilterOption(String uid);
  Future<void> updateFilterOption(FilterOptionEntity filterOptionEntity);
  Future<void> deleteFilterOption(FilterOptionEntity filterOptionEntity);

  //utilities
  Future<void> signInUser(String email, String password);
  Future<bool> isSignIn();
  Future<void> signOut();
  Future<String> getCurrentUid();
  Future<String> uploadImageToStorage(File? file, String childName);
  Future<String> signInRole(String uid);
}
