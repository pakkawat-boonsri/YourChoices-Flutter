// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/favorite/get_favorite_restaurant_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/favorite/on_add_favorite_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/favorite/on_delete_favorite_usecase.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/favorite/favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final OnAddFavoriteUseCase onAddFavoriteUseCase;
  final OnDeleteFavoriteUseCase onDeleteFavoriteUseCase;
  final GetFavoriteRestaurantUseCase getFavoriteRestaurantUseCase;
  FavoriteCubit({
    required this.onAddFavoriteUseCase,
    required this.onDeleteFavoriteUseCase,
    required this.getFavoriteRestaurantUseCase,
  }) : super(const FavoriteState(vendorEntities: []));

  Future<void> onAddFavorite(VendorEntity vendorEntity) async {
    final currentState = state;
    final listOfFavorites = List<VendorEntity>.from(currentState.vendorEntities);
    listOfFavorites.add(vendorEntity);

    for (var vendor in listOfFavorites) {
      try {
        await onAddFavoriteUseCase.call(vendor);
      } catch (e) {
        log(e.toString());
      }
    }
  }

  Future<void> onGetFavorites() async {
    try {
      final data = getFavoriteRestaurantUseCase.call();
      data.listen((List<VendorEntity> vendors) {
        emit(state.copyWith(vendorEntities: vendors));
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> onRemoveFavorite(VendorEntity vendorEntity) async {
    try {
      await onDeleteFavoriteUseCase.call(vendorEntity);
    } catch (e) {
      log(e.toString());
    }
  }
}
