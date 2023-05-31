// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_choices/src/domain/entities/vendor/order/order_entity.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/today_order_usecases/confirm_order_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/today_order_usecases/delete_order_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/today_order_usecases/receive_today_order_usecase.dart';

part 'today_order_state.dart';

class TodayOrderCubit extends Cubit<TodayOrderState> {
  final ConfirmOrderUseCase confirmOrderUseCase;
  final DeleteOrderUseCase deleteOrderUseCase;
  final ReceiveTodayOrderUseCase receiveTodayOrderUseCase;

  TodayOrderCubit({
    required this.confirmOrderUseCase,
    required this.deleteOrderUseCase,
    required this.receiveTodayOrderUseCase,
  }) : super(TodayOrderInitial());

  confirmOrder(OrderEntity orderEntity) async {
    try {
      await confirmOrderUseCase.call(orderEntity);
    } catch (e) {
      log(e.toString());
    }
  }

  deleteOrder(OrderEntity orderEntity) async {
    try {
      await deleteOrderUseCase.call(orderEntity);
    } catch (e) {
      log(e.toString());
    }
  }

  receiveOrderFromCustomer(String uid, String orderType) {
    emit(TodayOrderLoading());
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      try {
        final data = receiveTodayOrderUseCase.call(uid, orderType);
        data.listen((orderEntities) {
          emit(TodayOrderLoaded(orderEntities: orderEntities));
        });
      } catch (e) {
        emit(TodayOrderFailure());
      }
    });
  }
}
