import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';

class AddFilterInMenuCubit extends Cubit<AddFilterInMenuState> {
  AddFilterInMenuCubit() : super(const AddFilterInMenuInitial([]));

  addFiltersInMenu({required FilterOptionEntity filterOptionEntity}) async {
    final List<FilterOptionEntity> filters = [...state.filterOptions];
    filters.add(filterOptionEntity);
    emit(AddFilterInMenuLoaded(filters));
  }

  removeFiltersInMenu({required FilterOptionEntity filterOptionEntity}) async {
    final List<FilterOptionEntity> filters = [...state.filterOptions];
    filters.removeWhere(
      (element) => element.filterId == filterOptionEntity.filterId,
    );
    emit(AddFilterInMenuLoaded(filters));
  }

  resetFiltersInMenu() async {
    final List<FilterOptionEntity> filters = [...state.filterOptions];
    filters.clear();
    emit(AddFilterInMenuLoaded(filters));
  }
}

abstract class AddFilterInMenuState extends Equatable {
  final List<FilterOptionEntity> filterOptions;

  const AddFilterInMenuState(this.filterOptions);
}

class AddFilterInMenuInitial extends AddFilterInMenuState {
  const AddFilterInMenuInitial(List<FilterOptionEntity> filterOptions)
      : super(filterOptions);

  @override
  List<Object?> get props => [];
}

class AddFilterInMenuLoaded extends AddFilterInMenuState {
  const AddFilterInMenuLoaded(List<FilterOptionEntity> filterOptions)
      : super(filterOptions);

  @override
  List<Object?> get props => [filterOptions];
}
