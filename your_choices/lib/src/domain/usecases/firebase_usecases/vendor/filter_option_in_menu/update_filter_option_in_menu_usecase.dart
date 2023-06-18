import '../../../../entities/vendor/filter_options/filter_option_entity.dart';
import '../../../../repositories/firebase_repository.dart';

class UpdateFilterOptionInMenuUseCase {
  final FirebaseRepository repository;

  UpdateFilterOptionInMenuUseCase({required this.repository});

  Future<void> call(FilterOptionEntity filterOptionEntity) {
    return repository.updateFilterOptionInMenu(filterOptionEntity);
  }
}
