// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:your_choices/src/domain/entities/customer/confirm_order/confirm_order_entity.dart';
import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

class SendConfirmOrderToRestaurantUseCase {
  final FirebaseRepository repository;

  SendConfirmOrderToRestaurantUseCase({
    required this.repository,
  });

  Future<void> call(ConfirmOrderEntity confirmOrderEntity) async {
     await repository.sendConfirmOrderToRestaurants(confirmOrderEntity);
  }
}
