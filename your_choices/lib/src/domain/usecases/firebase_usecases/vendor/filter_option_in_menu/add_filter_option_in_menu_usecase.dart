import '../../../../entities/vendor/filter_options/filter_option_entity.dart';
import '../../../../repositories/firebase_repository.dart';

class AddFilterOptionInMenuUseCase {
  final FirebaseRepository repository;

  AddFilterOptionInMenuUseCase({required this.repository});

  Future<void> call(FilterOptionEntity filterOptionEntity) {
    return repository.addFilterOptionInMenu(filterOptionEntity);
  }
}
