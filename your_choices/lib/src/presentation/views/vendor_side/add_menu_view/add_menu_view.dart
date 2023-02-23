import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/utilities/hex_color.dart';
import 'package:your_choices/utilities/text_style.dart';

import '../../../../domain/entities/vendor/vendor_entity.dart';
import '../../../blocs/vendor/vendor_cubit.dart';

class AddMenuView extends StatefulWidget {
  const AddMenuView({super.key, required this.uid});

  final String uid;

  @override
  State<AddMenuView> createState() => _AddMenuViewState();
}

class _AddMenuViewState extends State<AddMenuView> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<VendorCubit>(context).getSingleVendor(uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Container(
          width: size.width,
          height: size.height * 0.07,
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.amber[900],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "+ เพิ่มเมนูอาหาร",
              style: AppTextStyle.googleFont(
                Colors.white,
                26,
                FontWeight.w500,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: AppBar(
          leading: TouchableOpacity(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: "B44121".toColor(),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 30,
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            "เมนูอาหาร",
            style: AppTextStyle.googleFont(
              Colors.black,
              24,
              FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Padding(
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
            ),
            BlocBuilder<VendorCubit, VendorState>(
              builder: (context, vendorState) {
                if (vendorState is VendorLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orangeAccent,
                    ),
                  );
                } else if (vendorState is VendorLoaded) {
                  VendorEntity vendorEntity = vendorState.vendorEntity;
                  return vendorEntity.dishes!.isNotEmpty
                      ? Column(
                          children: [
                            Container(
                              width: size.width,
                              height: size.height / 3.5,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
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
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          itemCount: 4,
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
                              ),
                            );
                          },
                        );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
