import 'package:your_choices/src/domain/entities/customer/confirm_order/confirm_order_entity.dart';
import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

class ReceiveCompletedOrderFromRestaurantUseCase {
  final FirebaseRepository repository;

  ReceiveCompletedOrderFromRestaurantUseCase({
    required this.repository,
  });

  Stream<List<ConfirmOrderEntity>> call(String uid) {
    return repository.receiveCompletedOrderItemFromRestaurants(uid);
  }
}
