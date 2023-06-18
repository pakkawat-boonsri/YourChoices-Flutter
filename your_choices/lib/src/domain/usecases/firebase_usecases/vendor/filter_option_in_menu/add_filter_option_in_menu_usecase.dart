import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';

import '../../../../entities/vendor/filter_options/filter_option_entity.dart';
import '../../../../repositories/firebase_repository.dart';

class AddFilterOptionInMenuUseCase {
  final FirebaseRepository repository;

  AddFilterOptionInMenuUseCase({required this.repository});

  Future<void> call(DishesEntity dishesEntity ,FilterOptionEntity filterOptionEntity) {
    return repository.addFilterOptionInMenu(dishesEntity,filterOptionEntity);
  }
}
