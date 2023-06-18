import 'package:your_choices/src/domain/entities/vendor/add_ons/add_ons_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';
import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

class OnDeleteAddonInFilterOptionInMenuUseCase {
  final FirebaseRepository repository;
  const OnDeleteAddonInFilterOptionInMenuUseCase({
    required this.repository,
  });

  Future<void> call(DishesEntity dishesEntity,FilterOptionEntity filterOptionEntity ,AddOnsEntity addOnsEntity) async {
    return await repository.onDeletingAddOnsInFilterOptionInMenu(dishesEntity,filterOptionEntity, addOnsEntity);
  }
}
