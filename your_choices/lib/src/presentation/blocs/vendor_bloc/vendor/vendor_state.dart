part of 'vendor_cubit.dart';

abstract class VendorState extends Equatable {
  const VendorState();
}

class VendorInitial extends VendorState {
  @override
  List<Object?> get props => [];
}

class VendorLoading extends VendorState {
  @override
  List<Object?> get props => [];
}

class VendorLoaded extends VendorState {
  final VendorEntity vendorEntity;

  const VendorLoaded({
    required this.vendorEntity,
  });
  @override
  List<Object?> get props => [vendorEntity];
}

class VendorFailure extends VendorState {
  @override
  List<Object> get props => [];
}
