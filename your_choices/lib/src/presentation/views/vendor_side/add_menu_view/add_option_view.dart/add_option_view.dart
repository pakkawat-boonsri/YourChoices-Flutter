import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/src/presentation/widgets/custom_vendor_appbar.dart';

import '../../../../../../utilities/text_style.dart';

enum RadioTypes {
  nochange,
  priceIncrease,
  priceDecrease,
}

class AddOptionView extends StatefulWidget {
  const AddOptionView({super.key});

  @override
  State<AddOptionView> createState() => _AddOptionViewState();
}

class _AddOptionViewState extends State<AddOptionView> {
  bool isRequire = false;
  bool isMultipleChoice = false;

  RadioTypes? _options;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar(
        title: "สร้างตัวเลือกใหม่",
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOptionTitle(),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: _buildCheckBoxs(),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ),
              _buildTextButton(),
              _buildAddChoiceButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildAddChoiceButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TouchableOpacity(
        activeOpacity: 0.5,
        onTap: () {
          _buildAddChoice(context);
        },
        child: Container(
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.amber[900],
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "+ เพิ่มช้อยส์",
              style: AppTextStyle.googleFont(
                Colors.white,
                18,
                FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _buildAddChoice(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          content: Wrap(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "ชื่อช้อยส์",
                    style: AppTextStyle.googleFont(
                      Colors.black,
                      18,
                      FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const TextField(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      isDense: true,
                      hintText: "กรอกชื่อชื่อช้อยส์",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "เลือกช้อยส์นี้มีผลต่อราคาของเมนูหรือไม่ ?",
                    style: AppTextStyle.googleFont(
                      Colors.black,
                      15,
                      FontWeight.normal,
                    ),
                  ),
                  StatefulBuilder(
                    builder: (context, setState) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RadioListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          activeColor: Colors.amber.shade900,
                          title: const Text("ไม่มีการเปลี่ยนแปลงราคา"),
                          value: RadioTypes.nochange,
                          groupValue: _options,
                          onChanged: (val) {
                            setState(() {
                              _options = val;
                              log(_options.toString());
                            });
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                                activeColor: Colors.amber.shade900,
                                title: const Text("เพิ่มราคา"),
                                value: RadioTypes.priceIncrease,
                                groupValue: _options,
                                onChanged: (val) {
                                  setState(() {
                                    _options = val;
                                    log(_options.toString());
                                  });
                                },
                              ),
                            ),
                            _options == RadioTypes.priceIncrease
                                ? Expanded(
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        icon: const Text(
                                          "+",
                                        ),
                                        suffixText: "฿",
                                        isDense: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.amber.shade900,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.amber.shade900,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                                activeColor: Colors.amber.shade900,
                                title: const Text("ลดราคา"),
                                value: RadioTypes.priceDecrease,
                                groupValue: _options,
                                onChanged: (val) {
                                  setState(() {
                                    _options = val;
                                    log(_options.toString());
                                  });
                                },
                              ),
                            ),
                            _options == RadioTypes.priceDecrease
                                ? Expanded(
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        icon: const Text(
                                          "-",
                                        ),
                                        suffixText: "฿",
                                        isDense: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.amber.shade900,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.amber.shade900,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TouchableOpacity(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "ยกเลิก",
                            style: AppTextStyle.googleFont(
                              Colors.white,
                              20,
                              FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      TouchableOpacity(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.amber.shade900,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "ยืนยัน",
                            style: AppTextStyle.googleFont(
                              Colors.white,
                              20,
                              FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  TouchableOpacity _buildTextButton() {
    return TouchableOpacity(
      onTap: () {},
      child: Row(
        children: [
          const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            "แก้ไขลำดับ",
            style: AppTextStyle.googleFont(
              Colors.white,
              20,
              FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckBoxs() {
    return StatefulBuilder(
      builder: (context, setState) => Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Theme(
            data: ThemeData.dark().copyWith(
              unselectedWidgetColor: Colors.white,
            ),
            child: CheckboxListTile(
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Colors.amber[900],
              contentPadding: EdgeInsets.zero,
              title: Text(
                "ลูกค้าจำเป็นต้องเลือกหรือไม่ ?",
                style: AppTextStyle.googleFont(
                  Colors.white,
                  18,
                  FontWeight.normal,
                ),
              ),
              value: isRequire,
              onChanged: (value) {
                setState(() {
                  isRequire = value!;
                });
              },
            ),
          ),
          Theme(
            data: ThemeData.dark().copyWith(
              unselectedWidgetColor: Colors.white,
            ),
            child: CheckboxListTile(
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Colors.amber[900],
              contentPadding: EdgeInsets.zero,
              title: Text(
                "ลูกค้าสามารถเลือกได้มากกว่า 1 ช้อยส์ ?",
                style: AppTextStyle.googleFont(
                  Colors.white,
                  18,
                  FontWeight.normal,
                ),
              ),
              value: isMultipleChoice,
              onChanged: (value) {
                setState(() {
                  isMultipleChoice = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Column _buildOptionTitle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ชื่อตัวเลือก",
          style: AppTextStyle.googleFont(
            Colors.white,
            22,
            FontWeight.w500,
          ),
        ),
        Text(
          "ระบุชื่อของตัวเลือกให้ครบและชัดเจน",
          style: AppTextStyle.googleFont(
            Colors.grey[400]!,
            16,
            FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 250,
          child: TextField(
            style: AppTextStyle.googleFont(
              Colors.white,
              18,
              FontWeight.w500,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              isDense: true,
              hintText: "กรอกชื่อตัวเลือก",
              hintStyle: AppTextStyle.googleFont(
                Colors.white,
                18,
                FontWeight.w500,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.amber[900]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.amber[900]!,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
