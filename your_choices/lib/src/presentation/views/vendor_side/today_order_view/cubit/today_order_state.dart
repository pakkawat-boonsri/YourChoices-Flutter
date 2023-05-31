part of 'today_order_cubit.dart';

abstract class TodayOrderState extends Equatable {
  const TodayOrderState();
}

class TodayOrderInitial extends TodayOrderState {
  @override
  List<Object?> get props => [];
}

class TodayOrderLoading extends TodayOrderState {
  @override
  List<Object?> get props => [];
}

class TodayOrderLoaded extends TodayOrderState {
  final List<OrderEntity> orderEntities;

  const TodayOrderLoaded({required this.orderEntities});
  @override
  List<Object?> get props => [orderEntities];
}

class TodayOrderFailure extends TodayOrderState {
  @override
  List<Object?> get props => [];
}
