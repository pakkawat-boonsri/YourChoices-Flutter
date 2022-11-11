// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_choices/src/restaurant_screen/model/restaurant_model.dart';

import 'package:your_choices/src/restaurant_screen/repository/restaurant_repo.dart';

part 'restaurant_event.dart';
part 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  RestaurantRepository restaurantRepository;

  RestaurantBloc(
    this.restaurantRepository,
  ) : super(RestaurantInitial()) {
    on<OnFetchingDataEvent>((event, emit) async {
      final data = await restaurantRepository.fetchRestaurantData();

      if (data != null) {
        emit(OnFetchedRestaurantData(data));
      }
    });
  }
}
