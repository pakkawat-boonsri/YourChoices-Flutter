// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'order_history_cubit.dart';

class OrderHistoryState extends Equatable {
  final DateTime currentDate;
  final List<OrderEntity> orderEntities;
  const OrderHistoryState({
    required this.currentDate,
    required this.orderEntities,
  });

  @override
  List<Object> get props => [currentDate, orderEntities];

  OrderHistoryState copyWith({
    DateTime? currentDate,
    List<OrderEntity>? orderEntities,
  }) {
    return OrderHistoryState(
      currentDate: currentDate ?? this.currentDate,
      orderEntities: orderEntities ?? this.orderEntities,
    );
  }
}
