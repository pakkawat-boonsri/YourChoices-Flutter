// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:your_choices/src/domain/entities/admin/admin_transaction_entity.dart';
import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/admin/approve_customer_deposit_or_withdraw_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/admin/create_transaction_from_admin_history_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/admin/get_transaction_from_admin_history_by_date_time_usecase.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final GetTransactionFromAdminHistoryByDateTimeUseCase getTransactionFromAdminHistoryByDateTimeUseCase;
  final ApproveCustomerDepositOrWithdrawUseCase approveCustomerDepositOrWithdrawUseCase;
  final CreateTransactionFromAdminHistoryUseCase createTransactionFromAdminHistoryUseCase;
  AdminCubit({
    required this.getTransactionFromAdminHistoryByDateTimeUseCase,
    required this.approveCustomerDepositOrWithdrawUseCase,
    required this.createTransactionFromAdminHistoryUseCase,
  }) : super(AdminInitial());

  Future<void> getAdminTransaction(Timestamp timestamp) async {
    emit(AdminLoading());
    Future.delayed(const Duration(seconds: 1)).then((value) {
      try {
        final data = getTransactionFromAdminHistoryByDateTimeUseCase.call(timestamp);
        data.listen((adminTransactions) {
          emit(AdminLoaded(transactions: adminTransactions));
        });
      } catch (e) {
        log("getAdminTransaction => ${e.toString()}");
      }
    });
  }

  Future<void> approveCustomerDepositWithdraw(CustomerEntity customerEntity) async {
    try {
      await approveCustomerDepositOrWithdrawUseCase.call(customerEntity);
    } catch (e) {
      log("approveCustomerDepositWithdraw => ${e.toString()}");
    }
  }

  Future<void> createAdminTransaction(AdminTransactionEntity adminTransactionEntity) async {
    try {
      await createTransactionFromAdminHistoryUseCase.call(adminTransactionEntity);
    } catch (e) {
      log("createAdminTransaction => ${e.toString()}");
    }
  }
}
