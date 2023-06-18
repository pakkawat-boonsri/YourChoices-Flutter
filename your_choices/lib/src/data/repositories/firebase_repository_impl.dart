import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choices/src/domain/entities/admin/admin_transaction_entity.dart';
import 'package:your_choices/src/domain/entities/customer/confirm_order/confirm_order_entity.dart';
import 'package:your_choices/src/domain/entities/customer/transaction/transaction_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/add_ons/add_ons_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/order/order_entity.dart';

import '../../domain/entities/customer/customer_entity.dart';
import '../../domain/entities/vendor/filter_options/filter_option_entity.dart';
import '../../domain/entities/vendor/vendor_entity.dart';
import '../../domain/repositories/firebase_repository.dart';
import '../data_sources/remote_data_source/remote_data_source.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseRemoteDataSource remoteDataSource;

  FirebaseRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<String> getCurrentUid() async {
    return remoteDataSource.getCurrentUid();
  }

  @override
  Stream<CustomerEntity> getSingleCustomer(String uid) {
    return remoteDataSource.getSingleCustomer(uid);
  }

  @override
  Future<bool> isSignIn() async {
    return remoteDataSource.isSignIn();
  }

  @override
  Future<void> signOut() async {
    return remoteDataSource.signOut();
  }

  @override
  Future<void> signUpCustomer(
    CustomerEntity customer,
  ) async {
    return remoteDataSource.signUpCustomer(customer);
  }

  @override
  Future<String> uploadImageToStorage(
    File? file,
    String childName,
  ) async {
    return remoteDataSource.uploadImageToStorage(file, childName);
  }

  @override
  Future<void> signUpVendor(VendorEntity vendorEntity) {
    return remoteDataSource.signUpVendor(vendorEntity);
  }

  @override
  Future<String> signInRole(String uid) async {
    return remoteDataSource.signInRole(uid);
  }

  @override
  Stream<List<VendorEntity>> getSingleVendor(String uid) {
    return remoteDataSource.getSingleVendor(uid);
  }

  @override
  Future<void> signInUser(String email, String password) async => remoteDataSource.signInUser(email, password);

  @override
  Future<void> createMenu(DishesEntity dishesEntity) async {
    return await remoteDataSource.createMenu(dishesEntity);
  }

  @override
  Future<void> deleteMenu(DishesEntity dishesEntity) async {
    return await remoteDataSource.deleteMenu(dishesEntity);
  }

  @override
  Stream<List<DishesEntity>> getMenu(String uid) {
    return remoteDataSource.getMenu(uid);
  }

  @override
  Stream<List<FilterOptionEntity>> getFilterOptionInMenu(DishesEntity dishesEntity) =>
      remoteDataSource.getFilterOptionInMenu(dishesEntity);

  @override
  Future<void> updateMenu(DishesEntity dishesEntity) async {
    return await remoteDataSource.updateMenu(dishesEntity);
  }

  @override
  Future<void> openAndCloseRestaurant(VendorEntity vendorEntity) async =>
      await remoteDataSource.openAndCloseRestaurant(vendorEntity);

  @override
  Future<void> updateRestaurantInfo(VendorEntity vendorEntity) async =>
      await remoteDataSource.updateRestaurantInfo(vendorEntity);

  @override
  Future<void> createFilterOption(FilterOptionEntity filterOptionEntity) async =>
      await remoteDataSource.createFilterOption(filterOptionEntity);

  @override
  Future<void> deleteFilterOption(FilterOptionEntity filterOptionEntity) async =>
      await remoteDataSource.deleteFilterOption(filterOptionEntity);

  @override
  Stream<List<FilterOptionEntity>> readFilterOption(String uid) => remoteDataSource.readFilterOption(uid);

  @override
  Future<void> updateFilterOption(FilterOptionEntity filterOptionEntity) async =>
      await remoteDataSource.updateFilterOption(filterOptionEntity);

  @override
  Future<void> addFilterOptionInMenu(DishesEntity dishesEntity ,FilterOptionEntity filterOptionEntity) async =>
      remoteDataSource.addFilterOptionInMenu( dishesEntity ,filterOptionEntity);

  @override
  Future<void> deleteFilterOptionInMenu(FilterOptionEntity filterOptionEntity) async =>
      remoteDataSource.deleteFilterOptionInMenu(filterOptionEntity);

  @override
  Future<void> updateFilterOptionInMenu(FilterOptionEntity filterOptionEntity) async =>
      remoteDataSource.updateFilterOptionInMenu(filterOptionEntity);

  @override
  Stream<List<VendorEntity>> getAllRestaurants() => remoteDataSource.getAllRestaurants();

  @override
  Future<void> updateCustomerInfo(CustomerEntity customerEntity) async =>
      remoteDataSource.updateCustomerInfo(customerEntity);

  @override
  Future<void> sendConfirmOrderToRestaurants(ConfirmOrderEntity confirmOrderEntity) async =>
      remoteDataSource.sendConfirmOrderToRestaurants(confirmOrderEntity);

  @override
  Stream<List<OrderEntity>> receiveOrderItemFromCustomer(String uid, String orderType) =>
      remoteDataSource.receiveOrderItemFromCustomer(uid, orderType);

  @override
  Future<void> confirmOrder(OrderEntity orderEntity) async => remoteDataSource.confirmOrder(orderEntity);

  @override
  Future<void> deleteOrder(OrderEntity orderEntity) async => remoteDataSource.deleteOrder(orderEntity);

  @override
  Stream<List<ConfirmOrderEntity>> receiveOrderItemFromRestaurants(String uid) =>
      remoteDataSource.receiveOrderItemFromRestaurants(uid);

  @override
  Future<void> createTransaction(TransactionEntity transactionEntity) async =>
      await remoteDataSource.createTransaction(transactionEntity);

  @override
  Future<num> getAccountBalance(String uid) async => remoteDataSource.getAccountBalance(uid);

  @override
  Stream<List<OrderEntity>> receiveOrderByDateTime(Timestamp timestamp) =>
      remoteDataSource.receiveOrderByDateTime(timestamp);

  @override
  Future<void> approveCustomerDepositOrWithdraw(CustomerEntity customerEntity) async =>
      remoteDataSource.approveCustomerDepositOrWithdraw(customerEntity);

  @override
  Stream<List<AdminTransactionEntity>> getTransactionFromAdminHistoryByDateTime(Timestamp timestamp) =>
      remoteDataSource.getTransactionFromAdminHistoryByDateTime(timestamp);

  @override
  Future<void> createTransactionFromAdminHistory(AdminTransactionEntity adminTransactionEntity) async =>
      remoteDataSource.createTransactionFromAdminHistory(adminTransactionEntity);

  @override
  Stream<List<ConfirmOrderEntity>> receiveCompletedOrderItemFromRestaurants(String uid) {
    return remoteDataSource.receiveCompletedOrderItemFromRestaurants(uid);
  }

  @override
  Stream<List<VendorEntity>> getFavorites() {
    return remoteDataSource.getFavoriteRestaurants();
  }

  @override
  Future<void> onAddFavoriteRestaurant(VendorEntity vendorEntity) async {
    return remoteDataSource.onAddFavoriteRestaurant(vendorEntity);
  }

  @override
  Future<void> onRemoveFavorite(VendorEntity vendorEntity) async {
    return remoteDataSource.onRemoveFavorite(vendorEntity);
  }

  @override
  Future<void> onDeletingAddOnsInFilterOptionDetail(FilterOptionEntity filterOptionEntity ,AddOnsEntity addOnsEntity) async {
    return await remoteDataSource.onDeletingAddOnsInFilterOptionDetail( filterOptionEntity ,addOnsEntity);
  }

  @override
  Future<void> onDeletingAddOnsInFilterOptionInMenu(DishesEntity dishesEntity,FilterOptionEntity filterOptionEntity ,AddOnsEntity addOnsEntity) async {
    return await remoteDataSource.onDeletingAddOnsInFilterOptionInMenu(dishesEntity,filterOptionEntity, addOnsEntity);
  }
}
