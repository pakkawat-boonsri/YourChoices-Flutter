// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import 'package:your_choices/injection_container.dart' as di;
import 'package:your_choices/src/config/app_routes/on_generate_routes.dart';
import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';
import 'package:your_choices/src/domain/entities/vendor/filter_options/filter_option_entity.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/get_current_uid_usecase.dart';
import 'package:your_choices/src/presentation/blocs/vendor_bloc/add_filter_in_menu/add_filter_in_menu_cubit.dart';
import 'package:your_choices/src/presentation/blocs/vendor_bloc/add_filter_option/add_filter_option_cubit.dart';
import 'package:your_choices/src/presentation/blocs/vendor_bloc/filter_option/filter_options_cubit.dart';
import 'package:your_choices/src/presentation/widgets/custom_vendor_appbar.dart';
import 'package:your_choices/utilities/hex_color.dart';
import 'package:your_choices/utilities/loading_dialog.dart';
import 'package:your_choices/utilities/text_style.dart';

import '../../../../blocs/vendor_bloc/filter_option/filter_options_state.dart';
import '../../../../blocs/vendor_bloc/filter_option_in_menu/filter_option_in_menu_cubit.dart';

class ListOfFilterOptionView extends StatefulWidget {
  final String id;
  final String previousRouteName;
  final DishesEntity? dishesEntity;
  const ListOfFilterOptionView({
    Key? key,
    required this.id,
    required this.previousRouteName,
    this.dishesEntity,
  }) : super(key: key);

  @override
  State<ListOfFilterOptionView> createState() => _ListOfFilterOptionViewState();
}

class _ListOfFilterOptionViewState extends State<ListOfFilterOptionView> {
  @override
  void initState() {
    BlocProvider.of<FilterOptionCubit>(context)
        .readFilterOption(uid: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar(
        title: "เพิ่มตัวเลือก",
        onTap: () async {
          if (widget.previousRouteName == PageConst.addMenuPage) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              PageConst.addMenuPage,
              arguments: await di.sl<GetCurrentUidUseCase>().call(),
              (route) => route.isFirst,
            );
          } else {
            Navigator.pop(context);
          }
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
              } else if (state is FilterOptionLoadCompleted) {
                List<FilterOptionEntity> filterOptionList =
                    state.filterOptionEntityList;
                return filterOptionList.isEmpty
                    ? NoFilterOptionList(size: size)
                    : HaveFilterOptionList(
                        filterOptionList: filterOptionList,
                        previousRouteName: widget.previousRouteName,
                        dishesEntity: widget.dishesEntity,
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

class HaveFilterOptionList extends StatelessWidget {
  const HaveFilterOptionList({
    Key? key,
    required this.filterOptionList,
    this.previousRouteName,
    this.dishesEntity,
  }) : super(key: key);

  final List<FilterOptionEntity> filterOptionList;
  final String? previousRouteName;
  final DishesEntity? dishesEntity;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: filterOptionList.length,
                itemBuilder: (context, index) {
                  FilterOptionEntity filterOptionEntity =
                      filterOptionList[index];
                  return Card(
                    child: Row(
                      children: [
                        StatefulBuilder(
                          builder: (context, setState) => Expanded(
                            child: CheckboxListTile(
                              activeColor: Colors.amber.shade900,
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              value: filterOptionEntity.isSelected,
                              onChanged: (value) {
                                setState(() {
                                  filterOptionEntity = filterOptionEntity
                                      .copyWith(isSelected: value);
                                });
                                filterOptionEntity.isSelected
                                    ? context
                                        .read<AddFilterOptionCubit>()
                                        .addFilterOption(filterOptionEntity)
                                    : context
                                        .read<AddFilterOptionCubit>()
                                        .removeFilterOption(filterOptionEntity);
                              },
                              title: Text(
                                filterOptionEntity.filterName ?? "no name",
                                style: AppTextStyle.googleFont(
                                  Colors.black,
                                  16,
                                  FontWeight.w500,
                                ),
                              ),
                              subtitle: filterOptionEntity.addOns != null
                                  ? filterOptionEntity.addOns!.isNotEmpty
                                      ? Row(
                                          children: [
                                            const Text("("),
                                            Row(
                                              children: filterOptionEntity
                                                  .addOns!
                                                  .map(
                                                (e) {
                                                  return Text(
                                                    "${e.addonsName}${e == filterOptionEntity.addOns!.last ? "" : ", "}",
                                                  );
                                                },
                                              ).toList(),
                                            ),
                                            const Text(")"),
                                          ],
                                        )
                                      : null
                                  : null,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              PageConst.filterOptionDetailPage,
                              arguments: filterOptionEntity,
                            );
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.amber.shade900,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            loadingDialog(context);
                            BlocProvider.of<FilterOptionCubit>(context)
                                .deleteFilterOption(
                              filterOptionEntity: filterOptionEntity,
                            );
                            Future.delayed(const Duration(seconds: 2))
                                .then((value) {
                              Navigator.pop(context);
                            });
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          Column(
            children: [
              TouchableOpacity(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    PageConst.addOptionPage,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 40,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: "f7ddcd".toColor(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "+ สร้างตัวเลือกใหม่",
                    style: AppTextStyle.googleFont(
                      Colors.amber.shade900,
                      20,
                      FontWeight.w500,
                    ),
                  ),
                ),
              ),
              TouchableOpacity(
                onTap: () async {
                  List<FilterOptionEntity> filterOptionList =
                      context.read<AddFilterOptionCubit>().state;
                  loadingDialog(context);
                  if (previousRouteName == PageConst.menuDetailPage) {
                    context
                        .read<FilterOptionInMenuCubit>()
                        .addFilterOptionInMenu(
                          filterOptionList,
                        );
                  } else {
                    for (var filterOptionEntity in filterOptionList) {
                      context.read<AddFilterInMenuCubit>().addFiltersInMenu(
                            filterOptionEntity: filterOptionEntity,
                          );
                    }
                  }
                  Future.delayed(const Duration(seconds: 1)).then((value) {
                    context.read<AddFilterOptionCubit>().resetFilterOption();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 40,
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 20),
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
        ],
      ),
    );
  }
}

class NoFilterOptionList extends StatelessWidget {
  const NoFilterOptionList({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
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
}
