import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_choices/view/restaurant_view/restaurant_view.dart';
import 'package:your_choices/view/transaction_view/transaction_view.dart';
import 'package:your_choices/view_model/main_view_model/main_view_model.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
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
