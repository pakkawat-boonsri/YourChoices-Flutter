import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/injection_container.dart' as di;
import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/get_current_uid_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/utilities/upload_image_to_storage_usecase.dart';
import 'package:your_choices/src/presentation/blocs/vendor_bloc/menu/menu_cubit.dart';
import 'package:your_choices/src/presentation/blocs/vendor_bloc/menu/menu_state.dart';
import 'package:your_choices/src/presentation/widgets/custom_vendor_appbar.dart';
import 'package:your_choices/utilities/loading_dialog.dart';

import '../../../../../../utilities/text_style.dart';
import '../../../../../config/app_routes/on_generate_routes.dart';
import '../../../../blocs/vendor_bloc/filter_option_in_menu/filter_option_in_menu_cubit.dart';

class MenuDetailView extends StatefulWidget {
  final DishesEntity dishesEntity;
  final String uid;
  const MenuDetailView({
    Key? key,
    required this.dishesEntity,
    required this.uid,
  }) : super(key: key);

  @override
  State<MenuDetailView> createState() => _MenuDetailViewState();
}

class _MenuDetailViewState extends State<MenuDetailView> {
  File? imageFile;
  late final TextEditingController menuName;
  late final TextEditingController menuDescription;
  late final TextEditingController menuPrice;
  final _formKey = GlobalKey<FormState>();
  late final bool isActive;
  bool isModified = false;
  @override
  void initState() {
    isActive = widget.dishesEntity.isActive ?? false;
    menuName = TextEditingController(text: widget.dishesEntity.menuName);
    menuDescription = TextEditingController(text: widget.dishesEntity.menuDescription);
    menuPrice = TextEditingController(text: widget.dishesEntity.menuPrice.toString());
    BlocProvider.of<FilterOptionInMenuCubit>(context).getFilterOptionInMenu(widget.dishesEntity);
    super.initState();
  }

