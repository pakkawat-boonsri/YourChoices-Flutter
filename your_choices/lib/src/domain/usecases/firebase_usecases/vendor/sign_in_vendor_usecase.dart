import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';

import '../../../repositories/firebase_repository.dart';

class SignInVendorUseCase {
  final FirebaseRepository repository;

  SignInVendorUseCase({required this.repository});

  Future<void> call(VendorEntity vendorEntity) {
    return repository.signInVendor(vendorEntity);
  }
}