import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';

class VendorModel extends VendorEntity {
  const VendorModel({
    final String? uid,
    final String? email,
    final String? username,
    final String? profileUrl,
    final String? type,
    final String? resName,
    final String? resProfileUrl,
    final bool? isActive,
    final num? onQueue,
    final String? description,
    final num? totalPriceSell,
    final String? restaurantType,
    final Timestamp? accountCreatedWhen,
    final List<DishesEntity>? dishes,
  }) : super(
          uid: uid,
          resName: resName,
          resProfileUrl: resProfileUrl,
          isActive: isActive,
          onQueue: onQueue,
          description: description,
          totalPriceSell: totalPriceSell,
          dishes: dishes,
          email: email,
          username: username,
          profileUrl: profileUrl,
          type: type,
          restaurantType: restaurantType,
          accountCreatedWhen: accountCreatedWhen,
        );

  factory VendorModel.fromJson(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return VendorModel(
      username: snapshot['username'],
      description: snapshot['description'],
      dishes: snapshot['dishes'] != null
          ? List<DishesEntity>.from(
              (snapshot['dishes'] as List<dynamic>).map<DishesEntity?>(
                (x) => DishesEntity.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      isActive: snapshot['isActive'],
      onQueue: snapshot['onQueue'],
      resName: snapshot['resName'],
      resProfileUrl: snapshot['resProfileUrl'],
      totalPriceSell: snapshot['totalPriceSell'],
      profileUrl: snapshot['profileUrl'],
      email: snapshot['email'],
      uid: snapshot['uid'],
      type: snapshot['type'],
      restaurantType: snapshot['restaurantType'],
      accountCreatedWhen: snapshot['accountCreatedWhen'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['profileUrl'] = profileUrl;
    data['email'] = email;
    data['uid'] = uid;
    data['description'] = description;
    data['isActive'] = isActive;
    data['onQueue'] = onQueue;
    data['resName'] = resName;
    data['resProfileUrl'] = resProfileUrl;
    data['totalPriceSell'] = totalPriceSell;
    data['type'] = type;
    data['restaurantType'] = restaurantType;
    data['accountCreatedWhen'] = accountCreatedWhen;
    return data;
  }
}
