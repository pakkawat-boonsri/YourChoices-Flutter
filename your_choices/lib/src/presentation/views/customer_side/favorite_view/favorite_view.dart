// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/src/config/app_routes/on_generate_routes.dart';
import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/favorite/favorite_cubit.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/favorite/favorite_state.dart';
import 'package:your_choices/src/presentation/widgets/custom_text.dart';
import 'package:your_choices/src/presentation/widgets/custom_vendor_appbar.dart';
import 'package:your_choices/utilities/hex_color.dart';
import 'package:your_choices/utilities/text_style.dart';

class FavoriteView extends StatefulWidget {
  final CustomerEntity customerEntity;
  const FavoriteView({
    Key? key,
    required this.customerEntity,
  }) : super(key: key);

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  @override
  void initState() {
    context.read<FavoriteCubit>().onGetFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "รายการร้านอาหารที่ชอบ",
        textSize: 20,
        fontWeight: FontWeight.w500,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          if (state.vendorEntities.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          "assets/images/restaurant_image.png",
                        ),
                      ),
                    ),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "ไม่มีรายการบันทึกร้านโปรดของคุณ",
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomText(
                        text: "\"ไม่คิดออกเลือกไม่ถูก กดดูหน้าบันทุกร้านการโปรด\"",
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      CustomText(
                        text: "กดรูปหัวใจในหน้าร้านค้าเพื่อบันทึกร้านโปรด",
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.vendorEntities.length,
            itemBuilder: (context, index) {
              final VendorEntity vendorEntity = state.vendorEntities[index];
              return TouchableOpacity(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    PageConst.restuarantPageDetail,
                    arguments: {
                      'customerEntity': widget.customerEntity,
                      'vendorEntity': vendorEntity,
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Container(
                        width: 130,
                        height: 120,
                        margin: const EdgeInsets.only(right: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              "${vendorEntity.resProfileUrl}",
                            ),
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.medium,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomText(
                              text: "${vendorEntity.resName}",
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            CustomText(
                              text: "${vendorEntity.description}",
                              color: Colors.white60,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            CustomText(
                              text: "${vendorEntity.restaurantType}",
                              color: Colors.white60,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            Text.rich(
                              TextSpan(
                                text: "มี ",
                                style: AppTextStyle.googleFont(
                                  Colors.white60,
                                  14,
                                  FontWeight.w500,
                                ),
                                children: [
                                  TextSpan(
                                    text: "${0}",
                                    style: AppTextStyle.googleFont(
                                      "FF602E".toColor(),
                                      16,
                                      FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " คิว ณ ขณะนี้",
                                    style: AppTextStyle.googleFont(
                                      Colors.white60,
                                      14,
                                      FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
