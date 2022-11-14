part of 'restaurant_bloc.dart';

abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();
}

class OnFetchingDataEvent extends RestaurantEvent {
  @override
  List<Object> get props => [];
}

class OnUpdateCheckbox extends RestaurantEvent {
  final bool isChecked;
  final int index;

  const OnUpdateCheckbox(this.isChecked, this.index);
  @override
  List<Object> get props => [isChecked,index];
}
