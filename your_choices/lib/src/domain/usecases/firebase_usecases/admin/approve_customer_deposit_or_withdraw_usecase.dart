import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

class ApproveCustomerDepositOrWithdrawUseCase {
  final FirebaseRepository repository;
  ApproveCustomerDepositOrWithdrawUseCase({
    required this.repository,
  });
  Future<void> call(CustomerEntity customerEntity) async {
    return await repository.approveCustomerDepositOrWithdraw(customerEntity);
  }
}
