import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/customer/customer_entity.dart';
import '../../../domain/usecases/firebase_usecases/customer/customer_usecase.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final CustomerUseCase customerUseCase;

  CredentialCubit({required this.customerUseCase}) : super(CredentialInitial());

  Future<void> signInCustomer(
      {required String email, required String password}) async {
    emit(CredentialLoading());
    try {
      await customerUseCase.signInCustomerCall(
        CustomerEntity(
          email: email,
          password: password,
        ),
      );
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (e) {
      emit(CredentialFailure());
    }
  }

  Future<void> signUpCustomer({required CustomerEntity customerEntity}) async {
    emit(CredentialLoading());
    try {
      await customerUseCase.signUpCustomerCall(customerEntity);
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (e) {
      emit(CredentialFailure());
    }
  }
}
