// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/menu/create_menu_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/menu/delete_menu_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/menu/get_menu_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/menu/update_menu_usecase.dart';

import 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final CreateMenuUseCase createMenuUseCase;
  final GetMenuUseCase getMenuUseCase;
  final UpdateMenuUseCase updateMenuUseCase;
  final DeleteMenuUseCase deleteMenuUseCase;

  MenuCubit({
    required this.createMenuUseCase,
    required this.getMenuUseCase,
    required this.updateMenuUseCase,
    required this.deleteMenuUseCase,
  }) : super(MenuLoading());

  Future<void> createMenu(DishesEntity dishesEntity) async {
    try {
      await createMenuUseCase.call(dishesEntity);
    } on SocketException catch (_) {
      emit(MenuFailure());
    } catch (e) {
      emit(MenuFailure());
    }
  }

  Future<void> getMenu({required String uid}) async {
    try {
      final data = getMenuUseCase.call(uid);

      data.listen((dishesEntityList) {
        dishesEntityList.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
        emit(MenuLoadCompleted(dishesEntityList));
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
}
