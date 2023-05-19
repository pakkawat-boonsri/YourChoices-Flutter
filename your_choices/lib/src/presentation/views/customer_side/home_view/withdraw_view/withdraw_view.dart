// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/presentation/widgets/custom_vendor_appbar.dart';
import 'package:your_choices/utilities/hex_color.dart';
import 'package:your_choices/utilities/text_style.dart';

class WithDrawView extends StatefulWidget {
  final CustomerEntity customerEntity;
  const WithDrawView({
    Key? key,
    required this.customerEntity,
  }) : super(key: key);

  @override
  State<WithDrawView> createState() => _WithDrawViewState();
}

class _WithDrawViewState extends State<WithDrawView> {
  final _amount = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  bool _isValidate = false;

  int? seletedIndex;

  didChange() {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isValidate = true;
      });
    } else {
      setState(() {
        _isValidate = false;
      });
    }
  }

  @override
  void initState() {
    _amount.addListener(didChange);
    super.initState();
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar(
        title: "ถอนเงินออกบัญชี",
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 15,
                    left: 30,
                    right: 30,
                  ),
                  width: size.width,
                  child: Text(
                    "เงินภายในบัญชี : ",
                    style: AppTextStyle.googleFont(
                      Colors.white,
                      24,
                      FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  width: size.width,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 30),
                  child: Text(
                    "฿ ${widget.customerEntity.balance}",
                    style: AppTextStyle.googleFont(
                        Colors.white, 34, FontWeight.w600),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 350,
              child: Stack(
                children: [
                  withDrawBodySelection(size, context),
                  Positioned(
                    top: 300,
                    child: TouchableOpacity(
                      onTap: _isValidate
                          ? () async {
                              genarateQrCode(context);
                            }
                          : null,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          color: _isValidate ? "FE7144".toColor() : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: size.width * 0.79,
                        height: 45,
                        alignment: Alignment.center,
                        child: Text(
                          "Generate QR Code",
                          style: AppTextStyle.googleFont(
                            Colors.white,
                            20,
                            FontWeight.bold,
                          ),
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
    );
  }

  Container withDrawBodySelection(Size size, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      width: size.width,
      height: size.height * 0.408,
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
              style: AppTextStyle.googleFont(Colors.white, 22, FontWeight.bold),
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
                  return StatefulBuilder(
                    builder: (context, setState) => TouchableOpacity(
                      onTap: () async {
                        _amount.text = ((index + 1) * 100).toString();
                        setState(() {
                          seletedIndex = index;
                        });
                        didChange();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(5),
                        width: 100,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70),
                          gradient: seletedIndex == index
                              ? LinearGradient(
                                  colors: [
                                    "F93C00".toColor(),
                                    "FFB097".toColor(),
                                  ],
                                )
                              : const LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.white,
                                  ],
                                ),
                        ),
                        child: Text(
                          "${(index + 1) * 100}",
                          style: AppTextStyle.googleFont(
                              Colors.black, 16, FontWeight.w700),
                        ),
                      ),
                    ),
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
          const SizedBox(
            height: 10,
          ),
          Form(
            key: _formkey,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (value) {
                      if (_formkey.currentState!.validate()) {
                        _isValidate = true;
                      } else {
                        _isValidate = false;
                      }
                    },
                    validator: (value) {
                      if (_amount.text != "") {
                        int? newValue = int.tryParse(_amount.text);
                        if (newValue != null) {
                          if (newValue > 0) {
                            return null;
                          } else {
                            return "จำนวนเงินต้องเป็นจำนวนเต็ม";
                          }
                        } else {
                          return "โปรดกรอกจำนวนเงิน";
                        }
                      } else {
                        return "";
                      }
                    },
                    enableSuggestions: false,
                    style: AppTextStyle.googleFont(
                      Colors.black,
                      18,
                      FontWeight.w600,
                    ),
                    textDirection: TextDirection.rtl,
                    controller: _amount,
                    autocorrect: false,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10,
                      ),
                      errorStyle: AppTextStyle.googleFont(
                        Colors.red,
                        16,
                        FontWeight.w500,
                      ),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "จำนวนเงิน",
                      hintTextDirection: TextDirection.rtl,
                      hintStyle: AppTextStyle.googleFont(
                        Colors.grey,
                        18,
                        FontWeight.w500,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  genarateQrCode(BuildContext context) async {
    final customerWithDraw = widget.customerEntity
        .copyWith(
          withdrawAmount: _amount.text,
          depositAmount: null,
        )
        .toJson();
    log(customerWithDraw);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Qr Code"),
          content: Wrap(
            children: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: QrImage(
                  data: customerWithDraw,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
