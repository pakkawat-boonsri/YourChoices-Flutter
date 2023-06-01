// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choices/src/domain/entities/admin/admin_transaction_entity.dart';
import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

class GetTransactionFromAdminHistoryByDateTimeUseCase {
  final FirebaseRepository repository;

  GetTransactionFromAdminHistoryByDateTimeUseCase({
    required this.repository,
  });

  Stream<List<AdminTransactionEntity>> call(Timestamp timestamp) {
    return repository.getTransactionFromAdminHistoryByDateTime(timestamp);
  }
}
