import 'package:your_choices/src/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseRemoteDataSource remoteDataSource;

  FirebaseRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<void> createCustomer(CustomerEntity customer) async {
    return remoteDataSource.createCustomer(customer);
  }

  @override
  Future<String> getCurrentUid() async {
    return remoteDataSource.getCurrentUid();
  }

  @override
  Stream<List<CustomerEntity>> getSingleCustomer(String uid) {
    return remoteDataSource.getSingleCustomer(uid);
  }

  @override
  Future<bool> isSignIn() async {
    return remoteDataSource.isSignIn();
  }

  @override
  Future<void> signInCustomer(CustomerEntity customer) async {
    return remoteDataSource.signInCustomer(customer);
  }

  @override
  Future<void> signOut() async {
    return remoteDataSource.signOut();
  }

  @override
  Future<void> signUpCustomer(CustomerEntity customer) async {
    return remoteDataSource.signUpCustomer(customer);
  }

  @override
  Future<void> updateCustomer(CustomerEntity customer) async {
    return remoteDataSource.updateCustomer(customer);
  }
}
