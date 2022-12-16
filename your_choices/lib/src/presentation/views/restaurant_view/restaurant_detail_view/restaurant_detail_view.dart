// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:your_choices/src/presentation/views/main_view/main_view.dart';
import 'package:your_choices/src/presentation/views/restaurant_view/food_detail_view/food_detail_view.dart';
import 'package:your_choices/src/restaurant_screen/model/restaurant_model.dart';
import 'package:your_choices/utilities/hex_color.dart';
import 'package:your_choices/utilities/text_style.dart';

class RestaurantDetailView extends StatefulWidget {
  final RestaurantModel model;
  const RestaurantDetailView({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  State<RestaurantDetailView> createState() => _RestaurantDetailViewState();
}

class _RestaurantDetailViewState extends State<RestaurantDetailView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: size * 0.13,
          child: AppBar(
            title: _buildTitle(context),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                "${widget.model.resImg}",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              _buildHeaderSections(size),
              _buildText(size),
              _buildListofFoods(size),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSections(Size size) {
    return Container(
      width: size.width,
      height: size.height * 0.2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: 230,
                          child: Text(
                            "${widget.model.resName}",
                            maxLines: 1,
                            style: AppTextStyle.googleFont(
                              Colors.black,
                              26,
                              FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 230,
                          child: Text(
                            "${widget.model.description}",
                            style: AppTextStyle.googleFont(
                              Colors.black,
                              16,
                              FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        icon: const Icon(
                          size: 30,
                          Icons.favorite_border_sharp,
                        ),
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${widget.model.onQueue}\n',
                              style: AppTextStyle.googleFont(
                                "FF602E".toColor(),
                                28,
                                FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: 'คิว ณ ขนะนี้',
                              style: AppTextStyle.googleFont(
                                Colors.black,
                                16,
                                FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Material(
          borderRadius: BorderRadius.circular(100),
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainView(),
                  ),
                  (route) => false);
            },
            child: const SizedBox(
              width: 30,
              height: 30,
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildText(Size size) {
    return Container(
      width: size.width,
      margin: const EdgeInsets.only(top: 15, left: 17),
      child: Text(
        "List of Foods",
        style: AppTextStyle.googleFont(
          Colors.white,
          26,
          FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildListofFoods(Size size) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListView.separated(
        physics: const ScrollPhysics(),
        separatorBuilder: (context, index) => const SizedBox(
          height: 13,
        ),
        shrinkWrap: true,
        itemCount: widget.model.foods?.length ?? 0,
        itemBuilder: (context, index) {
          final len = widget.model.foods?.length ?? 0;
          final food = widget.model.foods;
          if (food != null) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return FoodDetailView(foods: food[index]);
                    },
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.35,
                          height: size.height * 0.13,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            child: Image.network(
                              "${food[index].menuImg}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: size.height * 0.13,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: SizedBox(
                                          width: size.width * 0.4,
                                          child: Text(
                                            "${food[index].menuName}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextStyle.googleFont(
                                              Colors.black,
                                              20,
                                              FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width: size.width * 0.52,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: SizedBox(
                                                  width: 140,
                                                  child: Text(
                                                    "${food[index].menuDescription}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        AppTextStyle.googleFont(
                                                      Colors.grey.shade500,
                                                      14,
                                                      FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const Icon(
                                                Icons.add,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: SizedBox(
                                          width: 70,
                                          child: Text(
                                            "฿ ${food[index].menuPrice}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextStyle.googleFont(
                                              "00900E".toColor(),
                                              16,
                                              FontWeight.w500,
                                            ),
                                          ),
                                        ),
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
          } else if (len == 0) {
            return const Center(
              child: Text(
                "ไม่มีรายการอาหาร",
              ),
            );
          } else {
            return const Text("ไม่มีรายการอาหาร");
          }
        },
      ),
    );
  }
}
