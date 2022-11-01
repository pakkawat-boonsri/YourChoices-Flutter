import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_choices/src/customer_screen/model/customer_model.dart';
import 'package:your_choices/src/customer_screen/repository/customer_repository.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  CustomerRepository customerRepo;

  CustomerBloc(this.customerRepo) : super(CustomerLoading()) {
    on<FetchDataEvent>((event, emit) async {
      final data = await customerRepo.fetchData();
      emit(CustomerLoadedState(data!));
    });
    on<FetchTransactionEvent>((event, emit) async {
      emit(TransactionLoadingState());
      Future.delayed(const Duration(seconds: 1));
      final data = await customerRepo.fetchData();
      final transaction = data?.transaction;
      if (transaction != null) {
        emit(TransactionLoadedState(transaction));
      } else {
        return;
      }
    });
  }
}
