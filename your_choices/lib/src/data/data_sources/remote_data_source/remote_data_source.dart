import 'dart:io';

import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';

import '../../../domain/entities/vendor/vendor_entity.dart';

abstract class FirebaseRemoteDataSource {
  //for Customer
  Future<void> signInCustomer(CustomerEntity customer);
  Future<void> signUpCustomer(CustomerEntity customer);
  Stream<List<CustomerEntity>> getSingleCustomer(String uid);
  Future<void> createCustomer(CustomerEntity customer);
  Future<void> updateCustomer(CustomerEntity customer);

  //utilities
  Future<bool> isSignIn();
  Future<void> signOut();
  Future<String> getCurrentUid();
  Future<String> uploadImageToStorage(File? file, String childName);
  Future<String> signinRole(String uid);

  //for vendor
  Future<void> signInVendor(VendorEntity vendorEntity);
  Future<void> signUpVendor(VendorEntity vendorEntity);
}
