import 'package:equatable/equatable.dart';

class AddOnsEntity extends Equatable {
  final String? addonsType;
  final num? price;

  const AddOnsEntity({
    this.addonsType,
    this.price,
  });
  @override
  List<Object?> get props => [
        addonsType,
        price,
      ];
}
