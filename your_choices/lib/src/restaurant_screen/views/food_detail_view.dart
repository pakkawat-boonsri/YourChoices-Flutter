import 'package:flutter/material.dart';
import 'package:your_choices/constants/text_style.dart';
import 'package:your_choices/src/restaurant_screen/model/restaurant_model.dart';

class FoodDetailView extends StatefulWidget {
  final Foods foods;
  const FoodDetailView({
    super.key,
    required this.foods,
  });

  @override
  State<FoodDetailView> createState() => _FoodDetailViewState();
}

class _FoodDetailViewState extends State<FoodDetailView> {
  List<AddOns>? checkboxList = [];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final food = widget.foods;
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              _buildSliverAppbar(context, size, food),
            ];
          },
          body: _buildAddOns(size, food.addOns, checkboxList),
        ),
      ),
    );
  }

  _buildAddOns(Size size, List<AddOns>? addons, List<AddOns>? checkboxList) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Container(
                width: size.width,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "แอดออนที่จะบวกเพิ่ม",
                        style: AppTextStyle.googleFont(
                          Colors.black,
                          20,
                          FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "เลือกได้มากกว่า 1 อย่าง",
                        style: AppTextStyle.googleFont(
                          Colors.grey,
                          16,
                          FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 5,
                        ),
                        itemCount: addons?.length ?? 0,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: addons?[index].isChecked,
                                      onChanged: (value) {
                                        // log("${addons?[index].isChecked}");
                                        // log("ontap");
                                        setState(() {
                                          final result =
                                              addons?[index].isChecked = value!;
                                          checkboxList?.add(
                                            addons![index]
                                                .copyWith(isChecked: result),
                                          );
                                        });
                                      },
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      addons?[index].addonsType ?? "",
                                      style: AppTextStyle.googleFont(
                                        Colors.black,
                                        18,
                                        FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "฿${addons?[index].price ?? 0}",
                                  style: AppTextStyle.googleFont(
                                    Colors.black,
                                    18,
                                    FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(
                          color: Colors.black,
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "คำข้อเพิ่มเติม",
                            style: AppTextStyle.googleFont(
                                Colors.black, 18, FontWeight.w500),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  strokeAlign: StrokeAlign.center,
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  strokeAlign: StrokeAlign.center,
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                              hintText:
                                  "เผ็ดๆๆๆๆ เผ็ดมากๆๆ เผ็ดแบบเผ็ดตายไปเลย",
                              hintStyle: AppTextStyle.googleFont(
                                Colors.grey,
                                15,
                                FontWeight.w500,
                              ),
                              contentPadding: const EdgeInsets.all(15),
                            ),
                          ),
                        ],
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

  SliverAppBar _buildSliverAppbar(BuildContext context, Size size, Foods food) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: _buildBackArrow(context),
      pinned: true,
      // expandedHeight: size.height * 0.288,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          alignment: Alignment.bottomCenter,
          food.menuImg!,
          fit: BoxFit.cover,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.288),
        child: _buildTitle(size, food),
      ),
    );
  }

  _buildTitle(Size size, Foods food) {
    return Container(
      width: size.width,
      height: size.height * 0.151,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${food.menuName}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.googleFont(
                Colors.black,
                36,
                FontWeight.bold,
              ),
            ),
            Text(
              "${food.menuDescription}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.googleFont(
                Colors.grey,
                14,
                FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackArrow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Material(
          borderRadius: BorderRadius.circular(100),
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () {
              Navigator.pop(context);
            },
            child: const SizedBox(
              width: 30,
              height: 30,
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
