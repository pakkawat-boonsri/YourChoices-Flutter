import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/customer/customer_entity.dart';
import '../../../domain/usecases/firebase_usecases/customer/customer_usecase.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  final CustomerUseCase customerUseCase;

  CustomerCubit({required this.customerUseCase}) : super(CustomerInitial());

  Future<void> getSingleCustomer({required String uid}) async {
    emit(CustomerLoading());

    try {
      final streamResponse = customerUseCase.getSingleCustomerCall(uid);
      streamResponse.listen((event) {
        emit(
          CustomerLoaded(customerEntity: event.first),
        );
      });
    } on SocketException catch (_) {
      emit(CustomerFailure());
    } catch (e) {
      emit(CustomerFailure());
    }
  }

  // Future<void> updateCustomer({required CustomerEntity customer}) async {
  //   emit(CustomerLoading());
  //   try {
  //     await customerUseCase.updateCustomerCall(customer);
  //     emit(CustomerLoaded(customerEntity: ));
  //   } on SocketException catch (e) {
  //     emit(CustomerFailure());
  //   } catch (e) {
  //     emit(CustomerFailure());
  //   }
  // }
}
