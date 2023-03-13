import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/on_generate_routes.dart';
import 'package:your_choices/src/presentation/widgets/custom_vendor_appbar.dart';
import 'package:your_choices/utilities/text_style.dart';

import '../../../../domain/entities/vendor/vendor_entity.dart';
import '../../../blocs/vendor/vendor_cubit.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key, required this.uid});

  final String uid;

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<VendorCubit>(context).getSingleVendor(uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar(
        title: "เมนูอาหาร",
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderTitle(size),
            _buildBlocBody(size),
          ],
        ),
      ),
    );
  }

  BlocBuilder<VendorCubit, VendorState> _buildBlocBody(Size size) {
    return BlocBuilder<VendorCubit, VendorState>(
      builder: (context, vendorState) {
        if (vendorState is VendorLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orangeAccent,
            ),
          );
        } else if (vendorState is VendorLoaded) {
          VendorEntity vendorEntity = vendorState.vendorEntity;
          return vendorEntity.dishes!.isEmpty
              ? Column(
                  children: [
                    Container(
                      width: size.width,
                      height: size.height / 3.5,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: const Image(
                        image: AssetImage(
                          "assets/images/no_menu_item.png",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "คุณยังไม่มีรายการอาหารเลย",
                      style: AppTextStyle.googleFont(
                        Colors.white,
                        26,
                        FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TouchableOpacity(
                      activeOpacity: 0.5,
                      onTap: () => Navigator.pushNamed(
                        context,
                        PageConst.addMenuPage,
                        arguments: widget.uid,
                      ),
                      child: Container(
                        width: size.width,
                        height: size.height * 0.06,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 40,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amber[900],
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "+ เพิ่มเมนูอาหาร",
                            style: AppTextStyle.googleFont(
                              Colors.white,
                              22,
                              FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: vendorEntity.dishes!.length,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 150,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return TouchableOpacity(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: const [],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TouchableOpacity(
                      activeOpacity: 0.5,
                      onTap: () => log("tapping add menu"),
                      child: Container(
                        width: size.width,
                        height: size.height * 0.06,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 40,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amber[900],
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "+ เพิ่มเมนูอาหาร",
                            style: AppTextStyle.googleFont(
                              Colors.white,
                              22,
                              FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        } else {
          return Container();
        }
      },
    );
  }

  Padding _buildHeaderTitle(Size size) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        width: size.width,
        child: Text(
          "รายการเมนู",
          style: AppTextStyle.googleFont(
            Colors.white,
            26,
            FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
