// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_choices/src/domain/entities/vendor/order/order_entity.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/order_history/receive_order_by_date_usecase.dart';

part 'order_history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  final ReceiveOrderByDateTimeUseCase receiveOrderByDateTimeUseCase;
  OrderHistoryCubit({
    required this.receiveOrderByDateTimeUseCase,
  }) : super(const OrderHistoryInitial());

  void receiveOrderByDateTime(Timestamp timestamp) {
    emit(const OrderHistoryLoading());
    Future.delayed(const Duration(milliseconds: 800)).then((value) {
      try {
        final orders = receiveOrderByDateTimeUseCase.call(timestamp);
        orders.listen((order) {
          emit(OrderHistoryLoaded(currentDate: DateTime.now(), orderEntities: order));
        });
      } catch (e) {
        log("inside OrderHistoryCubit => ${e.toString()}");
      }
    });
  }
}
