// ignore_for_file: public_member_api_docs, sort_constructors_first
class RestaurantModel {
  String? resName;
  String? description;
  String? resImg;
  int? onQueue;
  int? totalPriceSell;
  bool? isAction;
  bool? isFavorite;
  List<Foods>? foods;

  RestaurantModel(
      {this.resName,
      this.description,
      this.resImg,
      this.onQueue,
      this.totalPriceSell,
      this.isAction,
      this.isFavorite,
      this.foods});

  RestaurantModel.fromJson(Map<String, dynamic> json) {
    resName = json['resName'];
    description = json['description'];
    resImg = json['resImg'];
    onQueue = json['onQueue'];
    totalPriceSell = json['totalPriceSell'];
    isAction = json['isAction'];
    isFavorite = json['isFavorite'];
    if (json['Foods'] != null) {
      foods = <Foods>[];
      json['Foods'].forEach((v) {
        foods!.add(Foods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['resName'] = resName;
    data['description'] = description;
    data['resImg'] = resImg;
    data['onQueue'] = onQueue;
    data['totalPriceSell'] = totalPriceSell;
    data['isAction'] = isAction;
    data['isFavorite'] = isFavorite;
    if (foods != null) {
      data['Foods'] = foods!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Foods {
  String? menuName;
  String? menuImg;
  int? menuPrice;
  String? menuDescription;
  List<AddOns>? addOns;

  Foods(
      {this.menuName,
      this.menuImg,
      this.menuPrice,
      this.addOns,
      this.menuDescription});

  Foods.fromJson(Map<String, dynamic> json) {
    menuName = json['menuName'];
    menuImg = json['menuImg'];
    menuPrice = json['menuPrice'];
    menuDescription = json['menuDescription'];
    if (json['add_ons'] != null) {
      addOns = <AddOns>[];
      json['add_ons'].forEach((v) {
        addOns!.add(AddOns.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['menuName'] = menuName;
    data['menuImg'] = menuImg;
    data['menuPrice'] = menuPrice;
    data['menuDescription'] = menuDescription;
    if (addOns != null) {
      data['add_ons'] = addOns!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddOns {
  String? addonsType;
  bool isChecked = false;
  int? price;

  AddOns({this.addonsType, this.price, required this.isChecked}) {
    isChecked = isChecked;
  }

  AddOns.fromJson(Map<String, dynamic> json) {
    addonsType = json['addonsType'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['addonsType'] = addonsType;
    data['price'] = price;
    return data;
  }

  AddOns copyWith({
    String? addonsType,
    bool? isChecked,
    int? price,
  }) {
    return AddOns(
      addonsType: addonsType ?? this.addonsType,
      isChecked: isChecked ?? this.isChecked,
      price: price ?? this.price,
    );
  }
}
