// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:your_choices/src/domain/entities/customer/transaction/transaction_entity.dart';
import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

class CreateTransactionUseCase {
  final FirebaseRepository repository;
  CreateTransactionUseCase({
    required this.repository,
  });
  
  Future<void> call(TransactionEntity transactionEntity) async{
    return await repository.createTransaction(transactionEntity);
  }
}
