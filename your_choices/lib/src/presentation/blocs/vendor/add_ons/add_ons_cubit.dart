import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_ons_state.dart';

class AddOnsCubit extends Cubit<AddOnsState> {
  AddOnsCubit() : super(AddOnsInitial());
}
