import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/injection_container.dart' as di;
import 'package:your_choices/src/config/app_routes/on_generate_routes.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/utilities/upload_image_to_storage_usecase.dart';
import 'package:your_choices/src/presentation/widgets/custom_vendor_appbar.dart';
import 'package:your_choices/utilities/loading_dialog.dart';

import '../../../../../../utilities/text_style.dart';
import '../../../../blocs/vendor_bloc/vendor/vendor_cubit.dart';

class EditRestaurantInfoView extends StatefulWidget {
  final VendorEntity vendorEntity;
  const EditRestaurantInfoView({super.key, required this.vendorEntity});

  @override
  State<EditRestaurantInfoView> createState() => _EditRestaurantInfoViewState();
}

class _EditRestaurantInfoViewState extends State<EditRestaurantInfoView> {
  late VendorEntity vendorEntity;
  late TextEditingController resName;
  late TextEditingController userName;
  late TextEditingController description;
  List<String> restaurantTypes = ["ร้านอาหารตามสั่ง", "ร้านข้าวแกง", "ร้านก๋วยเตี๋ยว", "ร้านเครื่องดื่ม"];
  late String restaurantType;
  File? resImage;
  File? profileImage;
  bool isPickResImageClick = false;
  // bool isPickProfileImageClick = false;

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

                    if (isPickResImageClick) {
                      resImage = imageFromGallery;
                    } else {
                      profileImage = imageFromGallery;
                    }
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

