// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class AddOnsEntity extends Equatable {
  final String? addonsId;
  final String? addonsName;
  final String? priceType;
  final num? price;

  final bool isSelected; //using for checkboxlisttile

  const AddOnsEntity({
    this.addonsId,
    this.addonsName,
    this.priceType,
    this.price,
    this.isSelected = false,
  });
  @override
  List<Object?> get props => [
        addonsId,
        addonsName,
        priceType,
        price,
        isSelected,
      ];

  AddOnsEntity copyWith({
    String? addonsId,
    String? addonsName,
    String? priceType,
    num? price,
    bool? isSelected,
  }) {
    return AddOnsEntity(
      addonsId: addonsId ?? this.addonsId,
      addonsName: addonsName ?? this.addonsName,
      priceType: priceType ?? this.priceType,
      price: price ?? this.price,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
