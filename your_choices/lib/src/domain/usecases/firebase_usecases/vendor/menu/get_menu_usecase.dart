import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';

import '../../../../repositories/firebase_repository.dart';

class GetMenuUseCase {
  final FirebaseRepository repository;

  GetMenuUseCase({required this.repository});

  Stream<List<DishesEntity>> call(DishesEntity dishesEntity) {
    return repository.getMenu(dishesEntity);
  }
}
