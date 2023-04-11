// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';

import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filter_option_in_menu/add_filter_option_in_menu_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filter_option_in_menu/delete_filter_option_in_menu_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filter_option_in_menu/get_filter_option_in_menu_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filter_option_in_menu/update_filter_option_in_menu_usecase.dart';

part 'filter_option_in_menu_state.dart';

class FilterOptionInMenuCubit extends Cubit<FilterOptionInMenuState> {
  final AddFilterOptionInMenuUseCase addFilterOptionInMenuUseCase;
  final GetFilterOptionInMenuUseCase getFilterOptionInMenuUseCase;
  final UpdateFilterOptionInMenuUseCase updateFilterOptionInMenuUseCase;
  final DeleteFilterOptionInMenuUseCase deleteFilterOptionInMenuUseCase;
  FilterOptionInMenuCubit({
    required this.addFilterOptionInMenuUseCase,
    required this.getFilterOptionInMenuUseCase,
    required this.updateFilterOptionInMenuUseCase,
    required this.deleteFilterOptionInMenuUseCase,
  }) : super(FilterOptionInMenuInitial());

  Future<void> addFilterOptionInMenu(
    List<FilterOptionEntity> filterOptionEntityList,
  ) async {
    for (FilterOptionEntity filterOptionEntity in filterOptionEntityList) {
      await addFilterOptionInMenuUseCase.call(filterOptionEntity);
    }
  }

  Future<void> getFilterOptionInMenu(DishesEntity dishesEntity) async {
    try {
      final data = getFilterOptionInMenuUseCase.call(dishesEntity);

      data.listen((filterOptionList) {
        emit(FilterOptionInMenuLoaded(filterOptionList));
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

  Future<void> deleteFilterOptionInMenu(
    FilterOptionEntity filterOptionEntity,
  ) async {
    await deleteFilterOptionInMenuUseCase.call(filterOptionEntity);
  }
}
