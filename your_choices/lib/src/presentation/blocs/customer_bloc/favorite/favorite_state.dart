// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';

class FavoriteState extends Equatable {
  final List<VendorEntity> vendorEntities;
  const FavoriteState({
    required this.vendorEntities,
  });

  FavoriteState copyWith({
    List<VendorEntity>? vendorEntities,
  }) {
    return FavoriteState(
      vendorEntities: vendorEntities ?? this.vendorEntities,
    );
  }

  @override
  List<Object?> get props => [vendorEntities];
}
