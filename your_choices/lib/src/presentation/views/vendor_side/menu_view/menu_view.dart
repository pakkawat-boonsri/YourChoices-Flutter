import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/on_generate_routes.dart';
import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';
import 'package:your_choices/src/presentation/widgets/custom_text.dart';
import 'package:your_choices/src/presentation/widgets/custom_vendor_appbar.dart';
import 'package:your_choices/utilities/text_style.dart';

import '../../../blocs/vendor/filter_option/filter_option_cubit.dart';
import '../../../blocs/vendor/menu/menu_cubit.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key, required this.uid});

  final String uid;

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  @override
  void initState() {
    BlocProvider.of<MenuCubit>(context).getMenu(uid: widget.uid);
    BlocProvider.of<MenuCubit>(context).resetFilterOptionList();
    BlocProvider.of<FilterOptionCubit>(context).resetAddOnsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar(
        title: "เมนูอาหาร",
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderTitle(size),
            _buildBlocBody(size),
          ],
        ),
      ),
    );
  }

  Widget _buildBlocBody(Size size) {
    return BlocBuilder<MenuCubit, MenuState>(
      builder: (context, menuState) {
        if (menuState is MenuLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orangeAccent,
            ),
          );
        } else if (menuState is MenuLoadCompleted) {
          List<DishesEntity> dishesEntityList = menuState.dishesEntity;
          return dishesEntityList.isEmpty
              ? Column(
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
                    Text(
                      "คุณยังไม่มีรายการอาหารเลย",
                      style: AppTextStyle.googleFont(
                        Colors.white,
                        26,
                        FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TouchableOpacity(
                      activeOpacity: 0.5,
                      onTap: () => Navigator.pushNamed(
                        context,
                        PageConst.addMenuPage,
                        arguments: widget.uid,
                      ),
                      child: Container(
                        width: size.width,
                        height: size.height * 0.06,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 40,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amber[900],
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "+ เพิ่มเมนูอาหาร",
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
              : Column(
                  children: [
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dishesEntityList.length,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 150,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        DishesEntity dishesEntity = dishesEntityList[index];

                        return TouchableOpacity(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              PageConst.menuDetailPage,
                              arguments: dishesEntity,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                    left: 5,
                                  ),
                                  child: SizedBox(
                                    width: 100,
                                    height: 50,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: dishesEntity.menuImg ?? "",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dishesEntity.menuName ?? "No Name",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: AppTextStyle.googleFont(
                                          Colors.black,
                                          14,
                                          FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        dishesEntity.menuDescription ??
                                            "No Name",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: AppTextStyle.googleFont(
                                          Colors.grey,
                                          14,
                                          FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CustomText(
                                            text: "฿",
                                            color: Colors.amber.shade900,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          CustomText(
                                            text: "${dishesEntity.menuPrice}",
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ],
                                      ),
                                      Transform.scale(
                                        scale: 0.8,
                                        child: CupertinoSwitch(
                                          value: dishesEntity.isActive!,
                                          onChanged: (value) {},
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TouchableOpacity(
                      activeOpacity: 0.5,
                      onTap: () => Navigator.pushNamed(
                        context,
                        PageConst.addMenuPage,
                        arguments: widget.uid,
                      ),
                      child: Container(
                        width: size.width,
                        height: size.height * 0.06,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 40,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amber[900],
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "+ เพิ่มเมนูอาหาร",
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
        } else {
          return Container();
        }
      },
    );
  }

  Padding _buildHeaderTitle(Size size) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        width: size.width,
        child: Text(
          "รายการเมนู",
          style: AppTextStyle.googleFont(
            Colors.white,
            26,
            FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
