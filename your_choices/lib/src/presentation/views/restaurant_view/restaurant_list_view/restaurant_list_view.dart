import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_choices/src/presentation/blocs/customer/customer_cubit.dart';
import 'package:your_choices/utilities/text_style.dart';
import 'package:your_choices/src/restaurant_screen/view_model/bloc/restaurant_bloc.dart';
import 'package:your_choices/src/presentation/views/restaurant_view/restaurant_detail_view/restaurant_detail_view.dart';
import 'package:your_choices/utilities/hex_color.dart';

class RestaurantView extends StatefulWidget {
  final String uid;
  const RestaurantView({super.key, required this.uid});

  @override
  State<RestaurantView> createState() => _RestaurantViewState();
}

class _RestaurantViewState extends State<RestaurantView> {
  final searchText = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<RestaurantBloc>(context).add(
      OnFetchingDataEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _buildAppBarContent(size, context),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            _buildTextSelection(),
            Expanded(
              child: _buildListofRestaurant(context, size),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextSelection() {
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

  Widget _buildListofRestaurant(BuildContext context, Size size) {
    return BlocBuilder<RestaurantBloc, RestaurantState>(
      builder: (context, state) {
        if (state is RestaurantInitial) {
          return Column(
            children: const [
              CircularProgressIndicator(
                color: Colors.orangeAccent,
              ),
            ],
          );
        }
        if (state is OnFetchedRestaurantData) {
          final viewModel = state.model;
          return ListView.separated(
            primary: false,
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
            itemCount: viewModel.length,
            itemBuilder: (context, index) {
              log(viewModel.length.toString());
              return GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RestaurantDetailView(
                            model: viewModel[index], uid: widget.uid),
                      ),
                      (route) => false);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.35,
                            height: 120,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              child: Image.network(
                                "${viewModel[index].resImg}",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              height: 120,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      viewModel[index].resName ?? "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyle.googleFont(
                                        Colors.black,
                                        18,
                                        FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          child: Text(
                                            "${viewModel[index].description}",
                                            style: AppTextStyle.googleFont(
                                              Colors.grey,
                                              14,
                                              FontWeight.normal,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Icon(Icons.arrow_forward),
                                      )
                                    ],
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      text: "มี ",
                                      style: AppTextStyle.googleFont(
                                          Colors.black, 14, FontWeight.normal),
                                      children: [
                                        TextSpan(
                                          text: "${viewModel[index].onQueue}",
                                          style: AppTextStyle.googleFont(
                                              "FF602E".toColor(),
                                              16,
                                              FontWeight.normal),
                                        ),
                                        TextSpan(
                                          text: " คิว ณ ขณะนี้",
                                          style: AppTextStyle.googleFont(
                                              Colors.black,
                                              14,
                                              FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Text("NO DATA");
        }
      },
    );
  }
}

AppBar _buildAppBarContent(Size size, BuildContext context) {
  return AppBar(
    toolbarHeight: size.height * 0.2,
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
                  child: BlocBuilder<CustomerCubit, CustomerState>(
                    builder: (context, state) {
                      if (state is CustomerLoaded) {
                        return Image.network(
                          fit: BoxFit.cover,
                          state.customerEntity.profileUrl!,
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
                  BlocBuilder<CustomerCubit, CustomerState>(
                    builder: (context, state) {
                      if (state is CustomerLoaded) {
                        return Text(
                          "${state.customerEntity.username}",
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
