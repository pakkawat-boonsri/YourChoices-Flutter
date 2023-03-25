import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/presentation/views/vendor_side/order_history_view.dart/order_history_tabbar_view/accepted_order_view.dart';
import 'package:your_choices/src/presentation/views/vendor_side/order_history_view.dart/order_history_tabbar_view/cancel_order_view.dart';
import 'package:your_choices/src/presentation/widgets/custom_text.dart';
import 'package:your_choices/utilities/hex_color.dart';

import '../../../../../utilities/date_format.dart';
import '../../../../../utilities/text_style.dart';
import '../../../widgets/custom_vendor_appbar.dart';

class OrderHistoryView extends StatefulWidget {
  final VendorEntity vendorEntity;
  const OrderHistoryView({
    super.key,
    required this.vendorEntity,
  });

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView>
    with SingleTickerProviderStateMixin {
  late VendorEntity vendorEntity;
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    vendorEntity = widget.vendorEntity;
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar(
        onTap: () {
          Navigator.pop(context);
        },
        title: "ประวัติการสั่งซื้อ",
      ),
      body: Column(
        children: [
          _buildHeaderTitles(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          _buildTotalSellPriceByDate(),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: TabBar(
              controller: tabController,
              indicatorColor: Colors.amber.shade900,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  child: Text(
                    "ออเดอร์ที่รับ",
                    style: GoogleFonts.ibmPlexSansThai(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "ออเดอร์ที่ยกเลิก",
                    style: GoogleFonts.ibmPlexSansThai(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: const [
                AcceptedOrderView(),
                CancelOrderView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column _buildTotalSellPriceByDate() {
    return Column(
      children: [
        const CustomText(
          text: "สรุปยอดขายรายวัน",
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
        CustomText(
          text: "฿ ${vendorEntity.totalPriceSell.toString()}",
          color: "2EE140".toColor(),
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
        Container(
          width: 200,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.white,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: DateConverter.dateFormat(Timestamp.now())!,
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              const Icon(
                Icons.arrow_drop_down,
                size: 30,
                color: Colors.white,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderTitles() {
    return Container(
      height: 140,
      // color: Colors.amber,
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
                  20,
                  FontWeight.bold,
                ),
              ),
              Text(
                vendorEntity.username ?? "",
                style: AppTextStyle.googleFont(
                  Colors.white,
                  16,
                  FontWeight.normal,
                ),
              ),
              Text(
                "ร้านก๋วยเตี๋ยว/น้ำดื่ม",
                style: AppTextStyle.googleFont(
                  Colors.white,
                  16,
                  FontWeight.normal,
                ),
              ),
            ],
          ),
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
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
