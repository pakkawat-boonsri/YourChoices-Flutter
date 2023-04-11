// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'filter_option_in_menu_cubit.dart';

abstract class FilterOptionInMenuState extends Equatable {
  const FilterOptionInMenuState();
}

class FilterOptionInMenuInitial extends FilterOptionInMenuState {
  @override
  List<Object> get props => [];
}

class FilterOptionInMenuLoading extends FilterOptionInMenuState {
  @override
  List<Object> get props => [];
}

class FilterOptionInMenuLoaded extends FilterOptionInMenuState {
  final List<FilterOptionEntity> filterOptionList;

  const FilterOptionInMenuLoaded(
    this.filterOptionList,
  );

  @override
  List<Object> get props => [filterOptionList];

  FilterOptionInMenuLoaded copyWith({
    List<FilterOptionEntity>? filterOptionList,
  }) {
    return FilterOptionInMenuLoaded(
      filterOptionList ?? this.filterOptionList,
    );
  }
}
