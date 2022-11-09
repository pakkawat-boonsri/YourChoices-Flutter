// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'withdraw_bloc.dart';

abstract class WithdrawEvent extends Equatable {
  const WithdrawEvent();
}

class OnSelectingEvent extends WithdrawEvent {
  final int index;
  const OnSelectingEvent({
    required this.index,
  });

  @override
  List<Object?> get props => [index];
}
