// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_choices/src/domain/entities/vendor/add_ons/add_ons_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filter_option_in_menu/add_filter_option_in_menu_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filter_option_in_menu/delete_filter_option_in_menu_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filter_option_in_menu/get_filter_option_in_menu_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filter_option_in_menu/on_delete_addon_in_filter_option_in_menu_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filter_option_in_menu/update_filter_option_in_menu_usecase.dart';

part 'filter_option_in_menu_state.dart';

class FilterOptionInMenuCubit extends Cubit<List<FilterOptionEntity>> {
  final AddFilterOptionInMenuUseCase addFilterOptionInMenuUseCase;
  final GetFilterOptionInMenuUseCase getFilterOptionInMenuUseCase;
  final UpdateFilterOptionInMenuUseCase updateFilterOptionInMenuUseCase;
  final DeleteFilterOptionInMenuUseCase deleteFilterOptionInMenuUseCase;
  final OnDeleteAddonInFilterOptionInMenuUseCase onDeleteAddonInFilterOptionInMenuUseCase;
  FilterOptionInMenuCubit({
    required this.addFilterOptionInMenuUseCase,
    required this.getFilterOptionInMenuUseCase,
    required this.updateFilterOptionInMenuUseCase,
    required this.deleteFilterOptionInMenuUseCase,
    required this.onDeleteAddonInFilterOptionInMenuUseCase,
  }) : super([]);

  Future<void> addFilterOptionInMenu({
    required final DishesEntity dishesEntity ,
    required final List<FilterOptionEntity> filterOptions,
  }) async {
    List<FilterOptionEntity> filters = [...state];

    for (var filter in filterOptions) {
      if (filters.contains(filter)) {
        filters.remove(filter);
      } else {
        filters.add(filter);
      }
    }

    for (var filter in filters) {
      await addFilterOptionInMenuUseCase.call(dishesEntity,filter);
    }
  }

  Future<void> getFilterOptionInMenu(DishesEntity dishesEntity) async {
    try {
      final data = getFilterOptionInMenuUseCase.call(dishesEntity);

      data.listen((filterOptionList) {
        emit(filterOptionList);
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateFilterOptionInMenu(
    FilterOptionEntity filterOptionEntity,
  ) async {
    await updateFilterOptionInMenuUseCase.call(filterOptionEntity);
  }

  Future<void> deletingFilterOptionInMenu(
    FilterOptionEntity filterOptionEntity,
  ) async {
    await deleteFilterOptionInMenuUseCase.call(filterOptionEntity);
  }

  Future<void> onDeleteAddonInFilterOptionInMenu({
    required final DishesEntity dishesEntity,
    required final FilterOptionEntity filterOptionEntity,
    required final List<AddOnsEntity> addOnsEntity,
  }) async {
    // ignore: avoid_function_literals_in_foreach_calls
    addOnsEntity.forEach((element) async {
      await onDeleteAddonInFilterOptionInMenuUseCase.call(dishesEntity,filterOptionEntity,element);
    });
  }

  final List<FilterOptionEntity> deleteFilterOptionList = [];

  List<FilterOptionEntity> get getDeleteFilterOptionList => deleteFilterOptionList;

  Future<void> deleteFilterOptionInMenu(
    FilterOptionEntity filterOptionEntity,
  ) async {
    int index = state.indexOf(filterOptionEntity);
    deleteFilterOptionList.add(state.elementAt(index));
    state.removeAt(index);
    emit([...state]);
  }

  Future<void> resetDeleteFilterOptionInMenu() async {
    deleteFilterOptionList.clear();
  }
}
