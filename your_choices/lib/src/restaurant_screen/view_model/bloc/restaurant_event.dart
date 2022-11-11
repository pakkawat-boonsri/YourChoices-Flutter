part of 'restaurant_bloc.dart';

abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();
}

class OnFetchingDataEvent extends RestaurantEvent {
  @override
  List<Object> get props => [];
}