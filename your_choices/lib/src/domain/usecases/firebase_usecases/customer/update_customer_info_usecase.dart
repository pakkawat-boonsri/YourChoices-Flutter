import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

class UpdateCustomerInfoUseCase {
  final FirebaseRepository repository;

  UpdateCustomerInfoUseCase({required this.repository});

  Future<void> call(CustomerEntity customer) async{
    return await repository.updateCustomerInfo(customer);
  }
}