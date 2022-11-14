// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'restaurant_bloc.dart';

abstract class RestaurantState extends Equatable {
  const RestaurantState();
}

class RestaurantInitial extends RestaurantState {
  @override
  List<Object> get props => [];
}

class OnFetchedRestaurantData extends RestaurantState {
  final List<RestaurantModel> model;

  const OnFetchedRestaurantData(this.model);

  @override
  List<Object> get props => [model];
}

class OnSelectedCheckBox extends RestaurantState {
  final bool isChecked;
  final AddOns addOns;
  const OnSelectedCheckBox(this.addOns, {required this.isChecked});
  @override
  List<Object> get props => [isChecked, addOns];
}

class OnSelectingCheckBox extends RestaurantState {
  @override
  List<Object> get props => [];
}
