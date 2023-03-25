import 'dart:io';

import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';

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
  Stream<List<CustomerEntity>> getSingleCustomer(
    String uid,
  ) {
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
  Future<void> signInUser(String email, String password) async =>
      remoteDataSource.signInUser(email, password);

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
  Future<void> createFilterOption(
          FilterOptionEntity filterOptionEntity) async =>
      await remoteDataSource.createFilterOption(filterOptionEntity);

  @override
  Future<void> deleteFilterOption(
          FilterOptionEntity filterOptionEntity) async =>
      await remoteDataSource.deleteFilterOption(filterOptionEntity);

  @override
  Stream<List<FilterOptionEntity>> readFilterOption(String uid) =>
      remoteDataSource.readFilterOption(uid);

  @override
  Future<void> updateFilterOption(
          FilterOptionEntity filterOptionEntity) async =>
      await remoteDataSource.updateFilterOption(filterOptionEntity);

  @override
  Future<void> updateAllFilterOptionIsSelectedToFalse() async =>
      remoteDataSource.updateAllFilterOptionIsSelectedToFalse();
}
