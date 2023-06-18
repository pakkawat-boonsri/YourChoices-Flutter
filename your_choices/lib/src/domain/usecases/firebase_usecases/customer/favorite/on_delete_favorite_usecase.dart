import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

class OnDeleteFavoriteUseCase {
  final FirebaseRepository repository;
  OnDeleteFavoriteUseCase({
    required this.repository,
  });

  Future<void> call(VendorEntity vendorEntity) async {
    return await repository.onRemoveFavorite(vendorEntity);
  }
}
