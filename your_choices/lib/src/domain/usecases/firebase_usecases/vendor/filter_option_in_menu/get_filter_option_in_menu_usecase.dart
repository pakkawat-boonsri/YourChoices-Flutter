import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';

import '../../../../repositories/firebase_repository.dart';

class GetFilterOptionInMenuUseCase {
  final FirebaseRepository repository;

  GetFilterOptionInMenuUseCase({required this.repository});

  Stream<List<FilterOptionEntity>> call(DishesEntity dishesEntity) {
    return repository.getFilterOptionInMenu(dishesEntity);
  }
}
