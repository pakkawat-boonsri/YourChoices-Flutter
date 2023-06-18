// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

class OnAddFavoriteUseCase {
  final FirebaseRepository repository;
  OnAddFavoriteUseCase({
    required this.repository,
  });

  Future<void> call(VendorEntity vendorEntity) async {
    return await repository.onAddFavoriteRestaurant(vendorEntity);
  }
}
