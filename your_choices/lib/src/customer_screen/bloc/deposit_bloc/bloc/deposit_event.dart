part of 'deposit_bloc.dart';

abstract class DepositEvent extends Equatable {
  const DepositEvent();
}

class SelectingIndexEvent extends DepositEvent {
  final int selectedIndex;

  const SelectingIndexEvent({required this.selectedIndex});

  @override
  List<Object> get props => [selectedIndex];
}
