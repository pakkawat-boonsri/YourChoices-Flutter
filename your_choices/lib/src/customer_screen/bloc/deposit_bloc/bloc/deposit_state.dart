part of 'deposit_bloc.dart';

abstract class DepositState extends Equatable {
  const DepositState();
}

class DepositInitial extends DepositState {
  @override
  List<Object> get props => [];
}

class SelectedIndexState extends DepositState {
  final int selectedIndex;

  const SelectedIndexState({required this.selectedIndex});
  @override
  List<Object> get props => [selectedIndex];
}
