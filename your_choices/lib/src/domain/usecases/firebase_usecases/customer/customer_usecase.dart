import 'dart:io';

import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

class CustomerUseCase {
  final FirebaseRepository repository;

  CustomerUseCase({required this.repository});

  Future<void> signInCustomerCall(CustomerEntity customer) {
    return repository.signInCustomer(customer);
  }

  Future<void> signUpCustomerCall(CustomerEntity customer) {
    return repository.signUpCustomer(customer);
  }

  Future<bool> isSignInCall() {
    return repository.isSignIn();
  }

  Future<void> signOutCall() {
    return repository.signOut();
  }

  Stream<List<CustomerEntity>> getSingleCustomerCall(String uid) {
    return repository.getSingleCustomer(uid);
  }

  Future<String> getCurrentUidCall() {
    return repository.getCurrentUid();
  }

  Future<void> createCustomerCall(CustomerEntity customer) {
    return repository.createCustomer(customer);
  }

  Future<void> updateCustomerCall(CustomerEntity customer) {
    return repository.updateCustomer(customer);
  }

  Future<String> uploadImageToStorageCall(
    File file,
    bool isPost,
    String childName,
  ) async {
    return repository.uploadImageToStorage(
      file,
      isPost,
      childName,
    );
  }
}
