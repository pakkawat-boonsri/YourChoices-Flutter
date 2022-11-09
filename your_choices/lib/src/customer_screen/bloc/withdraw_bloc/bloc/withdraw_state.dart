part of 'withdraw_bloc.dart';

abstract class WithdrawState extends Equatable {
  const WithdrawState();
}

class WithdrawInitial extends WithdrawState {
  @override
  List<Object> get props => [];
}

class OnSelectedState extends WithdrawState {
  final int index;

  const OnSelectedState({required this.index});

  @override
  List<Object?> get props => [index];
}
