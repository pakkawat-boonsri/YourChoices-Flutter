

import 'package:equatable/equatable.dart';

import '../../../../domain/entities/vendor/vendor_entity.dart';

abstract class RestaurantState extends Equatable {
  const RestaurantState();

  @override
  List<Object> get props => [];
}

class RestaurantInitial extends RestaurantState {
  @override
  List<Object> get props => [];
}

class RestaurantLoadingData extends RestaurantState {
  @override
  List<Object> get props => [];
}

class RestaurantLoadedData extends RestaurantState {
  final List<VendorEntity> vendorEntities;

  const RestaurantLoadedData({
    required this.vendorEntities,
  });

  @override
  List<Object> get props => [vendorEntities];
}

class RestaurantFailure extends RestaurantState {
  @override
  List<Object> get props => [];
}
