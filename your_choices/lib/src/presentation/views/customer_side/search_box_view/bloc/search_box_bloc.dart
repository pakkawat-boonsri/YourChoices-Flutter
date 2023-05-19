import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_box_event.dart';
part 'search_box_state.dart';

class SearchBoxBloc extends Bloc<SearchBoxEvent, SearchBoxState> {
  SearchBoxBloc() : super(const SearchBoxState("")) {
    on<OnTypingTextField>((event, emit) {
      log(event.searchText);
      emit(state.copyWith(searchText: event.searchText));
    });
  }
}
