import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_choices/constants/text_style.dart';
import 'package:your_choices/src/customer_screen/bloc/customer_bloc/customer_bloc.dart';
import 'package:your_choices/utilities/hex_color.dart';

class RestaurantView extends StatefulWidget {
  const RestaurantView({super.key});

  @override
  State<RestaurantView> createState() => _RestaurantViewState();
}

class _RestaurantViewState extends State<RestaurantView> {
  final searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      // appBar: _buildAppBarContent(size, context),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppbar(size, searchText),
          SliverToBoxAdapter(
            child: _buildTextSelection(),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            childCount: 6,
            (context, index) {
              return Container(
                margin: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: size.width,
                height: size.height * 0.15,
              );
            },
          ))
        ],
      ),
    );
  }

  Widget _buildSliverAppbar(Size size, TextEditingController searchText) {
    return SliverAppBar(
      pinned: true,
      toolbarHeight: size.height * 0.2,
      // expandedHeight: size.height * 0.2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      backgroundColor: Colors.white,
      flexibleSpace: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(100),
                    ),
                    child: BlocBuilder<CustomerBloc, CustomerState>(
                      builder: (context, state) {
                        if (state is CustomerLoadedState) {
                          return Image.file(
                            fit: BoxFit.cover,
                            File(state.model.imgAvatar!),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "เลือกร้านที่ชอบได้เลย",
                      style: AppTextStyle.googleFont(
                        Colors.grey,
                        13,
                        FontWeight.bold,
                      ),
                    ),
                    BlocBuilder<CustomerBloc, CustomerState>(
                      builder: (context, state) {
                        if (state is CustomerLoadedState) {
                          return Text(
                            "${state.model.username}",
                            style: AppTextStyle.googleFont(
                              Colors.black,
                              14,
                              FontWeight.bold,
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: searchText,
              style: AppTextStyle.googleFont(Colors.black, 16, FontWeight.w400),
              decoration: InputDecoration(
                filled: true,
                fillColor: "D9D9D9".toColor(),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 20, right: 8),
                  child: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                prefixIconColor: Colors.black,
                hintText: "ค้นหาร้านที่ต้องการ",
                hintStyle: AppTextStyle.googleFont(
                    "685A5A".toColor(), 14, FontWeight.w600),
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildTextSelection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "List of Restaurants",
              style: AppTextStyle.googleFont(Colors.white, 24, FontWeight.bold),
            ),
            Text(
              "See all",
              style: AppTextStyle.googleFont(Colors.white, 16, FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildListofRestaurant(Size size) {
  //   return SizedBox(
  //     width: size.width,
  //     height: size.height,
  //     child: ListView.separated(
  //       physics: const NeverScrollableScrollPhysics(),
  //       separatorBuilder: (context, index) => const SizedBox(
  //         height: 10,
  //       ),
  //       itemCount: 6,
  //       itemBuilder: (context, index) {
  //         return Container(
  //           margin: const EdgeInsets.symmetric(horizontal: 15),
  //           decoration: BoxDecoration(
  //               color: Colors.white, borderRadius: BorderRadius.circular(10)),
  //           width: size.width,
  //           height: size.height * 0.15,
  //         );
  //       },
  //     ),
  //   );
  // }
}

// AppBar _buildAppBarContent(Size size, BuildContext context) {
//   return AppBar(
//     toolbarHeight: size.height * 0.2,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(
//         bottom: Radius.circular(30),
//       ),
//     ),
//     backgroundColor: Colors.white,
//     flexibleSpace: Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Row(
//             children: [
//               SizedBox(
//                 width: 50,
//                 height: 50,
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.all(
//                     Radius.circular(100),
//                   ),
//                   child: BlocBuilder<CustomerBloc, CustomerState>(
//                     builder: (context, state) {
//                       if (state is CustomerLoadedState) {
//                         return Image.file(
//                           fit: BoxFit.cover,
//                           File(state.model.imgAvatar!),
//                         );
//                       } else {
//                         return Container();
//                       }
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 width: 20,
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "เลือกร้านที่ชอบได้เลย",
//                     style: AppTextStyle.googleFont(
//                       Colors.grey,
//                       13,
//                       FontWeight.bold,
//                     ),
//                   ),
//                   BlocBuilder<CustomerBloc, CustomerState>(
//                     builder: (context, state) {
//                       if (state is CustomerLoadedState) {
//                         return Text(
//                           "${state.model.username}",
//                           style: AppTextStyle.googleFont(
//                             Colors.black,
//                             14,
//                             FontWeight.bold,
//                           ),
//                         );
//                       } else {
//                         return Container();
//                       }
//                     },
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//         Container(
//           margin: const EdgeInsets.only(left: 20, right: 20),
//           child: TextField(
//             style: AppTextStyle.googleFont(Colors.black, 16, FontWeight.w400),
//             decoration: InputDecoration(
//               filled: true,
//               fillColor: "D9D9D9".toColor(),
//               prefixIcon: const Padding(
//                 padding: EdgeInsets.only(left: 20, right: 8),
//                 child: Icon(
//                   Icons.search,
//                   color: Colors.black,
//                   size: 30,
//                 ),
//               ),
//               prefixIconColor: Colors.black,
//               hintText: "ค้นหาร้านที่ต้องการ",
//               hintStyle: AppTextStyle.googleFont(
//                   "685A5A".toColor(), 14, FontWeight.w600),
//               contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
//               border: OutlineInputBorder(
//                 borderSide: BorderSide.none,
//                 borderRadius: BorderRadius.circular(50),
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
