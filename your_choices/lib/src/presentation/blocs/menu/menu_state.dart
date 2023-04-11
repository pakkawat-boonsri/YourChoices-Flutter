// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';

abstract class MenuState extends Equatable {
  const MenuState();
}

class MenuLoading extends MenuState {
  @override
  List<Object?> get props => [];
}

class MenuLoadCompleted extends MenuState {
  final List<DishesEntity> dishesList;
  const MenuLoadCompleted(
    this.dishesList,
  );

  @override
  List<Object?> get props => [dishesList];

  MenuLoadCompleted copyWith({
    List<DishesEntity>? dishesList,
  }) {
    return MenuLoadCompleted(
      dishesList ?? this.dishesList,
    );
  }
}

class MenuFailure extends MenuState {
  @override
  List<Object?> get props => [];
}
