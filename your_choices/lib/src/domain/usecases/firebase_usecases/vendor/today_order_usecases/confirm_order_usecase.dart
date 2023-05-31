import 'package:your_choices/src/domain/entities/vendor/order/order_entity.dart';
import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

class ConfirmOrderUseCase {
  final FirebaseRepository repository;

  const ConfirmOrderUseCase({required this.repository});

  Future<void> call(OrderEntity orderEntity) {
    return repository.confirmOrder(orderEntity);
  }
}