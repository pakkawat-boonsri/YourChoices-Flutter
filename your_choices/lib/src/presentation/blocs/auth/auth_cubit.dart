import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../domain/usecases/firebase_usecases/customer/customer_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final CustomerUseCase customerUseCase;

  AuthCubit({required this.customerUseCase}) : super(AuthInitial());

  Future<void> appStarted(BuildContext context) async {
    try {
      bool isSignIn = await customerUseCase.isSignInCall();

      if (isSignIn == true) {
        String uid = await customerUseCase.getCurrentUidCall();
        emit(Authenticated(uid: uid));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedIn() async {
    try {
      final String uid = await customerUseCase.getCurrentUidCall();
      emit(Authenticated(uid: uid));
    } catch (e) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggingOut() async {
    try {
      await customerUseCase.signOutCall();
      emit(UnAuthenticated());
    } catch (e) {
      emit(UnAuthenticated());
    }
  }
}
