import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/get_single_vendor_usecase.dart';

part 'vendor_state.dart';

class VendorCubit extends Cubit<VendorState> {
  final GetSingleVendorUseCase getSingleVendorUseCase;
  VendorCubit({
    required this.getSingleVendorUseCase,
  }) : super(VendorInitial());

  Future<void> getSingleVendor({required String uid}) async {
    emit(VendorLoading());
    try {
      final data = getSingleVendorUseCase(uid);

      data.listen(
        (vendorData) {
          emit(
            VendorLoaded(
              vendorEntity: vendorData.first,
            ),
          );
          log("data in vendor cubit is loaded");
        },
      );
    } on SocketException catch (_) {
      emit(VendorFailure());
    } catch (e) {
      emit(VendorFailure());
    }
  }
}
