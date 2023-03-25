import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/get_current_uid_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/upload_image_to_storage_usecase.dart';
import 'package:your_choices/src/presentation/blocs/vendor/menu/menu_cubit.dart';
import 'package:your_choices/src/presentation/widgets/custom_vendor_appbar.dart';
import 'package:your_choices/utilities/loading_dialog.dart';

import '../../../../../../on_generate_routes.dart';
import '../../../../../../utilities/text_style.dart';
import 'package:your_choices/injection_container.dart' as di;

class MenuDetailView extends StatefulWidget {
  final DishesEntity dishesEntity;
  const MenuDetailView({super.key, required this.dishesEntity});

  @override
  State<MenuDetailView> createState() => _MenuDetailViewState();
}

class _MenuDetailViewState extends State<MenuDetailView> {
  late DishesEntity dishesEntity;
  File? imageFile;

  late final TextEditingController menuName;
  late final TextEditingController menuDescription;
  late final TextEditingController menuPrice;
  final _formKey = GlobalKey<FormState>();
  late final bool isActive;
  @override
  void initState() {
    super.initState();
    dishesEntity = widget.dishesEntity;
    isActive = dishesEntity.isActive ?? false;
    menuName = TextEditingController(text: dishesEntity.menuName);
    menuDescription = TextEditingController(text: dishesEntity.menuDescription);
    menuPrice = TextEditingController(text: dishesEntity.menuPrice.toString());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // BlocProvider.of<MenuCubit>(context).getMenu(uid: )
  }

  @override
  void dispose() {
    super.dispose();
    menuName.dispose();
    menuDescription.dispose();
    menuPrice.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar(
        title: "รายละเอียดเมนูอาหาร",
        onTap: () {
          Navigator.pop(context);
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
                  ? dishesEntity.menuImg == null
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
              _buildConfirmAndCancelButton()
            ],
          ),
        ),
      ),
    );
  }

  Row _buildConfirmAndCancelButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TouchableOpacity(
          activeOpacity: 0.5,
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 125,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "ยกเลิก",
                style: AppTextStyle.googleFont(
                  Colors.white,
                  22,
                  FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        TouchableOpacity(
          activeOpacity: 0.5,
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              loadingDialog(context);
              context
                  .read<MenuCubit>()
                  .updateMenu(
                    dishesEntity.copyWith(
                      menuName: menuName.text,
                      menuDescription: menuDescription.text,
                      menuImg: imageFile == null
                          ? dishesEntity.menuImg
                          : await di.sl<UploadImageToStorageUseCase>().call(
                              imageFile!,
                              "menuImages_${dishesEntity.dishesId}"),
                      menuPrice: int.parse(menuPrice.text),
                    ),
                  )
                  .then((value) async {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    PageConst.menuPage,
                    arguments: await di.sl<GetCurrentUidUseCase>().call(),
                    (route) => route.isFirst);
              });
            }
          },
          child: Container(
            width: 125,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.amber[900],
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "บันทึก",
                style: AppTextStyle.googleFont(
                  Colors.white,
                  22,
                  FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterOptionItem(BuildContext context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ตัวเลือก",
                style: AppTextStyle.googleFont(
                  Colors.white,
                  20,
                  FontWeight.w500,
                ),
              ),
              TouchableOpacity(
                activeOpacity: 0.5,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    PageConst.addOptionPage,
                  );
                },
                child: Text(
                  "+ เพิ่มตัวเลือก",
                  style: AppTextStyle.googleFont(
                    Colors.white,
                    20,
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
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const SizedBox(
            height: 5,
          ),
          itemCount: dishesEntity.filterOption?.length ?? 0,
          itemBuilder: (context, index) {
            final filterOptionEntity = dishesEntity.filterOption?[index];

            return TouchableOpacity(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  PageConst.filterOptionDetailPage,
                  arguments: filterOptionEntity,
                );
              },
              child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                margin: const EdgeInsets.symmetric(
                  horizontal: 23,
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
                            filterOptionEntity?.filterName ?? "no name",
                            style: AppTextStyle.googleFont(
                              Colors.black,
                              20,
                              FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          filterOptionEntity!.isRequired == true
                              ? Text(
                                  "(ต้องเลือก)",
                                  style: AppTextStyle.googleFont(
                                    Colors.grey,
                                    14,
                                    FontWeight.w500,
                                  ),
                                )
                              : Text(
                                  "(ไม่จำเป็นต้องเลือก)",
                                  style: AppTextStyle.googleFont(
                                    Colors.grey,
                                    14,
                                    FontWeight.w500,
                                  ),
                                ),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filterOptionEntity.addOns!.length,
                        itemBuilder: (context, index) {
                          final addOnsEntity =
                              filterOptionEntity.addOns?[index];
                          return Container(
                            child: Row(
                              children: [
                                filterOptionEntity.isMultiple == false
                                    ? const Icon(
                                        Icons.circle_outlined,
                                        size: 14,
                                      )
                                    : const Icon(
                                        Icons.rectangle_outlined,
                                        size: 14,
                                      ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  addOnsEntity?.addonsName ?? "no addons",
                                  style: AppTextStyle.googleFont(
                                    Colors.black,
                                    14,
                                    FontWeight.normal,
                                  ),
                                ),
                                const Spacer(),
                                addOnsEntity?.price == null
                                    ? Text(
                                        "0 ฿",
                                        style: AppTextStyle.googleFont(
                                          Colors.black,
                                          14,
                                          FontWeight.normal,
                                        ),
                                      )
                                    : addOnsEntity?.priceType ==
                                            "RadioTypes.priceIncrease"
                                        ? Text(
                                            "+",
                                            style: AppTextStyle.googleFont(
                                              Colors.black,
                                              14,
                                              FontWeight.normal,
                                            ),
                                          )
                                        : Text(
                                            "-",
                                            style: AppTextStyle.googleFont(
                                              Colors.black,
                                              14,
                                              FontWeight.normal,
                                            ),
                                          ),
                                addOnsEntity?.price == null
                                    ? const Text("")
                                    : addOnsEntity?.priceType ==
                                            "RadioTypes.priceIncrease"
                                        ? Text(
                                            "${addOnsEntity?.price ?? ""} ฿",
                                            style: AppTextStyle.googleFont(
                                              Colors.black,
                                              14,
                                              FontWeight.normal,
                                            ),
                                          )
                                        : Text(
                                            "${addOnsEntity?.price ?? ""} ฿",
                                            style: AppTextStyle.googleFont(
                                              Colors.black,
                                              14,
                                              FontWeight.normal,
                                            ),
                                          ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
          CupertinoSwitch(
            activeColor: Colors.amber[900],
            value: dishesEntity.isActive!,
            onChanged: (value) {},
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
          width: 200,
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
            maxLines: 3,
            minLines: 1,
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
                dishesEntity.menuImg!,
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
              scale: 4,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "ยังไม่มีรูปภาพของเมนูอาหาร",
              style: AppTextStyle.googleFont(
                Colors.grey,
                14,
                FontWeight.w400,
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
