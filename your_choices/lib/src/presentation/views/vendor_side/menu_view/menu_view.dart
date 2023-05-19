import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/src/config/app_routes/on_generate_routes.dart';
import 'package:your_choices/src/domain/entities/vendor/dishes_menu/dishes_entity.dart';
import 'package:your_choices/src/presentation/blocs/vendor_bloc/add_filter_in_menu/add_filter_in_menu_cubit.dart';
import 'package:your_choices/src/presentation/blocs/vendor_bloc/menu/menu_cubit.dart';
import 'package:your_choices/src/presentation/blocs/vendor_bloc/menu/menu_state.dart';
import 'package:your_choices/src/presentation/widgets/custom_vendor_appbar.dart';
import 'package:your_choices/utilities/text_style.dart';

import '../../../blocs/vendor_bloc/filter_option_in_menu/filter_option_in_menu_cubit.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key, required this.uid});

  final String uid;

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MenuCubit>(context).getMenu(uid: widget.uid);
    BlocProvider.of<AddFilterInMenuCubit>(context).resetFiltersInMenu();
    BlocProvider.of<FilterOptionInMenuCubit>(context)
        .resetDeleteFilterOptionInMenu();
  }

  @override
  void didChangeDependencies() {
    BlocProvider.of<MenuCubit>(context).getMenu(uid: widget.uid);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar(
        title: "เมนูอาหาร",
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
              context,
              PageConst.vendorMainView,
              arguments: widget.uid,
              (route) => false);
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
          return menuState.dishesList.isEmpty
              ? _buildNoMenuItem(size, context)
              : _buildListOfMenuItem(menuState.dishesList, context, size);
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Column _buildListOfMenuItem(
    List<DishesEntity> dishesEntityList,
    BuildContext context,
    Size size,
  ) {
    return Column(
      children: [
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: dishesEntityList.length,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 170,
          ),
          itemBuilder: (BuildContext context, int index) {
            DishesEntity dishesEntity = dishesEntityList[index];
            return TouchableOpacity(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  PageConst.menuDetailPage,
                  arguments: {
                    "uid": widget.uid,
                    "dishesEntity": dishesEntity,
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
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
                        width: 166,
                        height: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: dishesEntity.menuImg != null &&
                                  dishesEntity.menuImg != ""
                              ? CachedNetworkImage(
                                  imageUrl: dishesEntity.menuImg!,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.grey,
                                  child: Image.asset(
                                    "assets/images/no_menu_item.png",
                                    color: Colors.white,
                                  ),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            dishesEntity.menuDescription ?? "No Name",
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
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "฿",
                            style: AppTextStyle.googleFont(
                              Colors.amber.shade900,
                              14,
                              FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${dishesEntity.menuPrice}",
                            style: AppTextStyle.googleFont(
                              Colors.black,
                              14,
                              FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              activeColor: Colors.amber.shade900,
                              value: dishesEntity.isActive!,
                              onChanged: (value) {
                                context.read<MenuCubit>().updateMenu(
                                      dishesEntity.copyWith(
                                        isActive: value,
                                      ),
                                    );
                              },
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
              horizontal: 15,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
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
  }

  Column _buildNoMenuItem(Size size, BuildContext context) {
    return Column(
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
              horizontal: 15,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
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
