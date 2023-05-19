// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_box_bloc.dart';

abstract class SearchBoxEvent extends Equatable {
  const SearchBoxEvent();
}

class OnTypingTextField extends SearchBoxEvent {
  final String searchText; 
  const OnTypingTextField({
    required this.searchText,
  });
	
  @override
  List<Object?> get props => [searchText];
}
