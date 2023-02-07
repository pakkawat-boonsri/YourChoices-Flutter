import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'vendor_state.dart';

class VendorCubit extends Cubit<VendorState> {
  VendorCubit() : super(VendorInitial());
}
