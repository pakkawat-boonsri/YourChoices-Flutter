import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';

import '../../../../repositories/firebase_repository.dart';

class CreateMenuUseCase {
  final FirebaseRepository repository;

  CreateMenuUseCase({required this.repository});

  Future<void> call(DishesEntity dishesEntity) {
    return repository.createMenu(dishesEntity);
  }
}
