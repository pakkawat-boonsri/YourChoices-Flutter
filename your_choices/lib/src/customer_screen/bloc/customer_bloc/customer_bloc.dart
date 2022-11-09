import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_choices/src/customer_screen/model/customer_model.dart';
import 'package:your_choices/src/customer_screen/repository/customer_repository.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  CustomerRepository customerRepo;

  CustomerBloc(this.customerRepo) : super(CustomerInitial()) {
    on<FetchDataEvent>((event, emit) async {
      emit(CustomerLoadingState());
      await Future.delayed(const Duration(seconds: 1));
      final data = await customerRepo.fetchData();
      if (data != null) {
        emit(CustomerLoadedState(data));
      } else {
        return log("no data");
      }
    });
    on<FetchTransactionEvent>((event, emit) async {
      emit(TransactionLoadingState());
      await Future.delayed(const Duration(seconds: 1));
      final data = await customerRepo.fetchData();
      final transaction = data?.transaction;
      if (transaction != null) {
        transaction.sort(
          (a, b) {
            final newA = a.date!.toDate();
            final newB = b.date!.toDate();
            return newB.compareTo(newA);
          },
        );
        emit(TransactionLoadedState(transaction));
      } else {
        return;
      }
    });
  }
}