  @override
  void dispose() {
    menuName.dispose();
    menuDescription.dispose();
    menuPrice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar(
        title: "รายละเอียดเมนูอาหาร",
        onTap: () async {
          Navigator.pushNamedAndRemoveUntil(
            context,
            PageConst.menuPage,
            arguments: await di.sl<GetCurrentUidUseCase>().call(),
            (route) => route.isFirst,
          );
        },
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageFile == null
                  ? widget.dishesEntity.menuImg == null || widget.dishesEntity.menuImg == ""
                      ? _buildNoImageUpload(size)
                      : _buildHaveMenuImage(size)
                  : _buildUploadedImage(size),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFoodNameTextFormField(),
                  const SizedBox(
                    height: 12,
                  ),
                  _buildFoodDescriptionTextFormField(),
                  const SizedBox(
                    height: 12,
                  ),
                  _buildFoodPriceTextFormField(),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
              _buildSwitch(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ),
              _buildFilterOptionItem(context, size),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ),
              _buildConfirmAndCancelButton(),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmAndCancelButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TouchableOpacity(
          activeOpacity: 0.5,
          onTap: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  actionsAlignment: MainAxisAlignment.spaceEvenly,
                  title: Text(
                    "ต้องการที่จะลบเมนูนี้หรือไม่",
                    style: AppTextStyle.googleFont(
                      Colors.black,
                      18,
                      FontWeight.w500,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Name: ",
                            style: AppTextStyle.googleFont(
                              Colors.black,
                              15,
                              FontWeight.normal,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${widget.dishesEntity.menuName}",
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.googleFont(
                                Colors.black,
                                15,
                                FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Description: ",
                            style: AppTextStyle.googleFont(
                              Colors.black,
                              15,
                              FontWeight.normal,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${widget.dishesEntity.menuDescription}",
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.googleFont(
                                Colors.black,
                                15,
                                FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Price: ",
                            style: AppTextStyle.googleFont(
                              Colors.black,
                              15,
                              FontWeight.normal,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${widget.dishesEntity.menuPrice}",
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.googleFont(
                                Colors.black,
                                15,
                                FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "ยกเลิก",
                        style: AppTextStyle.googleFont(
                          Colors.redAccent,
                          16,
                          FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "ยืนยัน",
                        style: AppTextStyle.googleFont(
                          Colors.blueAccent,
                          16,
                          FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            width: 125,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                Text(
                  "ลบเมนู",
                  style: AppTextStyle.googleFont(
                    Colors.white,
                    20,
                    FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        TouchableOpacity(
          activeOpacity: 0.5,
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              List<FilterOptionEntity> newFilterList = List<FilterOptionEntity>.from(
                context.read<FilterOptionInMenuCubit>().state,
              );

              List<FilterOptionEntity> deletedList = List<FilterOptionEntity>.from(
                context.read<FilterOptionInMenuCubit>().getDeleteFilterOptionList,
              );

              if (deletedList.isNotEmpty) {
                for (var deleteFilter in deletedList) {
                  context.read<FilterOptionInMenuCubit>().deletingFilterOptionInMenu(deleteFilter);
                }
              }

              loadingDialog(context);
              context.read<MenuCubit>().createMenu(
                    widget.dishesEntity.copyWith(
                      createdAt: Timestamp.now(),
                      menuName: menuName.text,
                      menuDescription: menuDescription.text,
                      menuImg: imageFile == null
                          ? widget.dishesEntity.menuImg
                          : await di
                              .sl<UploadImageToStorageUseCase>()
                              .call(imageFile!, "menuImages_${widget.dishesEntity.dishesId}"),
                      menuPrice: int.parse(menuPrice.text),
                      filterOption: newFilterList,
                    ),
                  );
              Future.delayed(const Duration(seconds: 1)).then((value) {
                context.read<FilterOptionInMenuCubit>().state.clear();
                context.read<FilterOptionInMenuCubit>().resetDeleteFilterOptionInMenu();

                Navigator.pop(context);
                Navigator.pop(context);
              });
            }
          },
          child: Container(
            width: 125,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.amber[900],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.save,
                  color: Colors.white,
                  size: 24,
                ),
                Text(
                  "บันทึก",
                  style: AppTextStyle.googleFont(
                    Colors.white,
                    20,
                    FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildFilterOptionItem(
    BuildContext context,
    Size size,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ตัวเลือก",
                style: AppTextStyle.googleFont(
                  Colors.white,
                  22,
                  FontWeight.w500,
                ),
              ),
              TouchableOpacity(
                onTap: () {
                  isModified = !isModified;
                  setState(() {});
                },
                child: Text(
                  "แก้ไข",
                  style: AppTextStyle.googleFont(
                    Colors.white,
                    22,
                    FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        BlocBuilder<FilterOptionInMenuCubit, List<FilterOptionEntity>>(
          builder: (context, state) {
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
              itemCount: state.length,
              itemBuilder: (context, index) {
                final filterOptionEntity = state[index];

                return TouchableOpacity(
                  onTap: isModified
                      ? () {
                          Navigator.pushNamed(
                            context,
                            PageConst.filterOptionInMenuDetailPage,
                            arguments: {
                              'dishesEntity': widget.dishesEntity,
                              'filterOptionEntity': filterOptionEntity,
                            },
                          );
                        }
                      : null,
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 5, top: 5),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                filterOptionEntity.filterName ?? "no name",
                                style: AppTextStyle.googleFont(
                                  Colors.black,
                                  20,
                                  FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              if (filterOptionEntity.isRequired == true && filterOptionEntity.isMultiple == false) ...[
                                Text(
                                  " (ต้องเลือก) ",
                                  style: AppTextStyle.googleFont(
                                    Colors.grey.shade800,
                                    14,
                                    FontWeight.normal,
                                  ),
                                ),
                              ] else if (filterOptionEntity.isRequired == false &&
                                  filterOptionEntity.isMultiple == true) ...[
                                Text(
                                  " (เลือกได้ ${filterOptionEntity.multipleQuantity} จำนวน )",
                                  style: AppTextStyle.googleFont(
                                    Colors.grey.shade800,
                                    14,
                                    FontWeight.normal,
                                  ),
                                ),
                              ],
                              const SizedBox(
                                width: 10,
                              ),
                              isModified
                                  ? Icon(
                                      Icons.edit,
                                      color: Colors.amber.shade900,
                                    )
                                  : Container(),
                              const Spacer(),
                              isModified
                                  ? TouchableOpacity(
                                      onTap: () {
                                        context.read<FilterOptionInMenuCubit>().deleteFilterOptionInMenu(filterOptionEntity);
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filterOptionEntity.addOns?.length ?? 0,
                            itemBuilder: (context, index) {
                              final addOnsEntity = filterOptionEntity.addOns?[index];
                              return Row(
                                children: [
                                  if (filterOptionEntity.isRequired == true && filterOptionEntity.isMultiple == false) ...[
                                    Icon(
                                      Icons.circle_outlined,
                                      color: Colors.grey.shade800,
                                      size: 14,
                                    ),
                                  ] else if (filterOptionEntity.isRequired == false &&
                                      filterOptionEntity.isMultiple == true) ...[
                                    Icon(
                                      Icons.rectangle_outlined,
                                      color: Colors.grey.shade800,
                                      size: 14,
                                    ),
                                  ],
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    addOnsEntity?.addonsName ?? "no addons",
                                    style: AppTextStyle.googleFont(
                                      Colors.grey.shade800,
                                      14,
                                      FontWeight.normal,
                                    ),
                                  ),
                                  const Spacer(),
                                  addOnsEntity?.price == null
                                      ? Text(
                                          "0 ฿",
                                          style: AppTextStyle.googleFont(
                                            Colors.grey.shade800,
                                            14,
                                            FontWeight.normal,
                                          ),
                                        )
                                      : addOnsEntity?.priceType == "RadioTypes.priceIncrease"
                                          ? Text(
                                              "+",
                                              style: AppTextStyle.googleFont(
                                                Colors.grey.shade800,
                                                14,
                                                FontWeight.normal,
                                              ),
                                            )
                                          : Text(
                                              "-",
                                              style: AppTextStyle.googleFont(
                                                Colors.grey.shade800,
                                                14,
                                                FontWeight.normal,
                                              ),
                                            ),
                                  addOnsEntity?.price == null
                                      ? const Text("")
                                      : addOnsEntity?.priceType == "RadioTypes.priceIncrease"
                                          ? Text(
                                              "${addOnsEntity?.price ?? ""} ฿",
                                              style: AppTextStyle.googleFont(
                                                Colors.grey.shade800,
                                                14,
                                                FontWeight.normal,
                                              ),
                                            )
                                          : Text(
                                              "${addOnsEntity?.price ?? ""} ฿",
                                              style: AppTextStyle.googleFont(
                                                Colors.grey.shade800,
                                                14,
                                                FontWeight.normal,
                                              ),
                                            ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(
          height: 15,
        ),
        TouchableOpacity(
          activeOpacity: 0.5,
          onTap: () async {
            Navigator.pushNamed(
              context,
              PageConst.listOfFilterOption,
              arguments: {
                "id": await di.sl<GetCurrentUidUseCase>().call(),
                "previousRouteName": PageConst.menuDetailPage,
                "dishesEntity": widget.dishesEntity,
              },
            );
          },
          child: Container(
            width: double.maxFinite,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: 7,
              vertical: 2,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.amber.shade900,
              borderRadius: BorderRadius.circular(5),
              // borderRadius:
            ),
            child: Text(
              "+ เพิ่มตัวเลือก",
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

  Padding _buildSwitch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "เปิดให้จำหน่ายตอนนี้ ?",
            style: AppTextStyle.googleFont(
              Colors.white,
              18,
              FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          BlocBuilder<MenuCubit, MenuState>(
            builder: (context, state) {
              if (state is MenuLoadCompleted) {
                final DishesEntity menuDishes = state.dishesList.firstWhere(
                  (element) => element.dishesId == widget.dishesEntity.dishesId,
                );
                return CupertinoSwitch(
                  activeColor: Colors.amber[900],
                  value: menuDishes.isActive!,
                  onChanged: (value) {
                    BlocProvider.of<MenuCubit>(context).updateMenu(
                      widget.dishesEntity.copyWith(
                        isActive: value,
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Column _buildFoodPriceTextFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            "ราคา",
            style: AppTextStyle.googleFont(
              Colors.white,
              20,
              FontWeight.w500,
            ),
          ),
        ),
        Container(
          width: 120,
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: TextFormField(
            controller: menuPrice,
            validator: (value) {
              if (value!.isEmpty) {
                return "โปรดกรอกราคาเมนูของท่าน";
              }
              return null;
            },
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              icon: const Text(
                "฿",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
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
        ),
      ],
    );
  }

  Column _buildFoodDescriptionTextFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            "คำอธิบายรายการ",
            style: AppTextStyle.googleFont(
              Colors.white,
              20,
              FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            "ระบุรายละเอียดของสินค้าให้ครบและชัดเจน",
            style: AppTextStyle.googleFont(
              Colors.grey[400]!,
              16,
              FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: TextFormField(
            controller: menuDescription,
            validator: (value) {
              if (value!.isEmpty) {
                return "โปรดกรอกรายละเอียดเมนูของท่าน";
              }
              return null;
            },
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: "กรอกชื่อรายละเอียดอาหาร เช่น เผ็ดสุดทาง ย่างเข้าป่า",
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
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
        ),
      ],
    );
  }

  Column _buildFoodNameTextFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            "ชื่อรายการ",
            style: AppTextStyle.googleFont(
              Colors.white,
              20,
              FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            "ระบุชื่อสินค้าให้ครบและชัดเจน",
            style: AppTextStyle.googleFont(
              Colors.grey[400]!,
              16,
              FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: TextFormField(
            controller: menuName,
            validator: (value) {
              if (value!.isEmpty) {
                return "โปรดกรอกชื่อเมนูของท่าน";
              }
              return null;
            },
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: "กรอกชื่ออาหาร",
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
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
        ),
      ],
    );
  }

  Widget _buildHaveMenuImage(Size size) {
    return StatefulBuilder(
      builder: (context, setState) => Align(
        alignment: Alignment.topLeft,
        child: Container(
          margin: const EdgeInsets.all(25),
          width: size.width / 1.7,
          height: size.height / 5.8,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                widget.dishesEntity.menuImg!,
              ),
              fit: BoxFit.cover,
            ),
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.amber[900]!,
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              TouchableOpacity(
                onTap: () async {
                  await optionToTakeImage();
                  setState(() {});
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.only(top: 5, right: 5, bottom: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.camera_alt_rounded,
                          size: 20,
                        ),
                        Text(
                          "อัปโหลด",
                          style: AppTextStyle.googleFont(
                            Colors.black,
                            12,
                            FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadedImage(Size size) {
    return StatefulBuilder(
      builder: (context, setState) => Align(
        alignment: Alignment.topLeft,
        child: Container(
          margin: const EdgeInsets.all(25),
          width: size.width / 1.7,
          height: size.height / 5.8,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(
                imageFile!,
              ),
              fit: BoxFit.cover,
            ),
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.amber[900]!,
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              TouchableOpacity(
                onTap: () async {
                  await optionToTakeImage();
                  setState(() {});
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.only(top: 5, right: 5, bottom: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.camera_alt_rounded,
                          size: 20,
                        ),
                        Text(
                          "อัปโหลด",
                          style: AppTextStyle.googleFont(
                            Colors.black,
                            12,
                            FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoImageUpload(Size size) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.all(25),
        width: size.width / 1.7,
        height: size.height / 5.8,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Image.asset(
              "assets/images/no_menu_item.png",
              color: Colors.white,
              scale: 4,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "ยังไม่มีรูปภาพของเมนูอาหาร",
              style: AppTextStyle.googleFont(
                Colors.white,
                14,
                FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TouchableOpacity(
              onTap: () async {
                await optionToTakeImage();
                setState(() {});
              },
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 70,
                  margin: const EdgeInsets.only(top: 5, right: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.camera_alt_rounded,
                        size: 20,
                      ),
                      Text(
                        "อัปโหลด",
                        style: AppTextStyle.googleFont(
                          Colors.black,
                          12,
                          FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future pickImageFromGallery() async {
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file == null) {
        return null;
      } else {
        return File(file.path);
      }
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
    }
  }

  Future pickImageFromCamera() async {
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.camera);
      if (file == null) {
        return null;
      } else {
        return File(file.path);
      }
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
    }
  }

  Future optionToTakeImage() {
    return showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      builder: (context) {
        return Wrap(
          alignment: WrapAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  title: Text(
                    "คลังรูปภาพ",
                    style: AppTextStyle.googleFont(
                      Colors.black,
                      18,
                      FontWeight.normal,
                    ),
                  ),
                  onTap: () async {
                    final File imageFromGallery = await pickImageFromGallery();

                    imageFile = imageFromGallery;
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  leading: const Icon(
                    Icons.photo_library,
                    color: Colors.black,
                  ),
                ),
                const Divider(
                  indent: 10,
                  endIndent: 10,
                  height: 1,
                  color: Colors.black,
                ),
                ListTile(
                  title: Text(
                    "กล้อง",
                    style: AppTextStyle.googleFont(
                      Colors.black,
                      18,
                      FontWeight.normal,
                    ),
                  ),
                  onTap: () async {
                    final File imageFromCamera = await pickImageFromCamera();

                    imageFile = imageFromCamera;
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  leading: const Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
