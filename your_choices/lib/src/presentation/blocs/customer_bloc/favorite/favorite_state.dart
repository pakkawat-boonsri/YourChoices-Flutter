import 'package:equatable/equatable.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';

class FavoriteState extends Equatable {
  final List<VendorEntity> vendorEntities;
  const FavoriteState(
    this.vendorEntities,
  );

  @override
  List<Object> get props => [vendorEntities];

  FavoriteState copyWith({
    List<VendorEntity>? vendorEntities,
  }) {
    return FavoriteState(
      vendorEntities ?? this.vendorEntities,
    );
  }
}
