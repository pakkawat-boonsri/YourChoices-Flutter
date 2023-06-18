import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_choices/src/domain/entities/vendor/add_ons/add_ons_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filer_option/create_filter_option_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filer_option/delete_filter_option_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filer_option/on_delete_addon_in_filter_option_detail_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filer_option/read_filter_option_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filer_option/update_filter_option_usecase.dart';

import '../../../../../utilities/show_flutter_toast.dart';
import 'filter_options_state.dart';

class FilterOptionCubit extends Cubit<FilterOptionState> {
  final CreateFilterOptionUseCase createFilterOptionUseCase;
  final ReadFilterOptionUseCase readFilterOptionUseCase;
  final UpdateFilterOptionUseCase updateFilterOptionUseCase;
  final DeleteFilterOptionUseCase deleteFilterOptionUseCase;
  final OnDeleteAddonInFilterOptionDetailUseCase onDeleteAddonInFilterOptionDetail;
  FilterOptionCubit({
    required this.createFilterOptionUseCase,
    required this.readFilterOptionUseCase,
    required this.updateFilterOptionUseCase,
    required this.deleteFilterOptionUseCase,
    required this.onDeleteAddonInFilterOptionDetail,
  }) : super(const FilterOptionLoading());

  Future<void> createFilterOption({required FilterOptionEntity filterOptionEntity}) async {
    emit(const FilterOptionLoading());
    try {
      await createFilterOptionUseCase.call(filterOptionEntity);
    } on SocketException catch (_) {
      emit(FilterOptionFailure());
    } catch (e) {
      emit(FilterOptionFailure());
    }
  }

  Future<void> readFilterOption({required String uid}) async {
    emit(const FilterOptionLoading());
    try {
      final data = readFilterOptionUseCase.call(uid);

      data.listen((filterOptionEntity) {
        emit(FilterOptionLoadCompleted(
          filterOptionEntityList: filterOptionEntity,
        ));
      });
    } on SocketException catch (_) {
      showFlutterToast(_.message);
    } catch (e) {
      showFlutterToast(e.toString());
    }
  }

  Future<void> updateFilterOption({required FilterOptionEntity filterOptionEntity}) async {
    try {
      await updateFilterOptionUseCase.call(filterOptionEntity);
    } on SocketException catch (_) {
      emit(FilterOptionFailure());
    } catch (e) {
      emit(FilterOptionFailure());
    }
  }

  Future<void> deleteFilterOption({required FilterOptionEntity filterOptionEntity}) async {
    try {
      await deleteFilterOptionUseCase.call(filterOptionEntity);
    } on SocketException catch (_) {
      emit(FilterOptionFailure());
    } catch (e) {
      emit(FilterOptionFailure());
    }
  }

  Future<void> onDeletingAddOnsInFilterOptionDetail({required FilterOptionEntity filterOptionEntity ,required List<AddOnsEntity> addOnsEntity,}) async {
    try {
      // ignore: avoid_function_literals_in_foreach_calls
      addOnsEntity.forEach((element) async {
        await onDeleteAddonInFilterOptionDetail.call(filterOptionEntity,element);
      });
    } on SocketException catch (_) {
      emit(FilterOptionFailure());
    } catch (e) {
      emit(FilterOptionFailure());
    }
  }
}
