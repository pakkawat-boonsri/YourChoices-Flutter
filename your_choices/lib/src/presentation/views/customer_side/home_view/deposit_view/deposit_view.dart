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

class DepositView extends StatefulWidget {
  final CustomerEntity customerEntity;
  const DepositView({
    Key? key,
    required this.customerEntity,
  }) : super(key: key);

  @override
  State<DepositView> createState() => _DepositViewState();
}

class _DepositViewState extends State<DepositView> {
  final _amount = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool isValidate = false;
  int? seletedIndex;
  bool showQrCode = false;
  @override
  void initState() {
    _amount.addListener(checkIsValidate);
    super.initState();
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  checkIsValidate() {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isValidate = true;
      });
    } else {
      isValidate = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppbar(
        title: "เติมเงินเข้าบัญชี",
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(18),
                  width: size.width,
                  height: size.height * 0.41,
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
                              return StatefulBuilder(
                                builder: (context, setState) =>
                                    TouchableOpacity(
                                  onTap: () async {
                                    _amount.text =
                                        ((index + 1) * 100).toString();
                                    setState(() {
                                      seletedIndex = index;
                                    });
                                    checkIsValidate;
                                  },
                                  child: Container(
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
                                                Colors.white
                                              ],
                                            ),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "${(index + 1) * 100}",
                                        style: AppTextStyle.googleFont(
                                          seletedIndex == index
                                              ? Colors.white
                                              : Colors.black,
                                          16,
                                          FontWeight.w700,
                                        ),
                                      ),
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^[1-9][0-9]*'),
                              ),
                            ],
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (value) => checkIsValidate(),
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
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  // left: size.width * 0.32,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 42),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isValidate ? "FE7144".toColor() : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: size.width * 0.79,
                      child: TextButton(
                        onPressed: isValidate
                            ? () async {
                                if (_formkey.currentState!.validate()) {
                                  genarateQrCode(context);
                                }
                              }
                            : null,
                        child: Text(
                          "Generate QR Code",
                          style: AppTextStyle.googleFont(
                              Colors.white, 20, FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  genarateQrCode(BuildContext context) async {
    final customerDeposit = widget.customerEntity
        .copyWith(
          depositAmount: _amount.text,
          withdrawAmount: null,
        )
        .toJson();
    log(customerDeposit);
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
                  data: customerDeposit,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
