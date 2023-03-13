import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';

import '../../../repositories/firebase_repository.dart';

class UpdateRestaurantInfoUseCase {
  final FirebaseRepository repository;

  UpdateRestaurantInfoUseCase({required this.repository});

  Future<void> call(VendorEntity vendorEntity) {
    return repository.updateRestaurantInfo(vendorEntity);
  }
}
