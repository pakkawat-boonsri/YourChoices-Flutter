import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';

import '../../../../repositories/firebase_repository.dart';

class ReadFilterOptionUseCase {
  final FirebaseRepository repository;

  ReadFilterOptionUseCase({required this.repository});

  Stream<List<FilterOptionEntity>> call(String uid) {
    return repository.readFilterOption(uid);
  }
}
