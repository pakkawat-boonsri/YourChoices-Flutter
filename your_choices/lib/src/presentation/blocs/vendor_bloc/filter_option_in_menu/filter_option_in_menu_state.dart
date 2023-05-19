// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'filter_option_in_menu_cubit.dart';

abstract class FilterOptionInMenuState extends Equatable {
  final List<FilterOptionEntity> filterOptionList;
  const FilterOptionInMenuState(
    this.filterOptionList,
  );


}

class FilterOptionInMenuLoading extends FilterOptionInMenuState {
  FilterOptionInMenuLoading() : super([]);
  @override
  List<Object?> get props => [];

}
