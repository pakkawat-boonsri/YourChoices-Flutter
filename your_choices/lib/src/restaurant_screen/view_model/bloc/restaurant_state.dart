part of 'restaurant_bloc.dart';

abstract class RestaurantState extends Equatable {
  const RestaurantState();
}

class RestaurantInitial extends RestaurantState {
  @override
  List<Object> get props => [];
}

class OnFetchedRestaurantData extends RestaurantState {
  final RestaurantModel model;

  const OnFetchedRestaurantData(this.model);

  @override
  List<Object> get props => [model];
}
