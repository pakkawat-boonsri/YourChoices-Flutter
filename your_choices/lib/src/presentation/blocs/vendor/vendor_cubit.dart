import 'dart:developer';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/get_single_vendor_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/is_active_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/update_restaurant_info_usecase.dart';

part 'vendor_state.dart';

class VendorCubit extends Cubit<VendorState> {
  final GetSingleVendorUseCase getSingleVendorUseCase;
  final IsActiveUseCase isActiveUseCase;
  final UpdateRestaurantInfoUseCase updateRestaurantInfoUseCase;
  VendorCubit({
    required this.updateRestaurantInfoUseCase,
    required this.isActiveUseCase,
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

  Future<void> openAndCloseRestaurant(VendorEntity vendorEntity) async {
    try {
      await isActiveUseCase.call(vendorEntity);
    } on SocketException catch (_) {
      emit(VendorFailure());
    } catch (e) {
      emit(VendorFailure());
    }
  }

  Future<void> updateRestaurantInfo(VendorEntity vendorEntity) async {
    try {
      await updateRestaurantInfoUseCase.call(vendorEntity);
    } on SocketException catch (_) {
      emit(VendorFailure());
    } catch (e) {
      emit(VendorFailure());
    }
  }
}
