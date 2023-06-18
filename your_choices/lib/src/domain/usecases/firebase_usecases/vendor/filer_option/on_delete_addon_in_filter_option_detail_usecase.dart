import 'package:your_choices/src/domain/entities/vendor/add_ons/add_ons_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';
import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

class OnDeleteAddonInFilterOptionDetailUseCase {
  final FirebaseRepository repository;

  const OnDeleteAddonInFilterOptionDetailUseCase({
    required this.repository,
  });

  Future<void> call(FilterOptionEntity filterOptionEntity ,AddOnsEntity addOnsEntity) async {
    return await repository.onDeletingAddOnsInFilterOptionDetail(filterOptionEntity ,addOnsEntity);
  }
}
