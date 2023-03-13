import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';

import '../../../../repositories/firebase_repository.dart';

class UpdateMenuUseCase {
  final FirebaseRepository repository;

  UpdateMenuUseCase({required this.repository});

  Future<void> call(DishesEntity dishesEntity) {
    return repository.updateMenu(dishesEntity);
  }
}
