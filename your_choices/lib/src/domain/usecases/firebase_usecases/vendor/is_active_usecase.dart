import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

import '../../../entities/vendor/vendor_entity.dart';

class IsActiveUseCase {
  final FirebaseRepository repository;

  IsActiveUseCase({required this.repository});

  Future<void> call(VendorEntity vendorEntity) async {
    return await repository.openAndCloseRestaurant(vendorEntity);
  }
}
