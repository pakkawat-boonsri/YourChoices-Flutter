import 'package:equatable/equatable.dart';
import 'package:your_choices/src/domain/entities/vendor/add_ons/add_ons_entity.dart';

class DishesEntity extends Equatable {
  final String? menuName;
  final String? menuImg;
  final num? menuPrice;
  final String? menuDescription;
  final List<AddOnsEntity>? addOns;

  const DishesEntity({
    this.menuName,
    this.menuImg,
    this.menuPrice,
    this.menuDescription,
    this.addOns,
  });

  @override
  List<Object?> get props => [
        menuName,
        menuImg,
        menuPrice,
        menuDescription,
        addOns,
      ];
}
