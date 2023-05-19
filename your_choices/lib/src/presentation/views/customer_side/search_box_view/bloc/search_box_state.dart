part of 'search_box_bloc.dart';

class SearchBoxState extends Equatable {
  final String searchText;
  const SearchBoxState(
    this.searchText,
  );

  @override
  List<Object> get props => [searchText];

  SearchBoxState copyWith({
    String? searchText,
  }) {
    return SearchBoxState(
      searchText ?? this.searchText,
    );
  }
}
