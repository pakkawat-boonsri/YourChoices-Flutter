import 'package:bloc/bloc.dart';

import 'add_ons_state.dart';

class AddOnsCubit extends Cubit<AddOnsState> {
  AddOnsCubit() : super(const AddOnsInitial());
}
