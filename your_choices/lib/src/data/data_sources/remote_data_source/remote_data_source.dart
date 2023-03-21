import 'dart:io';

import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';

import '../../../domain/entities/vendor/add_ons/add_ons_entity.dart';
import '../../../domain/entities/vendor/dishes_menu/dishes_entity.dart';
import '../../../domain/entities/vendor/filter_options/filter_option_entity.dart';
import '../../../domain/entities/vendor/vendor_entity.dart';

abstract class FirebaseRemoteDataSource {
  //for Customer
  Future<void> signUpCustomer(CustomerEntity customer);
  Stream<List<CustomerEntity>> getSingleCustomer(String uid);

  //for vendor
  Future<void> signUpVendor(VendorEntity vendorEntity);
  Stream<List<VendorEntity>> getSingleVendor(String uid);
  Future<void> openAndCloseRestaurant(VendorEntity vendorEntity);
  Future<void> updateRestaurantInfo(VendorEntity vendorEntity);
  //menu features
  Future<void> createMenu(DishesEntity dishesEntity);
  Stream<List<DishesEntity>> getMenu(String uid);
  Future<void> updateMenu(DishesEntity dishesEntity);
  Future<void> deleteMenu(DishesEntity dishesEntity);
  //menu filterOption feature
  Future<void> createFilterOption(FilterOptionEntity filterOptionEntity);
  Stream<List<FilterOptionEntity>> readFilterOption(
      FilterOptionEntity filterOptionEntity);
  Future<void> deleteFilterOption(FilterOptionEntity filterOptionEntity);

  //menu filterOption addons feature
  Future<void> createAddons(AddOnsEntity addOnsEntity);
  Stream<List<AddOnsEntity>> readAddons(AddOnsEntity addOnsEntity);
  Future<void> deleteAddons(AddOnsEntity addOnsEntity);

  //utilities
  Future<void> signInUser(String email, String password);
  Future<bool> isSignIn();
  Future<void> signOut();
  Future<String> getCurrentUid();
  Future<String> uploadImageToStorage(File? file, String childName);
  Future<String> signInRole(String uid);
}
