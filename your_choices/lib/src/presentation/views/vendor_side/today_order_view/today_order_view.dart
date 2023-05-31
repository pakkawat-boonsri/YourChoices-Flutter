// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/global.dart';
import 'package:your_choices/src/presentation/views/vendor_side/today_order_view/cubit/today_order_cubit.dart';
import 'package:your_choices/src/presentation/views/vendor_side/today_order_view/tab_bar_view/done_order_view.dart';
import 'package:your_choices/src/presentation/views/vendor_side/today_order_view/tab_bar_view/inprogess_order_view.dart';
import 'package:your_choices/src/presentation/views/vendor_side/today_order_view/tab_bar_view/new_order_view.dart';
import 'package:your_choices/utilities/hex_color.dart';

import '../../../../../utilities/text_style.dart';

class TodayOrderView extends StatefulWidget {
  final String uid;
  const TodayOrderView({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<TodayOrderView> createState() => _TodayOrderViewState();
}

class _TodayOrderViewState extends State<TodayOrderView> {
  @override
  void initState() {
    BlocProvider.of<TodayOrderCubit>(context).receiveOrderFromCustomer(widget.uid, OrderTypes.pending.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
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
          title: Text(
            "ออเดอร์ลูกค้า",
            style: AppTextStyle.googleFont(
              Colors.black,
              24,
              FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.white,
          bottom: TabBar(
            onTap: (tabIndex) {
              switch (tabIndex) {
                case 0:
                  BlocProvider.of<TodayOrderCubit>(context)
                      .receiveOrderFromCustomer(widget.uid, OrderTypes.pending.toString());
                  break;
                case 1:
                  BlocProvider.of<TodayOrderCubit>(context)
                      .receiveOrderFromCustomer(widget.uid, OrderTypes.processing.toString());
                  break;
                case 2:
                  BlocProvider.of<TodayOrderCubit>(context)
                      .receiveOrderFromCustomer(widget.uid, OrderTypes.completed.toString());
                  break;
              }
            },
            indicatorColor: Colors.amber.shade900,
            unselectedLabelColor: Colors.grey,
            unselectedLabelStyle: GoogleFonts.ibmPlexSansThai(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            labelStyle: GoogleFonts.ibmPlexSansThai(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            labelColor: Colors.black,
            tabs: [
              Tab(
                child: Text(
                  "ใหม่",
                  style: GoogleFonts.ibmPlexSansThai(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "กำลังทำ",
                  style: GoogleFonts.ibmPlexSansThai(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "จบงาน",
                  style: GoogleFonts.ibmPlexSansThai(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BlocBuilder<TodayOrderCubit, TodayOrderState>(
              builder: (context, state) {
                if (state is TodayOrderLoading) {
                  return Container(
                    color: Colors.grey[350],
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.amber.shade900,
                      ),
                    ),
                  );
                } else if (state is TodayOrderLoaded) {
                  return NewOrderView(
                    orderEntities: state.orderEntities,
                  );
                }
                return Container();
              },
            ),
            BlocBuilder<TodayOrderCubit, TodayOrderState>(
              builder: (context, state) {
                if (state is TodayOrderLoading) {
                  return Container(
                    color: Colors.grey[350],
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.amber.shade900,
                      ),
                    ),
                  );
                } else if (state is TodayOrderLoaded) {
                  return InProgessOrderView(
                    orderEntities: state.orderEntities,
                  );
                }

                return Container();
              },
            ),
            BlocBuilder<TodayOrderCubit, TodayOrderState>(
              builder: (context, state) {
                if (state is TodayOrderLoading) {
                  return Container(
                    color: Colors.grey[350],
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.amber.shade900,
                      ),
                    ),
                  );
                } else if (state is TodayOrderLoaded) {
                  return DoneOrderView(
                    orderEntities: state.orderEntities,
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
