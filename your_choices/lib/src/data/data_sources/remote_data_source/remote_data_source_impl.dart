import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_choices/src/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseFirestore firebaseFireStore;
  final FirebaseAuth firebaseAuth;

  FirebaseRemoteDataSourceImpl({
    required this.firebaseFireStore,
    required this.firebaseAuth,
  });

  @override
  Future<void> createCustomer(CustomerEntity customer) async {
    // TODO: implement createCustomer
    throw UnimplementedError();
  }

  @override
  Future<String> getCurrentUid() async {
    // TODO: implement getCurrentUid
    throw UnimplementedError();
  }

  @override
  Stream<CustomerEntity> getSingleCustomer(String uid) {
    // TODO: implement getSingleCustomer
    throw UnimplementedError();
  }

  @override
  Future<bool> isSignIn() async {
    // TODO: implement isSignIn
    throw UnimplementedError();
  }

  @override
  Future<void> signInCustomer(CustomerEntity customer) async {
    // TODO: implement signInCustomer
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<void> signUpCustomer(CustomerEntity customer) async {
    // TODO: implement signUpCustomer
    throw UnimplementedError();
  }

  @override
  Future<void> updateCustomer(CustomerEntity customer) async {
    // TODO: implement updateCustomer
    throw UnimplementedError();
  }
}
