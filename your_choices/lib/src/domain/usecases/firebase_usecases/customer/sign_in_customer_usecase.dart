import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

class SignInCustomerUseCase {
  final FirebaseRepository repository;

  SignInCustomerUseCase({required this.repository});

  Future<void> call(CustomerEntity customer) {
    return repository.signInCustomer(customer);
  }
}