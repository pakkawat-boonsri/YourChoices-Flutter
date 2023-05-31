// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/src/config/app_routes/on_generate_routes.dart';
import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/restaurant/restaurant_cubit.dart';
import 'package:your_choices/src/presentation/widgets/custom_text.dart';
import 'package:your_choices/utilities/hex_color.dart';

import '../../../../../../../utilities/text_style.dart';
import '../../../../../../domain/entities/vendor/vendor_entity.dart';
import '../../../../../blocs/customer_bloc/restaurant/restaurant_state.dart';

class ListofRestaurants extends StatefulWidget {
  final CustomerEntity customerEntity;
  final String restaurantType;
  const ListofRestaurants({
    Key? key,
    required this.customerEntity,
    required this.restaurantType,
  }) : super(key: key);

  @override
  State<ListofRestaurants> createState() => _ListofRestaurantsState();
}

class _ListofRestaurantsState extends State<ListofRestaurants> {
  @override
  void initState() {
    BlocProvider.of<RestaurantCubit>(context).getAllRestaurant();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<RestaurantCubit, RestaurantState>(
      builder: (context, state) {
        if (state is RestaurantLoadingData) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.amber,
            ),
          );
        } else if (state is RestaurantLoadedData) {
          List<VendorEntity> vendorEntities = state.vendorEntities;
          List<VendorEntity> filteredTypesOfVendorEntities =
              vendorEntities.where((element) => element.restaurantType == widget.restaurantType).toList();

          return filteredTypesOfVendorEntities.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/restaurant_image.png",
                      scale: 0.5,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "ไม่มีร้านอาหารประเภท ${widget.restaurantType} ณ ขณะนี้",
                      style: AppTextStyle.googleFont(
                        Colors.grey,
                        18,
                        FontWeight.w600,
                      ),
                    )
                  ],
                )
              : ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                  itemCount: filteredTypesOfVendorEntities.length,
                  itemBuilder: (context, index) {
                    final VendorEntity vendorEntity = filteredTypesOfVendorEntities[index];
                    return TouchableOpacity(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          PageConst.restuarantPageDetail,
                          arguments: {
                            "customerEntity": widget.customerEntity,
                            "vendorEntity": vendorEntity,
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: vendorEntity.resProfileUrl ?? "",
                                  imageBuilder: (context, imageProvider) {
                                    return vendorEntity.isActive ?? false
                                        ? Container(
                                            width: size.width * 0.35,
                                            height: size.width * 0.315,
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
                                          )
                                        : SizedBox(
                                            width: size.width * 0.35,
                                            height: size.width * 0.31,
                                            child: Stack(
                                              children: [
                                                Container(
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
                                                ),
                                                Container(
                                                  width: size.width * 0.35,
                                                  height: size.width * 0.315,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black.withOpacity(0.7),
                                                    borderRadius: const BorderRadius.only(
                                                      topLeft: Radius.circular(10),
                                                      bottomLeft: Radius.circular(10),
                                                    ),
                                                  ),
                                                  child: const CustomText(
                                                    text: "Close",
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
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
                                  errorWidget: (context, url, error) => Container(
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                            right: 10,
                                          ),
                                          child: Text(
                                            vendorEntity.resName ?? "No ResName",
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
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                  right: 10,
                                                ),
                                                child: Text(
                                                  "${vendorEntity.description}",
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
                                              padding: EdgeInsets.only(
                                                right: 10.0,
                                              ),
                                              child: Icon(Icons.arrow_forward),
                                            )
                                          ],
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            text: "มี ",
                                            style: AppTextStyle.googleFont(Colors.black, 14, FontWeight.normal),
                                            children: [
                                              TextSpan(
                                                text: "${vendorEntity.onQueue}",
                                                style: AppTextStyle.googleFont(
                                                  "FF602E".toColor(),
                                                  16,
                                                  FontWeight.normal,
                                                ),
                                              ),
                                              TextSpan(
                                                text: " คิว ณ ขณะนี้",
                                                style: AppTextStyle.googleFont(
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
        }

        return Container();
      },
    );
  }
}
