// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/src/config/app_routes/on_generate_routes.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/restaurant/restaurant_cubit.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/restaurant/restaurant_state.dart';
import 'package:your_choices/src/presentation/views/customer_side/search_box_view/bloc/search_box_bloc.dart';
import 'package:your_choices/src/presentation/widgets/custom_text.dart';
import 'package:your_choices/utilities/hex_color.dart';
import 'package:your_choices/utilities/text_style.dart';

class SeachBoxView extends StatefulWidget {
  final bool? isNodeFocus;
  const SeachBoxView({
    Key? key,
    this.isNodeFocus,
  }) : super(key: key);

  @override
  State<SeachBoxView> createState() => _SeachBoxViewState();
}

class _SeachBoxViewState extends State<SeachBoxView> {
  final searchTextController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<RestaurantCubit>(context).getAllRestaurant();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 112,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        leading: TouchableOpacity(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: "B44121".toColor(),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back,
              size: 22,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: TextField(
              controller: searchTextController,
              autofocus: widget.isNodeFocus ?? false,
              onChanged: (value) {
                context
                    .read<SearchBoxBloc>()
                    .add(OnTypingTextField(searchText: value));
              },
              style: AppTextStyle.googleFont(
                Colors.black,
                16,
                FontWeight.w400,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: "D9D9D9".toColor(),
                hintText: "ค้นหาร้านที่ต้องการ",
                hintStyle: AppTextStyle.googleFont(
                  "685A5A".toColor(),
                  16,
                  FontWeight.w600,
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 20, right: 8),
                  child: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                prefixIconColor: Colors.black,
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ),
        title: const CustomText(
          text: "ค้าหาร้านอาหาร",
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: BlocBuilder<RestaurantCubit, RestaurantState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case RestaurantLoadingData:
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.amber.shade900,
                ),
              );
            case RestaurantLoadedData:
              final currentState = state as RestaurantLoadedData;
              final List<VendorEntity> listofRestaurants =
                  List<VendorEntity>.from(currentState.vendorEntities);
              return BlocBuilder<SearchBoxBloc, SearchBoxState>(
                builder: (context, state) {
                  final searchText = state.searchText;
                  final searchResult = listofRestaurants
                      .where((element) => element.resName!
                          .toLowerCase()
                          .contains(searchText.toLowerCase()))
                      .toList();
                  return ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    itemCount: searchResult.length,
                    itemBuilder: (context, index) {
                      final VendorEntity vendorEntity = searchResult[index];
                      return TouchableOpacity(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            PageConst.restuarantPageDetail,
                            arguments: vendorEntity,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 20, 15, 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: vendorEntity.resProfileUrl ?? "",
                                    imageBuilder: (context, imageProvider) {
                                      return Container(
                                        width: size.width * 0.35,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                        ),
                                      );
                                    },
                                    placeholder: (context, url) => Container(
                                      width: size.width * 0.35,
                                      height: 120,
                                      alignment: Alignment.center,
                                      child: const CircularProgressIndicator(
                                        color: Colors.amber,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      width: size.width * 0.35,
                                      height: 120,
                                      decoration: const BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                      ),
                                      child: Image.asset(
                                        "assets/images/image_picker.png",
                                        width: 60,
                                        height: 60,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            child: Text(
                                              vendorEntity.resName ??
                                                  "No ResName",
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
                                                  margin: const EdgeInsets.only(
                                                    right: 10,
                                                  ),
                                                  child: Text(
                                                    "${vendorEntity.description}",
                                                    style:
                                                        AppTextStyle.googleFont(
                                                      Colors.grey,
                                                      14,
                                                      FontWeight.normal,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                  right: 10.0,
                                                ),
                                                child:
                                                    Icon(Icons.arrow_forward),
                                              )
                                            ],
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              text: "มี ",
                                              style: AppTextStyle.googleFont(
                                                  Colors.black,
                                                  14,
                                                  FontWeight.normal),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "${vendorEntity.onQueue}",
                                                  style:
                                                      AppTextStyle.googleFont(
                                                    "FF602E".toColor(),
                                                    16,
                                                    FontWeight.normal,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: " คิว ณ ขณะนี้",
                                                  style:
                                                      AppTextStyle.googleFont(
                                                    Colors.black,
                                                    14,
                                                    FontWeight.normal,
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
                    },
                  );
                },
              );

            default:
              return Container();
          }
        },
      ),
    );
  }
}
