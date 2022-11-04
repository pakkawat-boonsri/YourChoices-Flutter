import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_choices/constants/text_style.dart';
import 'package:your_choices/src/customer_screen/bloc/deposit_bloc/bloc/deposit_bloc.dart';

import 'package:your_choices/utilities/hex_color.dart';

class DepositView extends StatefulWidget {
  const DepositView({super.key});

  @override
  State<DepositView> createState() => _DepositViewState();
}

class _DepositViewState extends State<DepositView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 20,
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          backgroundColor: "FE7144".toColor(),
          title: const Text("เติมเงินเข้าบัญชี"),
        ),
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(18),
                  width: size.width,
                  height: size.height * 0.35,
                  decoration: BoxDecoration(
                    color: "46413E".toColor(),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, left: 25),
                        child: Text(
                          "จำนวนเงิน",
                          style: AppTextStyle.googleFont(
                              Colors.white, 22, FontWeight.bold),
                        ),
                      ),
                      const Divider(
                        color: Colors.white,
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      ),
                      SizedBox(
                        width: size.width,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: List.generate(
                            6,
                            (index) {
                              return BlocBuilder<DepositBloc, DepositState>(
                                builder: (context, state) {
                                  if (state is DepositInitial) {
                                    return Container(
                                      margin: const EdgeInsets.all(5),
                                      width: 100,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(70),
                                        gradient: const LinearGradient(colors: [
                                          Colors.white,
                                          Colors.white
                                        ]),
                                      ),
                                      child: TextButton(
                                        child: Text(
                                          "${(index + 1) * 100}",
                                          style: AppTextStyle.googleFont(
                                              Colors.black,
                                              16,
                                              FontWeight.w700),
                                        ),
                                        onPressed: () {
                                          context.read<DepositBloc>().add(
                                              SelectingIndexEvent(
                                                  selectedIndex: index));
                                        },
                                      ),
                                    );
                                  } else if (state is SelectedIndexState) {
                                    return Container(
                                      margin: const EdgeInsets.all(5),
                                      width: 100,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(70),
                                        gradient: state.selectedIndex == index
                                            ? LinearGradient(colors: [
                                                "F93C00".toColor(),
                                                "FFB097".toColor(),
                                              ])
                                            : const LinearGradient(colors: [
                                                Colors.white,
                                                Colors.white
                                              ]),
                                      ),
                                      child: TextButton(
                                        child: Text(
                                          "${(index + 1) * 100}",
                                          style: AppTextStyle.googleFont(
                                              Colors.black,
                                              16,
                                              FontWeight.w700),
                                        ),
                                        onPressed: () {
                                          context.read<DepositBloc>().add(
                                              SelectingIndexEvent(
                                                  selectedIndex: index));
                                        },
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.white,
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// if (state is DepositInitial) {
//                                     return Container(
//                                       margin: const EdgeInsets.all(5),
//                                       width: 100,
//                                       height: 45,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(70),
//                                         gradient: const LinearGradient(colors: [
//                                           Colors.white,
//                                           Colors.white
//                                         ]),
//                                       ),
//                                       child: TextButton(
//                                         child: Text(
//                                           "${(index + 1) * 100}",
//                                           style: AppTextStyle.googleFont(
//                                               Colors.black,
//                                               16,
//                                               FontWeight.w700),
//                                         ),
//                                         onPressed: () {
//                                           context.read<DepositBloc>().add(
//                                               SelectingIndexEvent(
//                                                   selectedIndex: index));
//                                         },
//                                       ),
//                                     );
//                                   } else