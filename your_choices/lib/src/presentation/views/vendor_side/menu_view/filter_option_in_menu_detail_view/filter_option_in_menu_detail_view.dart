// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:uuid/uuid.dart';
import 'package:your_choices/global.dart';
import 'package:your_choices/src/domain/entities/vendor/add_ons/add_ons_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';
import 'package:your_choices/src/presentation/blocs/vendor_bloc/filter_option_in_menu/filter_option_in_menu_cubit.dart';
import 'package:your_choices/src/presentation/views/vendor_side/menu_view/filter_option_in_menu_detail_view/cubit/new_add_on_in_filter_option_in_menu_cubit.dart';
import 'package:your_choices/src/presentation/widgets/custom_vendor_appbar.dart';
import 'package:your_choices/utilities/loading_dialog.dart';
import 'package:your_choices/utilities/show_flutter_toast.dart';

import '../../../../../../utilities/text_style.dart';

class FilterOptionInMenuDetailView extends StatefulWidget {
  final DishesEntity dishesEntity;
  final FilterOptionEntity filterOptionEntity;
  const FilterOptionInMenuDetailView({
    Key? key,
    required this.dishesEntity,
    required this.filterOptionEntity,
  }) : super(key: key);

  @override
  State<FilterOptionInMenuDetailView> createState() => _FilterOptionInMenuDetailViewState();
}

class _FilterOptionInMenuDetailViewState extends State<FilterOptionInMenuDetailView> {
  late bool isRequire;
  late bool isMultipleChoice;
  late final FilterOptionEntity filterOptionEntity;
  late final TextEditingController filterOptionName;
  final _formKey = GlobalKey<FormState>();
  RadioTypes? _options;
  late int quantity;

  final TextEditingController addOnsName = TextEditingController();
  final TextEditingController addOnsPrice = TextEditingController();

  @override
  void initState() {
    filterOptionEntity = widget.filterOptionEntity;
    context.read<NewAddOnInFilterOptionInMenuCubit>().init(List<AddOnsEntity>.from(widget.filterOptionEntity.addOns ?? []));
    isRequire = widget.filterOptionEntity.isRequired ?? false;
    isMultipleChoice = widget.filterOptionEntity.isMultiple ?? false;
    quantity = widget.filterOptionEntity.multipleQuantity ?? 1;
    filterOptionName = TextEditingController(text: filterOptionEntity.filterName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppbar(
        title: "รายละเอียดตัวเลือก",
        onTap: () {
          Navigator.pop(context);
          context.read<NewAddOnInFilterOptionInMenuCubit>().onResetAddOns();
          context.read<NewAddOnInFilterOptionInMenuCubit>().resetDeleteAddOns();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
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
              Expanded(
                flex: 15,
                child: _buildListOfAddOnsBloc(),
              ),
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
      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              loadingDialog(context);
              final currentDeleted =
                  List<AddOnsEntity>.from(context.read<NewAddOnInFilterOptionInMenuCubit>().deletedAddOns);
              if (currentDeleted.isNotEmpty) {
                context.read<FilterOptionInMenuCubit>().onDeleteAddonInFilterOptionInMenu(
                      addOnsEntity: currentDeleted,
                      dishesEntity: widget.dishesEntity,
                      filterOptionEntity: filterOptionEntity,
                    );
              } else {
                List<AddOnsEntity> addOnsList = List.from(context.read<NewAddOnInFilterOptionInMenuCubit>().state);
                log("$addOnsList");
                final filterOptions = List.generate(
                    1,
                    (index) => FilterOptionEntity(
                          filterId: filterOptionEntity.filterId,
                          filterName: filterOptionName.text,
                          isMultiple: isMultipleChoice,
                          isRequired: isRequire,
                          multipleQuantity: isMultipleChoice == false ? null : quantity,
                          addOns: addOnsList,
                        ));
                await context
                    .read<FilterOptionInMenuCubit>()
                    .addFilterOptionInMenu(dishesEntity: widget.dishesEntity, filterOptions: filterOptions);
              }

              Future.delayed(const Duration(seconds: 1)).then((value) {
                BlocProvider.of<NewAddOnInFilterOptionInMenuCubit>(context).onResetAddOns();
                BlocProvider.of<NewAddOnInFilterOptionInMenuCubit>(context).resetDeleteAddOns();
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              });
            }
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
                                controlAffinity: ListTileControlAffinity.leading,
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
                                controlAffinity: ListTileControlAffinity.leading,
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
                          await context.read<NewAddOnInFilterOptionInMenuCubit>().onAddingAddOnInFilterOptionInMenuDetail(
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
    return BlocBuilder<NewAddOnInFilterOptionInMenuCubit, List<AddOnsEntity>>(
      builder: (context, state) {
        return ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          separatorBuilder: (context, index) => const SizedBox(
            height: 10,
          ),
          itemCount: state.length,
          itemBuilder: (context, index) {
            final addOnsEntity = state[index];
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
                                    18,
                                    FontWeight.w500,
                                  ),
                                )
                              : addOnsEntity.priceType == RadioTypes.priceIncrease.toString()
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
                          onPressed: () {
                            context.read<NewAddOnInFilterOptionInMenuCubit>().addingDeletedAddOns(addOnsEntity);
                            context
                                .read<NewAddOnInFilterOptionInMenuCubit>()
                                .onDeleteAddOnInFilterOptionInMenuDetail(addOnsEntity);
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
