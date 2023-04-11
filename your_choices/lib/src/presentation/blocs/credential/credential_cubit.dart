import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/get_current_uid_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/sign_up_customer_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/utilities/sign_in_user_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/sign_up_vendor_usecase.dart';

import '../../../domain/entities/customer/customer_entity.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final SignInUserUseCase signInUserUseCase;
  final SignUpCustomerUseCase signUpCustomerUseCase;

  final SignUpVendorUseCase signUpVendorUseCase;

  final GetCurrentUidUseCase getCurrentUidUseCase;

  CredentialCubit({
    required this.signInUserUseCase,
    required this.getCurrentUidUseCase,
    required this.signUpVendorUseCase,
    required this.signUpCustomerUseCase,
  }) : super(CredentialInitial());

  Future<void> signInUser({
    required String email,
    required String password,
  }) async {
    emit(CredentialLoading());
    try {
      await signInUserUseCase.call(
        email,
        password,
      );
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (e) {
      emit(CredentialFailure());
    }
  }

  Future<void> signUpCustomer({
    required CustomerEntity customerEntity,
  }) async {
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

  Future<void> signUpVendor({
    required VendorEntity vendorEntity,
  }) async {
    emit(CredentialLoading());
    try {
      await signUpVendorUseCase.call(vendorEntity);
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (e) {
      emit(CredentialFailure());
    }
  }
}
