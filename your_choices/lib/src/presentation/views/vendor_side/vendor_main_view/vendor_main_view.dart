import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/on_generate_routes.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/presentation/blocs/vendor/vendor_cubit.dart';
import 'package:your_choices/utilities/hex_color.dart';
import 'package:your_choices/utilities/text_style.dart';

class VendorMainView extends StatefulWidget {
  final String uid;
  const VendorMainView({super.key, required this.uid});

  @override
  State<VendorMainView> createState() => _VendorMainViewState();
}

class _VendorMainViewState extends State<VendorMainView> {
  List<AssetImage> images = [
    const AssetImage("assets/images/menu.png"),
    const AssetImage("assets/images/restaurant.png"),
    const AssetImage("assets/images/record.png"),
    const AssetImage("assets/images/record_report.png"),
  ];

  List<String> imageTitles = [
    "เมนูอาหาร",
    "ข้อมูลร้าน",
    "ประวัติการสั่งซื้อ",
    "รายการ",
  ];

  @override
  void initState() {
    BlocProvider.of<VendorCubit>(context).getSingleVendor(uid: widget.uid);
    super.initState();
  }

  String? logout;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: PopupMenuButton(
            child: const Icon(Icons.menu),
            itemBuilder: (context) => [
              PopupMenuItem(
                textStyle: AppTextStyle.googleFont(
                  Colors.black,
                  14,
                  FontWeight.w400,
                ),
                onTap: () => log("tapping on "),
                child: const Text(
                  "Logout",
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            _buildBlocHeaderSection(size),
            const SizedBox(
              height: 15,
            ),
            _buildOrderContainer(size),
            const SizedBox(
              height: 20,
            ),
            _buildFeatureText(size),
            const SizedBox(
              height: 10,
            ),
            _buildGridViewBuilder()
          ],
        ),
      ),
    );
  }

  _onSelectedRouter(int index) {
    switch (index) {
      case 0:
        {
          return Navigator.pushNamed(
            context,
            PageConst.addMenuPage,
            arguments: widget.uid,
          );
        }
      default:
    }
  }

  GridView _buildGridViewBuilder() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 4,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 150,
      ),
      itemBuilder: (BuildContext context, int index) {
        return TouchableOpacity(
          onTap: () => 
                 _onSelectedRouter(index),
              
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                index != 2
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          width: 80,
                          height: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: "D9D9D9".toColor(),
                            image: DecorationImage(
                              alignment: Alignment.center,
                              image: images[index],
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          width: 80,
                          height: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: "D9D9D9".toColor(),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                width: 80,
                                height: 80,
                                left: 4,
                                child: Image.asset(
                                  "assets/images/record.png",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                const Spacer(),
                Text(
                  imageTitles[index],
                  style: AppTextStyle.googleFont(
                    Colors.black,
                    16,
                    FontWeight.w500,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }

  Container _buildFeatureText(Size size) {
    return Container(
      width: size.width,
      margin: const EdgeInsets.symmetric(horizontal: 33),
      child: Text(
        "ฟีเจอร์ต่างๆ",
        style: AppTextStyle.googleFont(
          Colors.white,
          26,
          FontWeight.w600,
        ),
      ),
    );
  }

  BlocBuilder<VendorCubit, VendorState> _buildOrderContainer(Size size) {
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
          return TouchableOpacity(
            onTap: () => log("Today order"),
            child: Container(
              width: size.width,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: vendorEntity.isActive! ? Colors.green : Colors.red,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    const Icon(
                      CupertinoIcons.cart,
                      color: Colors.white,
                      size: 26,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      "ออเดอร์สำหรับวันนี้",
                      style: AppTextStyle.googleFont(
                        Colors.white,
                        18,
                        FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            left: 4.5,
                            child: Icon(
                              CupertinoIcons.forward,
                              size: 23,
                              color: vendorEntity.isActive!
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  BlocBuilder<VendorCubit, VendorState> _buildBlocHeaderSection(Size size) {
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
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: size.width,
                height: size.height / 3.7,
                child: Stack(
                  children: [
                    blurImageBg(size, vendorEntity),
                    headerTitle(size, vendorEntity),
                  ],
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }

  Positioned headerTitle(Size size, VendorEntity vendorEntity) {
    return Positioned(
      width: size.width,
      height: size.height / 4.2,
      top: 50,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            width: size.width,
            child: Text(
              "${vendorEntity.resName}",
              style: AppTextStyle.googleFont(
                Colors.white,
                24,
                FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${vendorEntity.username}",
                  style: AppTextStyle.googleFont(
                    Colors.white,
                    18,
                    FontWeight.w500,
                  ),
                ),
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          vendorEntity.profileUrl!,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 13,
          ),
          Container(
            width: size.width,
            height: 49,
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.storefront_outlined,
                    size: 26,
                    color: vendorEntity.isActive! ? Colors.black : Colors.grey,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  vendorEntity.isActive!
                      ? Text(
                          "เปิดรับออเดอร์",
                          style: AppTextStyle.googleFont(
                            Colors.green,
                            17,
                            FontWeight.w500,
                          ),
                        )
                      : Text(
                          "ปิดรับออเดอร์",
                          style: AppTextStyle.googleFont(
                            Colors.red,
                            17,
                            FontWeight.w500,
                          ),
                        ),
                  const Spacer(),
                  const VerticalDivider(
                    endIndent: 7,
                    indent: 7,
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  TouchableOpacity(
                    onTap: () => log("asdasd"),
                    child: Text(
                      "เปลี่ยน",
                      style: AppTextStyle.googleFont(
                        Colors.grey,
                        17,
                        FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container blurImageBg(Size size, VendorEntity vendorEntity) {
    return Container(
      width: size.width,
      height: 180,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            vendorEntity.resProfileUrl!,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 4,
            sigmaY: 4,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.0),
            ),
          ),
        ),
      ),
    );
  }
}
// Positioned headerContent(Size size, VendorEntity vendorEntity) {
//     return Positioned(
//       width: size.width,
//       height: size.height / 4.2,
//       top: 50,
//       child: Column(
//         children: [
//           Container(
//             margin: const EdgeInsets.symmetric(
//               horizontal: 20,
//             ),
//             width: size.width,
//             child: Text(
//               "${vendorEntity.resName}",
//               style: AppTextStyle.googleFont(
//                 Colors.white,
//                 24,
//                 FontWeight.bold,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 20,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "${vendorEntity.username}",
//                   style: AppTextStyle.googleFont(
//                     Colors.white,
//                     18,
//                     FontWeight.w500,
//                   ),
//                 ),
//                 CircleAvatar(
//                   radius: 28,
//                   backgroundColor: Colors.transparent,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       image: DecorationImage(
//                         image: NetworkImage(
//                           vendorEntity.profileUrl!,
//                         ),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 13,
//           ),
//           Container(
//             width: size.width,
//             height: 40,
//             margin: const EdgeInsets.symmetric(
//               horizontal: 20,
//             ),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(5),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.storefront_outlined,
//                     color: vendorEntity.isActive! ? Colors.black : Colors.grey,
//                   ),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   vendorEntity.isActive!
//                       ? Text(
//                           "เปิดรับออเดอร์",
//                           style: AppTextStyle.googleFont(
//                             Colors.green,
//                             15,
//                             FontWeight.w500,
//                           ),
//                         )
//                       : Text(
//                           "ปิดรับออเดอร์",
//                           style: AppTextStyle.googleFont(
//                             Colors.red,
//                             15,
//                             FontWeight.w500,
//                           ),
//                         ),
//                   const Spacer(),
//                   const VerticalDivider(
//                     endIndent: 7,
//                     indent: 7,
//                     color: Colors.grey,
//                     thickness: 1,
//                   ),
//                   const SizedBox(
//                     width: 3,
//                   ),
//                   TouchableOpacity(
//                     onTap: () => log("asdasd"),
//                     child: Text(
//                       "เปลี่ยน",
//                       style: AppTextStyle.googleFont(
//                         Colors.grey,
//                         15,
//                         FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Container blurImageBackground(Size size, VendorEntity vendorEntity) {
//     return Container(
//       width: size.width,
//       height: 180,
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: NetworkImage(
//             vendorEntity.resProfileUrl!,
//           ),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: ClipRRect(
//         child: BackdropFilter(
//           filter: ImageFilter.blur(
//             sigmaX: 4,
//             sigmaY: 4,
//           ),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.0),
//             ),
//           ),
//         ),
//       ),
//     );
//   }