import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/restaurant/get_all_restaurant_usecase.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/restaurant/restaurant_state.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  final GetAllRestaurantUseCase getAllRestaurantUseCase;
  RestaurantCubit({
    required this.getAllRestaurantUseCase,
  }) : super(RestaurantInitial());

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
