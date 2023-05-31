import 'package:your_choices/src/domain/entities/vendor/order/order_entity.dart';
import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

class ReceiveTodayOrderUseCase {
  final FirebaseRepository repository;

  const ReceiveTodayOrderUseCase({required this.repository});

  Stream<List<OrderEntity>> call(String uid, String orderType) {
    return repository.receiveOrderItemFromCustomer(uid, orderType);
  }
}
