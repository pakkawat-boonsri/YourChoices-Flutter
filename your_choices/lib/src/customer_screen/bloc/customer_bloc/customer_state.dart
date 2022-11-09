part of 'customer_bloc.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();
}

class CustomerInitial extends CustomerState {
  @override
  List<Object?> get props => [];

}
class CustomerLoadingState extends CustomerState {
  @override
  List<Object?> get props => [];
}

class CustomerLoadedState extends CustomerState {
  final CustomerModel model;

  const CustomerLoadedState(this.model);

  @override
  List<Object> get props => [model];
}

class TransactionLoadingState extends CustomerState {
  @override
  List<Object?> get props => [];
}

class TransactionLoadedState extends CustomerState {
  final List<Transaction> transaction;

  const TransactionLoadedState(this.transaction);
  @override
  List<Object?> get props => [transaction];
}
