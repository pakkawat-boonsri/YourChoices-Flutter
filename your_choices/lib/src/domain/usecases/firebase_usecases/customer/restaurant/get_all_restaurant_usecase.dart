import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

import '../../../../entities/vendor/vendor_entity.dart';

class GetAllRestaurantUseCase {
  final FirebaseRepository repository;

  GetAllRestaurantUseCase({required this.repository});

  Stream<List<VendorEntity>> call() {
    return repository.getAllRestaurants();
  }
}
