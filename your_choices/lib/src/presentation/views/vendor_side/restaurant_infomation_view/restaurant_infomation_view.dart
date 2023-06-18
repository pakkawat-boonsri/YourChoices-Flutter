import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/injection_container.dart' as di;
import 'package:your_choices/src/config/app_routes/on_generate_routes.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/presentation/blocs/vendor_bloc/order_history/order_history_cubit.dart';
import 'package:your_choices/src/presentation/views/vendor_side/order_history_view.dart/order_history_view.dart';
import 'package:your_choices/src/presentation/widgets/custom_vendor_appbar.dart';
import 'package:your_choices/utilities/hex_color.dart';

import '../../../../../utilities/text_style.dart';

class RestaurantInfoView extends StatefulWidget {
  final VendorEntity vendorEntity;
  const RestaurantInfoView({super.key, required this.vendorEntity});

  @override
  State<RestaurantInfoView> createState() => _RestaurantInfoViewState();
}

class _RestaurantInfoViewState extends State<RestaurantInfoView> {
  late VendorEntity vendorEntity;

  @override
  void initState() {
    vendorEntity = widget.vendorEntity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar(
        title: "ข้อมูลร้านอาหาร",
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: _buildBody(size, context),
    );
  }

  Widget _buildBody(Size size, BuildContext context) {
    return Column(
      children: [
        _buildResImage(size),
        _buildTitlewithButton(size),
        _buildResInfoWithImage(size, context),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Divider(
            thickness: 1,
            color: Colors.grey,
          ),
        ),
        _buildListOfNavigateFeatures(size)
      ],
    );
  }

  Column _buildListOfNavigateFeatures(Size size) {
    return Column(
      children: [
        TouchableOpacity(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => di.sl<OrderHistoryCubit>(),
                  child: OrderHistoryView(vendorEntity: vendorEntity),
                ),
              )),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: 60,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: "D9D9D9".toColor(),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          width: 30,
                          height: 30,
                          left: 18,
                          child: Image.asset(
                            "assets/images/record.png",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "ประวัติการสั่งซื้อ",
                  style: AppTextStyle.googleFont(
                    Colors.black,
                    16,
                    FontWeight.w500,
                  ),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container _buildTitlewithButton(Size size) {
    return Container(
      width: size.width,
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "ข้อมูลร้านค้าของคุณ",
              style: AppTextStyle.googleFont(
                Colors.black,
                24,
                FontWeight.w500,
              ),
            ),
          ),
          TouchableOpacity(
            onTap: () => Navigator.pushNamed(
              context,
              PageConst.editResInfoPage,
              arguments: vendorEntity,
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.shade900,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "แก้ไข",
                    style: AppTextStyle.googleFont(
                      Colors.white,
                      14,
                      FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildResImage(Size size) {
    return Container(
      width: size.width,
      height: 170,
      decoration: BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(
            vendorEntity.resProfileUrl!,
          ),
        ),
      ),
    );
  }

  Widget _buildResInfoWithImage(Size size, BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                vendorEntity.resName ?? "",
                style: AppTextStyle.googleFont(
                  Colors.white,
                  24,
                  FontWeight.bold,
                ),
              ),
              Text(
                vendorEntity.username ?? "",
                style: AppTextStyle.googleFont(
                  Colors.white,
                  18,
                  FontWeight.normal,
                ),
              ),
              Text(
                "ร้านก๋วยเตี๋ยว/น้ำดื่ม",
                style: AppTextStyle.googleFont(
                  Colors.white,
                  18,
                  FontWeight.normal,
                ),
              ),
            ],
          ),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    vendorEntity.profileUrl ?? "",
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
