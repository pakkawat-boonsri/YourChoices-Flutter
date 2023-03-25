// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';

import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filer_option/create_filter_option_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filer_option/delete_filter_option_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filer_option/read_filter_option_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filer_option/update_all_is_selected_in_filter_option.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filer_option/update_filter_option_usecase.dart';

import '../../../../../utilities/show_flutter_toast.dart';
import '../../../../domain/entities/vendor/add_ons/add_ons_entity.dart';
import 'filter_option_state.dart';

class FilterOptionCubit extends Cubit<FilterOptionState> {
  final CreateFilterOptionUseCase createFilterOptionUseCase;
  final ReadFilterOptionUseCase readFilterOptionUseCase;
  final UpdateFilterOptionUseCase updateFilterOptionUseCase;
  final DeleteFilterOptionUseCase deleteFilterOptionUseCase;
  final UpdateAllIsSelectedFilterOptionUseCase
      updateAllIsSelectedFilterOptionUseCase;
  FilterOptionCubit({
    required this.createFilterOptionUseCase,
    required this.readFilterOptionUseCase,
    required this.updateFilterOptionUseCase,
    required this.deleteFilterOptionUseCase,
    required this.updateAllIsSelectedFilterOptionUseCase,
  }) : super(const FilterOptionInitial());

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

  Future<void> updateAllIsSelectedFilterOption() async {
    try {
      await updateAllIsSelectedFilterOptionUseCase.call();
    } on SocketException catch (_) {
      emit(FilterOptionFailure());
    } catch (e) {
      emit(FilterOptionFailure());
    }
  }

  final List<FilterOptionEntity> filterOptionList = [];

  List<FilterOptionEntity> get getFilterOptionList => filterOptionList;

  void addFilterOption(FilterOptionEntity filterOptionEntity) {
    filterOptionList.add(filterOptionEntity);
  }

  void removeFilterOption(FilterOptionEntity filterOptionEntity) {
    filterOptionList.removeWhere(
      (element) => element.filterId == filterOptionEntity.filterId,
    );
  }

  void resetFilterOption() {
    filterOptionList.clear();
  }

  final List<AddOnsEntity> addOnsList = <AddOnsEntity>[];

  List<AddOnsEntity> get getAddOnsList => addOnsList;

  Future<void> addAddOns(
    AddOnsEntity addOnsEntity,
  ) async {
    addOnsList.add(addOnsEntity);
    final newAddOnsList = List<AddOnsEntity>.from(addOnsList);
    emit(FilterOptionAddAddOns(newAddOnsList));
  }

  Future<void> removeAddOns(
    AddOnsEntity addOnsEntity,
  ) async {
    addOnsList.removeWhere(
      (element) => element.addonsId == addOnsEntity.addonsId,
    );
    final newAddOnsList = List<AddOnsEntity>.from(addOnsList);

    emit(FilterOptionAddAddOns(newAddOnsList));
  }

  Future<void> resetAddOnsList() async {
    addOnsList.clear();
    final newAddOnsList = List<AddOnsEntity>.from(addOnsList);
    emit(FilterOptionAddAddOns(newAddOnsList));
  }
}
