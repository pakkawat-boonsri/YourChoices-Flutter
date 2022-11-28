// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_choices/src/restaurant_screen/model/restaurant_model.dart';

import 'package:your_choices/src/restaurant_screen/repository/restaurant_repo.dart';

part 'restaurant_event.dart';
part 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  RestaurantRepository restaurantRepository;

  RestaurantBloc(this.restaurantRepository) : super(RestaurantInitial()) {
    on<OnFetchingDataEvent>(
      (event, emit) async {
        final data = await restaurantRepository.fetchRestaurantData();
        log("fetching data");

        if (data != null) {
          log("fetched data");
          await Future.delayed(const Duration(seconds: 1));
          emit(
            OnFetchedRestaurantData(data),
          );
        } else {
          return;
        }
      },
    );
    on<OnUpdateCheckbox>(
      (event, emit) async {
        await restaurantRepository.updateData(event.isChecked, event.index);
        final data = await restaurantRepository.fetchRestaurantData();

        if (data != null) {
          final checkbox = data[event.index]
              .foods![event.index]
              .addOns![event.index]
              .isChecked;
          final addons =
              data[event.index].foods![event.index].addOns![event.index];
          emit(OnSelectedCheckBox(
            addons,
            isChecked: checkbox,
          ));
        } else {
          return;
        }
      },
    );
  }
}
