import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/restaurant/get_all_restaurant_usecase.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/restaurant/restaurant_state.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  final GetAllRestaurantUseCase getAllRestaurantUseCase;
  RestaurantCubit({
    required this.getAllRestaurantUseCase,
  }) : super(RestaurantInitial());

  Future<void> getByRestaurantType({required String type}) async {
    emit(RestaurantLoadingData());
    try {
      final restaurant = getAllRestaurantUseCase.call();
      restaurant.listen((vendorEntities) {
        List<VendorEntity> filteredTypesOfVendorEntities =
            vendorEntities.where((element) => element.restaurantType == type).toList();
        emit(RestaurantLoadedData(vendorEntities: filteredTypesOfVendorEntities));
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getAllRestaurant() async {
    emit(RestaurantLoadingData());
    try {
      final restaurant = getAllRestaurantUseCase.call();
      restaurant.listen((vendorEntities) {
        emit(RestaurantLoadedData(vendorEntities: vendorEntities));
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
