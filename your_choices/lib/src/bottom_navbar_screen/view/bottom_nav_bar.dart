import 'package:flutter/material.dart';
import 'package:your_choices/utilities/text_style.dart';
import 'package:your_choices/src/favorite_screen/view/favorite_view.dart';
import 'package:your_choices/src/notification_screen/views/notification_view.dart';
import 'package:your_choices/src/profile_screen/views/profile_view.dart';
import 'package:your_choices/src/presentation/views/restaurant_view/restaurant_list_view/restaurant_list_view.dart';

import '../../presentation/views/home_view/transaction_view/transaction_view.dart';

class BottomNavBarView extends StatefulWidget {
  const BottomNavBarView({super.key});

  @override
  State<BottomNavBarView> createState() => _BottomNavBarViewState();
}

class _BottomNavBarViewState extends State<BottomNavBarView> {
  late int currentIndex;
  final views = [
    const TransactionView(),
    const RestaurantView(),
    const FavoriteView(),
    const NotificationView(),
    const ProfileView(),
  ];

  @override
  void initState() {
    currentIndex = 0;
    super.initState();
  }

  @override
  void dispose() {
    currentIndex;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: views[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: currentIndex,
          selectedItemColor: const Color(0xFFFF9C29),
          selectedIconTheme:
              IconTheme.of(context).copyWith(color: const Color(0xFFFF9C29)),
          selectedLabelStyle:
              AppTextStyle.googleFont(Colors.black, 16, FontWeight.normal),
          unselectedItemColor: Colors.grey,
          unselectedIconTheme:
              IconTheme.of(context).copyWith(color: Colors.grey),
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
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
    );
  }
}
