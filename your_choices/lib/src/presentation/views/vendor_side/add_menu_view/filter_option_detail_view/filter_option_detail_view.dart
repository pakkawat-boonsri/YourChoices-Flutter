
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/global.dart';

import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';
import 'package:your_choices/src/presentation/widgets/custom_vendor_appbar.dart';

import '../../../../../../utilities/text_style.dart';



class FilterOptionDetailView extends StatefulWidget {
  final FilterOptionEntity filterOptionEntity;
  const FilterOptionDetailView({
    Key? key,
    required this.filterOptionEntity,
  }) : super(key: key);

  @override
  State<FilterOptionDetailView> createState() => _FilterOptionDetailViewState();
}

class _FilterOptionDetailViewState extends State<FilterOptionDetailView> {
  late final FilterOptionEntity filterOptionEntity;
  late final TextEditingController filterOptionName;
  RadioTypes? _options;
  final TextEditingController addOnsName = TextEditingController();
  final TextEditingController addOnsPrice = TextEditingController();

  @override
  void initState() {
    filterOptionEntity = widget.filterOptionEntity;
    filterOptionName =
        TextEditingController(text: filterOptionEntity.filterName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "รายละเอียดตัวเลือก",
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
              const SizedBox(
                width: 10,
              ),
              Text(
                "แต่ละช้อยส์ในตัวเลือก",
                style: AppTextStyle.googleFont(
                  Colors.white,
                  20,
                  FontWeight.w500,
                ),
              ),
              _buildListOfAddOnsBloc(),
              _buildAddChoiceButton(context),
              const Spacer(),
              _buildConfirmAndCancelButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Row _buildConfirmAndCancelButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TouchableOpacity(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            alignment: Alignment.center,
            width: 150,
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
            // todo: add filter option to menu
          },
          child: Container(
            alignment: Alignment.center,
            width: 150,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.amber.shade900,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              "บันทึก",
              style: AppTextStyle.googleFont(
                Colors.white,
                20,
                FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
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
                  TextFormField(
                    controller: addOnsName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
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
                                  });
                                },
                              ),
                            ),
                            _options == RadioTypes.priceIncrease
                                ? Expanded(
                                    child: TextField(
                                      controller: addOnsPrice,
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
                                  });
                                },
                              ),
                            ),
                            _options == RadioTypes.priceDecrease
                                ? Expanded(
                                    child: TextField(
                                      controller: addOnsPrice,
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
                        onTap: () async {
                          // todo: add addonb button
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

  Widget _buildListOfAddOnsBloc() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
      itemCount: filterOptionEntity.addOns?.length ?? 0,
      itemBuilder: (context, index) {
        final addOnsEntity = filterOptionEntity.addOns![index];
        return Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  addOnsEntity.addonsName ?? "No Name",
                  style: AppTextStyle.googleFont(
                    Colors.black,
                    18,
                    FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: addOnsEntity.price == null
                          ? Text(
                              "0 ฿",
                              style: AppTextStyle.googleFont(
                                Colors.black,
                                14,
                                FontWeight.normal,
                              ),
                            )
                          : addOnsEntity.priceType ==
                                  RadioTypes.priceIncrease.toString()
                              ? Text(
                                  "+${addOnsEntity.price ?? ""} ฿",
                                  style: AppTextStyle.googleFont(
                                    Colors.black,
                                    18,
                                    FontWeight.w500,
                                  ),
                                )
                              : Text(
                                  "-${addOnsEntity.price ?? ""} ฿",
                                  style: AppTextStyle.googleFont(
                                    Colors.black,
                                    18,
                                    FontWeight.w500,
                                  ),
                                ),
                    ),
                    const VerticalDivider(
                      endIndent: 7,
                      indent: 7,
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.delete,
                        color: Colors.amber.shade900,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
              value: filterOptionEntity.isRequired,
              onChanged: (value) {
                setState(() {});
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
              value: filterOptionEntity.isMultiple,
              onChanged: (value) {
                setState(() {});
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
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "โปรดกรอกชื่อตัวเลือก";
              }
              return null;
            },
            controller: filterOptionName,
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
                Colors.grey,
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
