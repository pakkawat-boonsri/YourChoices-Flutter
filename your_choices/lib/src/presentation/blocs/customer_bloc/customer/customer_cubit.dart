// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/domain/entities/customer/transaction/transaction_entity.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/create_transaction_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/get_single_customer_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/update_customer_info_usecase.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  final GetSingleCustomerUseCase getSingleCustomerUseCase;
  final UpdateCustomerInfoUseCase updateCustomerInfoUseCase;
  final CreateTransactionUseCase createTransactionUseCase;
  CustomerCubit({
    required this.getSingleCustomerUseCase,
    required this.updateCustomerInfoUseCase,
    required this.createTransactionUseCase,
  }) : super(CustomerInitial());

  Future<void> createTransaction(TransactionEntity transactionEntity) async {
    try {
      await createTransactionUseCase.call(transactionEntity);
    } catch (e) {
      log("in customer cubit : ${e.toString()}");
    }
  }

  Future<void> getSingleCustomer({required String uid}) async {
    emit(CustomerLoading());

    try {
      final data = getSingleCustomerUseCase.call(uid);
      data.listen(
        (customerData) {
          if (customerData.transaction?.isNotEmpty ?? false) {
            customerData.transaction!.sort(
              (a, b) {
                final newA = a.date!.toDate();
                final newB = b.date!.toDate();
                return newB.compareTo(newA);
              },
            );
          }
          emit(
            CustomerLoaded(
              customerEntity: customerData,
            ),
          );
        },
      );
    } on SocketException catch (_) {
      emit(CustomerFailure());
    } catch (e) {
      emit(CustomerFailure());
    }
  }

  Future<void> updateCustomer({required CustomerEntity customerEntity}) async {
    // emit(CustomerLoading());
    try {
      await updateCustomerInfoUseCase.call(customerEntity);
    } on SocketException catch (_) {
      emit(CustomerFailure());
    } catch (e) {
      emit(CustomerFailure());
    }
  }
}
