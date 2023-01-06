import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/sign_in_customer_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/sign_up_customer_usecase.dart';

import '../../../domain/entities/customer/customer_entity.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final SignInCustomerUseCase signInCustomerUseCase;
  final SignUpCustomerUseCase signUpCustomerUseCase;

  CredentialCubit({
    required this.signUpCustomerUseCase,
    required this.signInCustomerUseCase,
  }) : super(CredentialInitial());

  Future<void> signInCustomer(
      {required String email, required String password}) async {
    emit(CredentialLoading());
    try {
      await signInCustomerUseCase.call(
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
      await signUpCustomerUseCase.call(customerEntity);
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (e) {
      emit(CredentialFailure());
    }
  }
}
