import 'package:flutter/material.dart';
import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';
import 'package:your_choices/src/presentation/widgets/custom_vendor_appbar.dart';

class MenuDetailView extends StatefulWidget {
  final DishesEntity dishesEntity;
  const MenuDetailView({super.key, required this.dishesEntity});

  @override
  State<MenuDetailView> createState() => _MenuDetailViewState();
}

class _MenuDetailViewState extends State<MenuDetailView> {
  late DishesEntity dishesEntity;

  @override
  void initState() {
    dishesEntity = widget.dishesEntity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "รายละเอียดเมนู",
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: Center(
        child: Text(dishesEntity.menuName ?? ""),
      ),
    );
  }
}