                    if (isPickResImageClick) {
                      resImage = imageFromCamera;
                    } else {
                      profileImage = imageFromCamera;
                    }
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
    vendorEntity = widget.vendorEntity;
    resName = TextEditingController(text: vendorEntity.resName);
    userName = TextEditingController(text: vendorEntity.username);
    description = TextEditingController(text: vendorEntity.description);
    restaurantType = vendorEntity.restaurantType!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar(
        title: "แก้ไขข้อมูลร้านค้า",
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: _buildBody(context, size),
    );
  }

  Widget _buildBody(BuildContext context, Size size) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildResImageWithButton(size),
          _buildProfileImageWithButton(),
          _buildUpdateResName(size),
          _buildUpdateResDescription(size),
          _buildUpdateResUsername(size),
          _buildUpdateDropdownType(size),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(
              thickness: 1,
              color: Colors.grey,
            ),
          ),
          _buildConfirmOrCancel(size),
        ],
      ),
    );
  }

  Container _buildUpdateResName(Size size) {
    return Container(
      width: size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ชื่อร้านอาหาร",
            style: AppTextStyle.googleFont(
              Colors.white,
              18,
              FontWeight.w500,
            ),
          ),
          Text(
            "ระบุชื่อร้านค้าให้ครบและชัดเจน",
            style: AppTextStyle.googleFont(
              Colors.grey,
              16,
              FontWeight.normal,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            style: AppTextStyle.googleFont(
              Colors.white,
              16,
              FontWeight.w500,
            ),
            controller: resName,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              isDense: true,
              hintText: "ชื่อร้านค้าของท่าน",
              hintStyle: const TextStyle(color: Colors.grey),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.amber.shade900,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.amber.shade900,
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildUpdateResUsername(Size size) {
    return Container(
      width: size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ชื่อผู้ใช้",
            style: AppTextStyle.googleFont(
              Colors.white,
              18,
              FontWeight.w500,
            ),
          ),
          Text(
            "ระบุชื่อของคุณให้ครบและชัดเจน",
            style: AppTextStyle.googleFont(
              Colors.grey,
              16,
              FontWeight.normal,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            style: AppTextStyle.googleFont(
              Colors.white,
              16,
              FontWeight.w500,
            ),
            controller: userName,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              isDense: true,
              hintText: "ชื่อร้านค้าของท่าน",
              hintStyle: const TextStyle(color: Colors.grey),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.amber.shade900,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.amber.shade900,
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildUpdateResDescription(Size size) {
    return Container(
      width: size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "รายละเอียดร้านค้า",
            style: AppTextStyle.googleFont(
              Colors.white,
              18,
              FontWeight.w500,
            ),
          ),
          Text(
            "กรอกรายละเอียดร้านค้าให้ครบและชัดเจน",
            style: AppTextStyle.googleFont(
              Colors.grey,
              16,
              FontWeight.normal,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            style: AppTextStyle.googleFont(
              Colors.white,
              16,
              FontWeight.w500,
            ),
            controller: description,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              isDense: true,
              hintText: "รายละเอียดร้านของท่าน",
              hintStyle: const TextStyle(color: Colors.grey),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.amber.shade900,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.amber.shade900,
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildUpdateDropdownType(Size size) {
    return Container(
      width: size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ประเภทร้านค้า",
            style: AppTextStyle.googleFont(
              Colors.white,
              18,
              FontWeight.w500,
            ),
          ),
          Text(
            "ระบุประเภทร้านอาหารของคุณให้ชัดเจน",
            style: AppTextStyle.googleFont(
              Colors.grey,
              16,
              FontWeight.normal,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          StatefulBuilder(
            builder: (context, setState) => Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.amber.shade900,
                ),
              ),
              child: DropdownButton(
                style: AppTextStyle.googleFont(
                  Colors.white,
                  16,
                  FontWeight.w500,
                ),
                dropdownColor: const Color(0xFF34312f),
                iconSize: 32,
                iconEnabledColor: Colors.white,
                underline: Container(),
                value: restaurantType,
                items: restaurantTypes
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    restaurantType = value ?? "";
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImageWithButton() {
    return StatefulBuilder(
      builder: (context, setState) => Column(
        children: [
          Stack(
            children: [
              profileImage == null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.transparent,
                        backgroundImage: vendorEntity.profileUrl == null
                            ? const AssetImage("assets/images/image_picker.png") as ImageProvider
                            : CachedNetworkImageProvider(vendorEntity.profileUrl!),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.transparent,
                        backgroundImage: FileImage(profileImage!),
                      ),
                    ),
              Positioned(
                left: 80,
                top: 100,
                child: TouchableOpacity(
                  onTap: () async {
                    await optionToTakeImage();
                    setState(() {});
                  },
                  child: Container(
                    width: 40,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "เลือกรูปโปรไฟล์",
            style: AppTextStyle.googleFont(
              Colors.amber.shade900,
              12,
              FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResImageWithButton(Size size) {
    return StatefulBuilder(
      builder: (context, setState) => Container(
        width: size.width,
        height: 170,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: resImage == null
                ? CachedNetworkImageProvider(
                    vendorEntity.resProfileUrl!,
                  )
                : FileImage(
                    resImage!,
                  ) as ImageProvider,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              TouchableOpacity(
                onTap: () async {
                  isPickResImageClick = true;
                  await optionToTakeImage();
                  setState(() {});
                  isPickResImageClick = false;
                  log("isPickResImageClick: $isPickResImageClick");
                },
                child: Container(
                  width: 75,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.camera_alt,
                      ),
                      Text(
                        "แก้ไข",
                        style: AppTextStyle.googleFont(
                          Colors.black,
                          16,
                          FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmOrCancel(Size size) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      width: size.width,
      child: Row(
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
              loadingDialog(context);
              await BlocProvider.of<VendorCubit>(context)
                  .updateRestaurantInfo(
                vendorEntity.copyWith(
                  username: userName.text,
                  resName: resName.text,
                  description: description.text,
                  restaurantType: restaurantType,
                  resProfileUrl: resImage == null
                      ? vendorEntity.resProfileUrl
                      : await di.sl<UploadImageToStorageUseCase>().call(resImage!, "resProfileImage"),
                  profileUrl: profileImage == null
                      ? vendorEntity.profileUrl
                      : await di.sl<UploadImageToStorageUseCase>().call(profileImage!, "profileImage"),
                ),
              )
                  .then((value) {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                    context, PageConst.vendorMainView, arguments: vendorEntity.uid, (route) => false);
              });
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
      ),
    );
  }
}
