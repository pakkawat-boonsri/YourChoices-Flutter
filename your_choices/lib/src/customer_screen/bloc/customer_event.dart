part of 'customer_bloc.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();
}

class FetchDataEvent extends CustomerEvent {
  @override
  List<Object?> get props => [];
}

class FetchTransactionEvent extends CustomerEvent {
  @override
  List<Object?> get props => [];
}
