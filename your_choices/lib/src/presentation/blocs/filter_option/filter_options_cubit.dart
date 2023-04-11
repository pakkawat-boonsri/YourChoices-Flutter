// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';

import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filer_option/create_filter_option_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filer_option/delete_filter_option_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filer_option/read_filter_option_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filer_option/update_filter_option_usecase.dart';

import '../../../../utilities/show_flutter_toast.dart';
import 'filter_options_state.dart';

class FilterOptionCubit extends Cubit<FilterOptionState> {
  final CreateFilterOptionUseCase createFilterOptionUseCase;
  final ReadFilterOptionUseCase readFilterOptionUseCase;
  final UpdateFilterOptionUseCase updateFilterOptionUseCase;
  final DeleteFilterOptionUseCase deleteFilterOptionUseCase;
  FilterOptionCubit({
    required this.createFilterOptionUseCase,
    required this.readFilterOptionUseCase,
    required this.updateFilterOptionUseCase,
    required this.deleteFilterOptionUseCase,
  }) : super(const FilterOptionLoading());

  Future<void> createFilterOption(
      {required FilterOptionEntity filterOptionEntity}) async {
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

  Future<void> updateFilterOption(
      {required FilterOptionEntity filterOptionEntity}) async {
    try {
      await updateFilterOptionUseCase.call(filterOptionEntity);
    } on SocketException catch (_) {
      emit(FilterOptionFailure());
    } catch (e) {
      emit(FilterOptionFailure());
    }
  }

  Future<void> deleteFilterOption(
      {required FilterOptionEntity filterOptionEntity}) async {
    try {
      await deleteFilterOptionUseCase.call(filterOptionEntity);
    } on SocketException catch (_) {
      emit(FilterOptionFailure());
    } catch (e) {
      emit(FilterOptionFailure());
    }
  }


}
