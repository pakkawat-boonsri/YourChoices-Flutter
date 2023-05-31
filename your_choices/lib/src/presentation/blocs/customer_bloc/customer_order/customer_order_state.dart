part of 'customer_order_cubit.dart';

abstract class CustomerOrderState extends Equatable {
  const CustomerOrderState();
}

class CustomerOrderInitial extends CustomerOrderState {
  @override
  List<Object?> get props => [];
}

class CustomerOrderLoading extends CustomerOrderState {
  @override
  List<Object?> get props => [];
}

class CustomerOrderLoaded extends CustomerOrderState {
  final List<ConfirmOrderEntity> confirmOrderEntities;

  const CustomerOrderLoaded({
    required this.confirmOrderEntities,
  });

  @override
  List<Object?> get props => [confirmOrderEntities];
}

class CustomerOrderFailure extends CustomerOrderState {
  @override
  List<Object?> get props => [];
}
