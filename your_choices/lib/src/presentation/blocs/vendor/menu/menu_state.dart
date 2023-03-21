// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'menu_cubit.dart';

abstract class MenuState extends Equatable {
  const MenuState();
}

class MenuInitial extends MenuState {
  @override
  List<Object?> get props => [];
}

class MenuLoading extends MenuState {
  @override
  List<Object?> get props => [];
}

class MenuLoadCompleted extends MenuState {
  final List<DishesEntity> dishesEntity;

  const MenuLoadCompleted({
    required this.dishesEntity,
  });

  @override
  List<Object?> get props => [dishesEntity];
}

class MenuFailure extends MenuState {
  @override
  List<Object?> get props => [];
}

class MenuAddFilterOption extends MenuState {
  final List<FilterOptionEntity> filterOptionEntity;

  const MenuAddFilterOption(
    this.filterOptionEntity,
  );

  @override
  List<Object?> get props => [filterOptionEntity];
}
