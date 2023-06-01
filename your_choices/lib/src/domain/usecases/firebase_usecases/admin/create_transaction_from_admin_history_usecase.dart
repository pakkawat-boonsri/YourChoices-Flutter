// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:your_choices/src/domain/entities/admin/admin_transaction_entity.dart';
import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

class CreateTransactionFromAdminHistoryUseCase {
  final FirebaseRepository repository;
  CreateTransactionFromAdminHistoryUseCase({
    required this.repository,
  });
  Future<void> call(AdminTransactionEntity adminTransactionEntity) async {
    return await repository.createTransactionFromAdminHistory(adminTransactionEntity);
  }
}
