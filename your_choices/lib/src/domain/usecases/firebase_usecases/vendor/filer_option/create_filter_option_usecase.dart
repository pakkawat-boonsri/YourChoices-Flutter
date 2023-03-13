import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';

import '../../../../repositories/firebase_repository.dart';

class CreateFilterOptionUseCase {
  final FirebaseRepository repository;

  CreateFilterOptionUseCase({required this.repository});

  Future<void> call(FilterOptionEntity filterOptionEntity) {
    return repository.createFilterOption(filterOptionEntity);
  }
}
