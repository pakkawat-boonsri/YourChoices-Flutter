import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'deposit_event.dart';
part 'deposit_state.dart';

class DepositBloc extends Bloc<DepositEvent, DepositState> {
  DepositBloc() : super(DepositInitial()) {
    
    on<SelectingIndexEvent>((event, emit) {
      emit(SelectedIndexState(selectedIndex: event.selectedIndex));
      
    });
  }

}
