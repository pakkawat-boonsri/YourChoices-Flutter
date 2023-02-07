import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/get_current_uid_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/sign_in_customer_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/sign_up_customer_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/sign_in_role.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/sign_in_vendor_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/sign_up_vendor_usecase.dart';

import '../../../domain/entities/customer/customer_entity.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final SignInCustomerUseCase signInCustomerUseCase;
  final SignUpCustomerUseCase signUpCustomerUseCase;
  final SignInVendorUseCase signInVendorUseCase;
  final SignUpVendorUseCase signUpVendorUseCase;
  final SignInRoleUseCase signInRoleUseCase;
  final GetCurrentUidUseCase getCurrentUidUseCase;

  CredentialCubit({
    required this.signInRoleUseCase,
    required this.getCurrentUidUseCase,
    required this.signInVendorUseCase,
    required this.signUpVendorUseCase,
    required this.signUpCustomerUseCase,
    required this.signInCustomerUseCase,
  }) : super(CredentialInitial());

  Future<void> checkSignInRole({
    required String email,
    required String password,
  }) async {
    try {
      emit(CredentialLoading());
      final String uid = await getCurrentUidUseCase.call();
      final String type = await signInRoleUseCase.call(uid);
      if(type == 'restaurant') {
        await signInVendorUseCase.call(
        VendorEntity(
          email: email,
          password: password,
        ),
      );
      emit(CredentialSuccess());
      } else {
        await signInCustomerUseCase.call(
        CustomerEntity(
          email: email,
          password: password,
        ),
      );
      emit(CredentialSuccess());
      }
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (e) {
      emit(CredentialFailure());
    }
  }

  // Future<void> signInCustomer({
  //   required String email,
  //   required String password,
  // }) async {
  //   emit(CredentialLoading());
  //   try {
  //     await signInCustomerUseCase.call(
  //       CustomerEntity(
  //         email: email,
  //         password: password,
  //       ),
  //     );
  //     emit(CredentialSuccess());
  //   } on SocketException catch (_) {
  //     emit(CredentialFailure());
  //   } catch (e) {
  //     emit(CredentialFailure());
  //   }
  // }

  // Future<void> signInVendor({
  //   required String email,
  //   required String password,
  // }) async {
  //   emit(CredentialLoading());
  //   try {
  //     await signInVendorUseCase.call(
  //       VendorEntity(
  //         email: email,
  //         password: password,
  //       ),
  //     );
  //     emit(CredentialSuccess());
  //   } on SocketException catch (_) {
  //     emit(CredentialFailure());
  //   } catch (e) {
  //     emit(CredentialFailure());
  //   }
  // }

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
