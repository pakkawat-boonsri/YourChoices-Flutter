import 'package:equatable/equatable.dart';

class VendorEntity extends Equatable {
  final String? uid;
  final String? resName;
  final String? resProfileUrl;
  final bool? isActive;
  final num? onQueue;
  final String? description;
  final num? totalPriceSell;
  final List? foods;

  const VendorEntity(
    this.uid,
    this.resName,
    this.resProfileUrl,
    this.isActive,
    this.onQueue,
    this.description,
    this.totalPriceSell,
    this.foods,
  );

  @override
  // TODO: implement props
  List<Object?> get props => [
        uid,
        resName,
        resProfileUrl,
        isActive,
        onQueue,
        description,
        totalPriceSell,
        foods,
      ];
}
