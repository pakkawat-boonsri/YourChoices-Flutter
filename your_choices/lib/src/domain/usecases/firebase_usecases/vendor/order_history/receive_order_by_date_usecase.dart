// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choices/src/domain/entities/vendor/order/order_entity.dart';
import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

class ReceiveOrderByDateTimeUseCase {
  final FirebaseRepository repository;
  ReceiveOrderByDateTimeUseCase({
    required this.repository,
  });

  Stream<List<OrderEntity>> call(Timestamp timestamp) {
    return repository.receiveOrderByDateTime(timestamp);
  }
}
