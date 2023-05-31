// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/presentation/views/customer_side/customer_order_view/customer_tab_bar_view/customer_cancel_failure_order_view.dart';
import 'package:your_choices/src/presentation/views/customer_side/customer_order_view/customer_tab_bar_view/customer_done_order_view.dart';
import 'package:your_choices/src/presentation/views/customer_side/customer_order_view/customer_tab_bar_view/customer_order_pending_view.dart';
import 'package:your_choices/utilities/text_style.dart';

class CustomerOrderView extends StatefulWidget {
  final CustomerEntity customerEntity;
  const CustomerOrderView({
    Key? key,
    required this.customerEntity,
  }) : super(key: key);

  @override
  State<CustomerOrderView> createState() => _CustomerOrderViewState();
}

class _CustomerOrderViewState extends State<CustomerOrderView> with SingleTickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 3, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ประวัติคำสั่งซื้อ",
          style: AppTextStyle.googleFont(
            Colors.black,
            22,
            FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                ),
                child: TabBar(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  controller: tabController,
                  indicator: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                    color: Colors.amber.shade900,
                  ),
                  labelStyle: GoogleFonts.ibmPlexSansThai(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelStyle: GoogleFonts.ibmPlexSansThai(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelColor: Colors.black,
                  isScrollable: true,
                  tabs: const [
                    Tab(
                      text: "กำลังดำเนินการ",
                    ),
                    Tab(
                      text: "รายการสำเร็จ",
                    ),
                    Tab(
                      text: "ยกเลิก/ผิดพลาด",
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              physics: const BouncingScrollPhysics(),
              children: [
                CustomerOrderPendingView(uid: widget.customerEntity.uid ?? ""),
                CustomerDoneOrderView(uid: widget.customerEntity.uid ?? ""),
                CustomerCancelFailureOrderView(uid: widget.customerEntity.uid ?? ""),
              ],
            ),
          )
        ],
      ),
    );
  }
}
