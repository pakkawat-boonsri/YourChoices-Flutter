import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:uuid/uuid.dart';
import 'package:your_choices/global.dart';
import 'package:your_choices/src/domain/entities/vendor/add_ons/add_ons_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';
import 'package:your_choices/src/presentation/blocs/vendor_bloc/add_add_ons/add_add_ons_cubit.dart';
import 'package:your_choices/src/presentation/blocs/vendor_bloc/filter_option/filter_options_cubit.dart';
import 'package:your_choices/src/presentation/widgets/custom_vendor_appbar.dart';
import 'package:your_choices/utilities/show_flutter_toast.dart';

import '../../../../../../utilities/loading_dialog.dart';
import '../../../../../../utilities/text_style.dart';

class AddFilterOptionView extends StatefulWidget {
  const AddFilterOptionView({super.key});

  @override
  State<AddFilterOptionView> createState() => _AddFilterOptionViewState();
}

class _AddFilterOptionViewState extends State<AddFilterOptionView> {
  bool isRequire = false;
  bool isMultipleChoice = false;
  RadioTypes? _options;
  final filterOptionName = TextEditingController();
  final filterQuantity = TextEditingController();
  final addOnsName = TextEditingController();
  final addOnsPrice = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // final _dialogKey = GlobalKey<FormState>();
  int quantity = 1;

  @override
  void dispose() {
    filterOptionName.dispose();
    filterQuantity.dispose();
    addOnsName.dispose();
    addOnsPrice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppbar(
        title: "สร้างตัวเลือกใหม่",
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOptionTitle(),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: _buildCheckBoxs(),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
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
              Expanded(
                child: _buildListOfAddOnsBloc(),
              ),
              _buildAddChoiceButton(context),
              // const Spacer(),
              _buildConfirmAndCancelButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmAndCancelButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TouchableOpacity(
        onTap: () {
          if (_formKey.currentState!.validate()) {
            loadingDialog(context);
            List<AddOnsEntity> addOnsList = List.from(context.read<AddAddOnsCubit>().state);

            context.read<FilterOptionCubit>().createFilterOption(
                  filterOptionEntity: FilterOptionEntity(
                    filterId: const Uuid().v1(),
                    filterName: filterOptionName.text,
                    isMultiple: isMultipleChoice,
                    isRequired: isRequire,
                    multipleQuantity: isMultipleChoice == false ? null : quantity,
                    addOns: addOnsList,
                  ),
                );
            Future.delayed(const Duration(seconds: 1)).then((value) {
              BlocProvider.of<AddAddOnsCubit>(context).resetAddOns();
              Navigator.pop(context);
              Navigator.pop(context);
            });
          }
        },
        child: Container(
          alignment: Alignment.center,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.amber.shade900,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            "สร้างตัวเลือก",
            style: AppTextStyle.googleFont(
              Colors.white,
              22,
              FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListOfAddOnsBloc() {
    return BlocBuilder<AddAddOnsCubit, List<AddOnsEntity>>(
      builder: (context, state) {
        var addOnsList = state;
        return ListView.separated(
          // shrinkWrap: true,
          separatorBuilder: (context, index) => const SizedBox(
            height: 10,
          ),
          itemCount: addOnsList.length,
          itemBuilder: (context, index) {
            final addOnsEntity = addOnsList[index];
            // log("${state.addOnsEntity[index]}");
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
                        16,
                        FontWeight.w400,
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
                                    16,
                                    FontWeight.normal,
                                  ),
                                )
                              : addOnsEntity.priceType == RadioTypes.priceIncrease.toString()
                                  ? Text(
                                      "+${addOnsEntity.price ?? ""} ฿",
                                      style: AppTextStyle.googleFont(
                                        Colors.black,
                                        16,
                                        FontWeight.normal,
                                      ),
                                    )
                                  : Text(
                                      "-${addOnsEntity.price ?? ""} ฿",
                                      style: AppTextStyle.googleFont(
                                        Colors.black,
                                        16,
                                        FontWeight.normal,
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
                          onPressed: () {
                            BlocProvider.of<AddAddOnsCubit>(context).removeAddOns(index);
                          },
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

  Future<dynamic> _buildAddChoice(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          content: Wrap(
            children: [
              Text(
                "ชื่อช้อยส์",
                style: AppTextStyle.googleFont(
                  Colors.black,
                  18,
                  FontWeight.w500,
                ),
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
                            controlAffinity: ListTileControlAffinity.leading,
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
                            controlAffinity: ListTileControlAffinity.leading,
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
                      await context.read<AddAddOnsCubit>().addAddOns(
                            AddOnsEntity(
                              addonsId: const Uuid().v1(),
                              addonsName: addOnsName.text,
                              priceType: _options.toString(),
                              price: _options == RadioTypes.nochange ? null : int.parse(addOnsPrice.text),
                            ),
                          );
                      addOnsName.clear();
                      addOnsPrice.clear();
                      _options = null;
                      if (mounted) {
                        Navigator.pop(context);
                      }
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
              value: isRequire,
              onChanged: (value) {
                setState(() {
                  isRequire = value!;
                  if (isRequire && isMultipleChoice) {
                    isMultipleChoice = false;
                  }
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
                  if (isRequire && isMultipleChoice) {
                    isRequire = false;
                  }
                });
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          isMultipleChoice
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TouchableOpacity(
                      onTap: quantity == 1
                          ? () {
                              return showFlutterToast("ไม่สามารถเลือกต่ำกว่า 1 ได้");
                            }
                          : () {
                              quantity--;
                              setState(() {});
                            },
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      "$quantity",
                      style: AppTextStyle.googleFont(
                        Colors.white,
                        22,
                        FontWeight.w500,
                      ),
                    ),
                    TouchableOpacity(
                      onTap: () {
                        quantity++;
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTitle() {
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
            onFieldSubmitted: (value) {
              if (_formKey.currentState!.validate()) {}
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
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                ),
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
