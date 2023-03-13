import 'package:equatable/equatable.dart';

class AddOnsEntity extends Equatable {
  final String? addonsId;
  final String? addonsType;
  final num? price;

  const AddOnsEntity({
    this.addonsId,
    this.addonsType,
    this.price,
  });
  @override
  List<Object?> get props => [
        addonsId,
        addonsType,
        price,
      ];
}
