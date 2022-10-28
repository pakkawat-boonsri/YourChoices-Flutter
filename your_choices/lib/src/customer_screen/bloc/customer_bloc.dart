import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  CustomerBloc() : super(CustomerInitial()) {
    on<CustomerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
