import 'package:flutter/material.dart';
import 'package:your_choices/view/Favorite_view.dart';
import 'package:your_choices/view/restuarant_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var currentIndex = 0;

  List<Widget> pages = [
    const HomeView(),
    const RestuarantView(),
    const FavoriteView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFFFF9c29),
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: "Restuarant",
          ),
        ],
      ),
    );
  }
}
