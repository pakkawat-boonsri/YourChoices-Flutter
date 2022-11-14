import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_choices/constants/text_style.dart';
import 'package:your_choices/src/bottom_navbar_screen/view_model/bottom_nav_bar_view_model.dart';

class BottomNavBarView extends StatefulWidget {
  const BottomNavBarView({super.key});

  @override
  State<BottomNavBarView> createState() => _BottomNavBarViewState();
}

class _BottomNavBarViewState extends State<BottomNavBarView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<BottomNavBarViewModel>(
          builder: (context, value, child) {
            return value.views[value.currentIndex];
          },
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
          child: BottomNavigationBar(
            // elevation: 10,

            type: BottomNavigationBarType.shifting,
            currentIndex: context.watch<BottomNavBarViewModel>().currentIndex,
            selectedItemColor: const Color(0xFFFF9C29),
            selectedIconTheme:
                IconTheme.of(context).copyWith(color: const Color(0xFFFF9C29)),
            selectedLabelStyle:
                AppTextStyle.googleFont(Colors.black, 16, FontWeight.normal),
            unselectedItemColor: Colors.grey,
            unselectedIconTheme:
                IconTheme.of(context).copyWith(color: Colors.grey),
            onTap: (index) {
              context.read<BottomNavBarViewModel>().setcurrentIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_sharp),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_menu_sharp),
                label: "Restaurant",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_sharp),
                label: "Favorite",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_sharp),
                label: "Notification",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_sharp),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
