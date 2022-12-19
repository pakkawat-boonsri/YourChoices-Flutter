part of 'customer_cubit.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();
}

class CustomerInitial extends CustomerState {
  @override
  List<Object> get props => [];
}

class CustomerLoading extends CustomerState {
  @override
  List<Object> get props => [];
}

class CustomerLoaded extends CustomerState {
  final CustomerEntity customerEntity;

  const CustomerLoaded({required this.customerEntity});

  @override
  List<Object> get props => [customerEntity];
}

class CustomerFailure extends CustomerState {
  @override
  List<Object> get props => [];
}
