import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/on_generate_routes.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';

import 'package:your_choices/src/presentation/blocs/vendor/filter_option/filter_option_cubit.dart';
import 'package:your_choices/src/presentation/blocs/vendor/menu/menu_cubit.dart';
import 'package:your_choices/src/presentation/widgets/custom_vendor_appbar.dart';
import 'package:your_choices/utilities/loading_dialog.dart';
import 'package:your_choices/utilities/text_style.dart';
import '../../../../blocs/vendor/filter_option/filter_option_state.dart';

class ListOfFilterOptionView extends StatefulWidget {
  final String uid;
  const ListOfFilterOptionView({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ListOfFilterOptionView> createState() => _ListOfFilterOptionViewState();
}

class _ListOfFilterOptionViewState extends State<ListOfFilterOptionView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<FilterOptionCubit>(context)
        .readFilterOption(uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar(
        title: "เพิ่มตัวเลือก",
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            PageConst.addMenuPage,
            arguments: widget.uid,
            (route) => route.isFirst,
          );
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              "รายการตัวเลือก",
              style: AppTextStyle.googleFont(
                Colors.white,
                26,
                FontWeight.bold,
              ),
            ),
          ),
          BlocBuilder<FilterOptionCubit, FilterOptionState>(
            builder: (context, state) {
              if (state is FilterOptionLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber.shade900,
                  ),
                );
              }
              if (state is FilterOptionLoadCompleted) {
                List<FilterOptionEntity> filterOptionList =
                    state.filterOptionEntityList;
                return filterOptionList.isEmpty
                    ? _buildNoItemInList(context, size)
                    : Expanded(
                        child: SizedBox(
                          child: Column(
                            children: [
                              _buildListOfFilter(filterOptionList, context),
                              const Spacer(),
                              TouchableOpacity(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    PageConst.addOptionPage,
                                  );
                                },
                                child: DottedBorder(
                                  dashPattern: const [7],
                                  color: Colors.white,
                                  strokeWidth: 2,
                                  borderPadding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Container(
                                    width: double.infinity,
                                    height: 40,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      // color: Colors.amber.shade900,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      "เพิ่มตัวเลือก",
                                      style: AppTextStyle.googleFont(
                                        Colors.white,
                                        20,
                                        FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TouchableOpacity(
                                onTap: () async {
                                  loadingDialog(context);
                                  final listOfSelectedFilterOption =
                                      List<FilterOptionEntity>.from(
                                    BlocProvider.of<FilterOptionCubit>(context)
                                        .getFilterOptionList,
                                  );
                                  BlocProvider.of<MenuCubit>(context)
                                      .addFilterOption(
                                          listOfSelectedFilterOption);
                                  Future.delayed(const Duration(seconds: 2));
                                  Navigator.pop(context);
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      PageConst.addMenuPage,
                                      arguments: widget.uid,
                                      (route) => route.isFirst);
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 40,
                                  margin:
                                      const EdgeInsets.fromLTRB(15, 0, 15, 20),
                                  alignment: Alignment.center,
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
                          ),
                        ),
                      );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildNoItemInList(BuildContext context, Size size) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: size.width,
        height: size.height / 3.5,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: const Image(
          image: AssetImage(
            "assets/images/no_menu_item.png",
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Container(
        width: size.width,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          "ไม่มีตัวเลือกสำหรับเพิ่มในรายการอาหารเลย",
          textAlign: TextAlign.center,
          style: AppTextStyle.googleFont(
            Colors.white,
            20,
            FontWeight.w500,
          ),
        ),
      ),
      const SizedBox(
        height: 15,
      ),
      TouchableOpacity(
        activeOpacity: 0.5,
        onTap: () => Navigator.pushNamed(
          context,
          PageConst.addOptionPage,
        ),
        child: Container(
          width: size.width,
          height: size.height * 0.06,
          margin: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
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
  );
}

Widget _buildListOfFilter(
  List<FilterOptionEntity> filterOptionEntityList,
  BuildContext context,
) {
  return ListView.separated(
    physics: const BouncingScrollPhysics(),
    shrinkWrap: true,
    separatorBuilder: (context, index) => const SizedBox(height: 10),
    itemCount: filterOptionEntityList.length,
    itemBuilder: (context, index) {
      FilterOptionEntity filterOptionEntity = filterOptionEntityList[index];

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Checkbox(
                activeColor: Colors.amber.shade900,
                value: filterOptionEntity.isSelected,
                onChanged: (value) {
                  BlocProvider.of<FilterOptionCubit>(context)
                      .updateFilterOption(
                    filterOptionEntity:
                        filterOptionEntity.copyWith(isSelected: value),
                  );

                  if (!filterOptionEntity.isSelected!) {
                    BlocProvider.of<FilterOptionCubit>(context)
                        .addFilterOption(filterOptionEntity);
                  } else {
                    BlocProvider.of<FilterOptionCubit>(context)
                        .removeFilterOption(filterOptionEntity);
                  }
                },
              ),
              filterOptionEntity.addOns != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${filterOptionEntity.filterName}",
                          style: AppTextStyle.googleFont(
                            Colors.black,
                            16,
                            FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "( ",
                              style: AppTextStyle.googleFont(
                                Colors.grey,
                                14,
                                FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: filterOptionEntity.addOns!
                                  .map((addOnsEntity) {
                                int lastIndex =
                                    filterOptionEntity.addOns!.length - 1;
                                bool isLastIndex = filterOptionEntity.addOns!
                                        .indexOf(addOnsEntity) ==
                                    lastIndex;
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    isLastIndex
                                        ? Text(
                                            "${addOnsEntity.addonsName}",
                                            style: AppTextStyle.googleFont(
                                              Colors.grey,
                                              14,
                                              FontWeight.w500,
                                            ),
                                          )
                                        : Text(
                                            "${addOnsEntity.addonsName}, ",
                                            style: AppTextStyle.googleFont(
                                              Colors.grey,
                                              14,
                                              FontWeight.w500,
                                            ),
                                          )
                                  ],
                                );
                              }).toList(),
                            ),
                            Text(
                              ")",
                              style: AppTextStyle.googleFont(
                                Colors.grey,
                                14,
                                FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Text(
                      "${filterOptionEntity.filterName}",
                      style: AppTextStyle.googleFont(
                        Colors.black,
                        16,
                        FontWeight.w500,
                      ),
                    ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  loadingDialog(context).then((value) {
                    Future.delayed(const Duration(seconds: 2));
                  });
                  BlocProvider.of<FilterOptionCubit>(context)
                      .deleteFilterOption(
                    filterOptionEntity: filterOptionEntity,
                  );
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.amber.shade900,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
