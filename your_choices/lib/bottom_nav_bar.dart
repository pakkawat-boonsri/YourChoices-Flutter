import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_choices/view/restaurant_view/restaurant_view.dart';
import 'package:your_choices/view/transaction_view/transaction_view.dart';
import 'package:your_choices/view_model/bottom_nav_view_model/bottom_nav_bar_view_model.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final views = [
    const TransactionView(),
    const RestaurantView(),
  ];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MainViewModel>(context);
    return Scaffold(
      body: SafeArea(child: views[provider.currentIndex]),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: provider.currentIndex,
          selectedItemColor: const Color(0xFFFF9C29),
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              provider.currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant),
              label: "Restaurant",
            ),
          ],
        ),
      ),
    );
  }
}
