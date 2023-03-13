import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/on_generate_routes.dart';
import 'package:your_choices/src/presentation/blocs/vendor/vendor_cubit.dart';

import '../../../../../utilities/text_style.dart';
import '../../../widgets/custom_vendor_appbar.dart';

class AddMenuView extends StatefulWidget {
  const AddMenuView({super.key, required this.uid});
  final String uid;
  @override
  State<AddMenuView> createState() => _AddMenuViewState();
}

class _AddMenuViewState extends State<AddMenuView> {
  File? imageFile;

  bool isToggle = false;

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

  @override
  void initState() {
    super.initState();
    BlocProvider.of<VendorCubit>(context).getSingleVendor(uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar(
        title: "เพิ่มเมนูอาหาร",
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageFile == null
                ? _buildNoImageUpload(size)
                : _buildUploadedImage(size),
            _buildFoodNameTextField(),
            const SizedBox(
              height: 12,
            ),
            _buildFoodDescriptionTextField(),
            const SizedBox(
              height: 12,
            ),
            _buildFoodPrice(),
            const SizedBox(
              height: 15,
            ),
            _buildSwitch(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Divider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    "ตัวเลือก",
                    style: AppTextStyle.googleFont(
                      Colors.white,
                      20,
                      FontWeight.w500,
                    ),
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 5,
                  ),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      color: Colors.white,
                    );
                  },
                ),
                TouchableOpacity(
                  activeOpacity: 0.5,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      PageConst.addOptionPage,
                    );
                  },
                  child: Container(
                    width: size.width / 2,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 10,
                    ),
                    height: size.height * 0.05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.amber[900],
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "+ เพิ่มตัวเลือก",
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
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Divider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TouchableOpacity(
                  activeOpacity: 0.5,
                  onTap: () {},
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
                  onTap: () {},
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
                        "ยืนยัน",
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
            )
          ],
        ),
      ),
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
            value: isToggle,
            onChanged: (value) => setState(() {
              isToggle = value;
            }),
          ),
        ],
      ),
    );
  }

  Column _buildFoodPrice() {
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
          child: TextField(
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

  Column _buildFoodDescriptionTextField() {
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
          child: TextField(
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

  Column _buildFoodNameTextField() {
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
          child: TextField(
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
}
