// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'order_history_cubit.dart';

abstract class OrderHistoryState extends Equatable {
  const OrderHistoryState();
}

class OrderHistoryInitial extends OrderHistoryState {
  const OrderHistoryInitial();

  @override
  List<Object?> get props => [];
}

class OrderHistoryLoading extends OrderHistoryState {
  const OrderHistoryLoading();

  @override
  List<Object?> get props => [];
}

class OrderHistoryLoaded extends OrderHistoryState {
  final DateTime currentDate;
  final List<OrderEntity> orderEntities;
  const OrderHistoryLoaded({
    required this.currentDate,
    required this.orderEntities,
  });

  @override
  List<Object?> get props => [orderEntities, currentDate];
}
