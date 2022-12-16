import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';

abstract class FirebaseRepository {
  //for Customer
  Future<void> signInCustomer(CustomerEntity customer);
  Future<void> signUpCustomer(CustomerEntity customer);

  //for vendor
  // Future<void> signInRestaurant(VendorEntity vendor);
  // Future<void> signUpRestaurant(VendorEntity customer);

  Future<bool> isSignIn();
  Future<void> signOut();

  Stream<CustomerEntity> getSingleCustomer(String uid);
  Future<String> getCurrentUid();
  Future<void> createCustomer(CustomerEntity customer);
  Future<void> updateCustomer(CustomerEntity customer);
}
