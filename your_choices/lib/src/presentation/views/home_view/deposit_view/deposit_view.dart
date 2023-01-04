import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:your_choices/utilities/text_style.dart';

import 'package:your_choices/utilities/hex_color.dart';

class DepositView extends StatefulWidget {
  const DepositView({super.key});

  @override
  State<DepositView> createState() => _DepositViewState();
}

class _DepositViewState extends State<DepositView> {
  late TextEditingController _amount;
  final _formkey = GlobalKey<FormState>();

  bool _isValidate = false;

  didChange() {
    log(_amount.text);
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
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

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
              bottom: Radius.circular(15),
            ),
          ),
          backgroundColor: "FE7144".toColor(),
          title: const Text("เติมเงินเข้าบัญชี"),
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
                                return Container(
                                  margin: const EdgeInsets.all(5),
                                  width: 100,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(70),
                                    gradient: const LinearGradient(
                                        colors: [Colors.white, Colors.white]),
                                  ),
                                  child: TextButton(
                                    child: Text(
                                      "${(index + 1) * 100}",
                                      style: AppTextStyle.googleFont(
                                          Colors.black, 16, FontWeight.w700),
                                    ),
                                    onPressed: () async {},
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
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onTap: () {},
                              keyboardType: TextInputType.number,
                              onFieldSubmitted: (value) {
                                if (_formkey.currentState!.validate()) {
                                  setState(() {
                                    _isValidate = true;
                                  });
                                } else {
                                  setState(() {
                                    _isValidate = false;
                                  });
                                }
                              },
                              validator: (value) {
                                if (value != null) {
                                  int? newValue = int.tryParse(value);
                                  if (newValue != null) {
                                    if (newValue % 100 != 0) {
                                      return "จำนวนเงินต้องเป็นจำนวนเต็มร้อย";
                                    } else {
                                      return null;
                                    }
                                  } else {
                                    return "โปรดกรอกจำนวนเงิน";
                                  }
                                } else {
                                  return "โปรดกรอกจำนวนเงิน";
                                }
                              },
                              enableSuggestions: false,
                              style: AppTextStyle.googleFont(
                                  Colors.black, 18, FontWeight.w600),
                              textDirection: TextDirection.rtl,
                              controller: _amount,
                              autocorrect: false,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10),
                                errorStyle: AppTextStyle.googleFont(
                                    Colors.red, 16, FontWeight.w500),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: "จำนวนเงิน",
                                hintTextDirection: TextDirection.rtl,
                                hintStyle: AppTextStyle.googleFont(
                                    Colors.grey, 18, FontWeight.w500),
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
                          color: _isValidate ? "FE7144".toColor() : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: size.width * 0.79,
                        child: TextButton(
                          onPressed: _isValidate ? () {} : null,
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "QR CODE",
                      style: AppTextStyle.googleFont(
                          Colors.white, 24, FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Icon(
                            Icons.save_alt,
                            size: 30,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Save to Device",
                            style: AppTextStyle.googleFont(
                                Colors.white, 18, FontWeight.w500),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// Container(
//                                         margin: const EdgeInsets.all(5),
//                                         width: 100,
//                                         height: 45,
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(70),
//                                           gradient: state.selectedIndex == index
//                                               ? LinearGradient(colors: [
//                                                   "F93C00".toColor(),
//                                                   "FFB097".toColor(),
//                                                 ])
//                                               : const LinearGradient(colors: [
//                                                   Colors.white,
//                                                   Colors.white
//                                                 ]),
//                                         ),
//                                         child: TextButton(
//                                           child: Text(
//                                             "${(index + 1) * 100}",
//                                             style: AppTextStyle.googleFont(
//                                                 state.selectedIndex == index
//                                                     ? Colors.white
//                                                     : Colors.black,
//                                                 16,
//                                                 FontWeight.w700),
//                                           ),
//                                           onPressed: () {
                                            
//                                           },
//                                         ),
//                                       );