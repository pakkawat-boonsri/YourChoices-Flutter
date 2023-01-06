import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

import '../../../entities/customer/customer_entity.dart';

class UpdateCustomerUseCase {
  final FirebaseRepository repository;

  UpdateCustomerUseCase({required this.repository});

   Future<void> call(CustomerEntity customer) {
    return repository.updateCustomer(customer);
  }
}
