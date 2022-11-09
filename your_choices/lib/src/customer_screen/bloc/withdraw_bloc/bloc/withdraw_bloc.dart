// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'withdraw_event.dart';
part 'withdraw_state.dart';

class WithdrawBloc extends Bloc<WithdrawEvent, WithdrawState> {
  WithdrawBloc() : super(WithdrawInitial()) {
    on<OnSelectingEvent>((event, emit) {
      emit(OnSelectedState(index: event.index));
    });
  }
}
