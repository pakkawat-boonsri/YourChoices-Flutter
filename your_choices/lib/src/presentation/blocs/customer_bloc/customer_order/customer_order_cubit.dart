// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_choices/src/domain/entities/customer/confirm_order/confirm_order_entity.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/restaurant/receive_order_from_restaurant_usecase.dart';

part 'customer_order_state.dart';

class CustomerOrderCubit extends Cubit<CustomerOrderState> {
  final ReceiveOrderFromRestaurantUseCase receiveOrderFromRestaurantUseCase;
  CustomerOrderCubit({
    required this.receiveOrderFromRestaurantUseCase,
  }) : super(CustomerOrderInitial());

  void receiveOrderFromRestaurant(String uid) {
    emit(CustomerOrderLoading());
    Future.delayed(const Duration(milliseconds: 800)).then((value) {
      try {
        final data = receiveOrderFromRestaurantUseCase.call(uid);
        data.listen((confirmOrderList) {
          emit(CustomerOrderLoaded(confirmOrderEntities: confirmOrderList));
        });
      } catch (e) {
        log(e.toString());
      }
    });
  }
}
