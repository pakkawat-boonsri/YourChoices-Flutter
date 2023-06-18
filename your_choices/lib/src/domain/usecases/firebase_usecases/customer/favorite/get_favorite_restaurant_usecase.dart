import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

class GetFavoriteRestaurantUseCase {
  final FirebaseRepository repository;
  GetFavoriteRestaurantUseCase({
    required this.repository,
  });

  Stream<List<VendorEntity>> call() {
    return repository.getFavorites();
  }
}
