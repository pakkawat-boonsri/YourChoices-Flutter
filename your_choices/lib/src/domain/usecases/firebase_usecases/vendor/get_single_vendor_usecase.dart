import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

import '../../../entities/vendor/vendor_entity.dart';

class GetSingleVendorUseCase {
  final FirebaseRepository repository;

  GetSingleVendorUseCase({required this.repository});

  Stream<List<VendorEntity>> call(String uid) {
    return repository.getSingleVendor(uid);
  }
}
