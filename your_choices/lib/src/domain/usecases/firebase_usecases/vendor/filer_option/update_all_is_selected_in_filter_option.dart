import '../../../../repositories/firebase_repository.dart';

class UpdateAllIsSelectedFilterOptionUseCase {
  final FirebaseRepository repository;

  UpdateAllIsSelectedFilterOptionUseCase({required this.repository});

  Future<void> call() async {
    return await repository.updateAllFilterOptionIsSelectedToFalse();
  }
}
