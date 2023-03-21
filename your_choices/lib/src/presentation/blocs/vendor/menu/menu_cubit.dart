import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/menu/create_menu_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/menu/delete_menu_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/menu/get_menu_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/menu/update_menu_usecase.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final CreateMenuUseCase createMenuUseCase;
  final GetMenuUseCase getMenuUseCase;
  final UpdateMenuUseCase updateMenuUseCase;
  final DeleteMenuUseCase deleteMenuUseCase;
  MenuCubit({
    required this.deleteMenuUseCase,
    required this.updateMenuUseCase,
    required this.createMenuUseCase,
    required this.getMenuUseCase,
  }) : super(MenuInitial());

  Future<void> createMenu(DishesEntity dishesEntity) async {
    emit(MenuLoading());
    try {
      await createMenuUseCase.call(dishesEntity);
    } on SocketException catch (_) {
      emit(MenuFailure());
    } catch (e) {
      emit(MenuFailure());
    }
  }

  Future<void> getMenu({required String uid}) async {
    emit(MenuLoading());
    try {
      final data = getMenuUseCase.call(uid);

      data.listen((dishesEntityList) {
        emit(MenuLoadCompleted(
          dishesEntity: dishesEntityList,
        ));
      });
    } on SocketException catch (_) {
      emit(MenuFailure());
    } catch (e) {
      emit(MenuFailure());
    }
  }

  Future<void> updateMenu(DishesEntity dishesEntity) async {
    try {
      await updateMenuUseCase.call(dishesEntity);
    } on SocketException catch (_) {
      emit(MenuFailure());
    } catch (e) {
      emit(MenuFailure());
    }
  }

  Future<void> deleteMenu(DishesEntity dishesEntity) async {
    try {
      await deleteMenuUseCase.call(dishesEntity);
    } on SocketException catch (_) {
      emit(MenuFailure());
    } catch (e) {
      emit(MenuFailure());
    }
  }

  final List<FilterOptionEntity> filterOptionList = [];

  List<FilterOptionEntity> get getfilterOptionList => filterOptionList;

  Future<void> addFilterOption(
    FilterOptionEntity filterOptionEntity,
  ) async {
    filterOptionList.add(filterOptionEntity);
    emit(MenuAddFilterOption(filterOptionList));
  }

  Future<void> removeFilterOption(
    FilterOptionEntity filterOptionEntity,
  ) async {
    filterOptionList.removeWhere(
      (element) => element.filterId == filterOptionEntity.filterId,
    );
    emit(MenuAddFilterOption(filterOptionList));
  }

  Future<void> resetFilterOptionList() async {
    filterOptionList.clear();
  }
}
