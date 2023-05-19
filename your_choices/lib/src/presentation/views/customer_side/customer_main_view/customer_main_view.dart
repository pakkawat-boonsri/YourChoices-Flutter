import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/customer/customer_cubit.dart';
import 'package:your_choices/src/presentation/views/customer_side/customer_order_view/customer_order_view.dart';
import 'package:your_choices/src/presentation/views/customer_side/profile_view/profile_view.dart';
import 'package:your_choices/src/presentation/views/customer_side/restaurant_view/restaurant_list_view/restaurant_list_view.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../home_view/transaction_view/transaction_view.dart';

class CustomerMainView extends StatefulWidget {
  final String uid;
  const CustomerMainView({super.key, required this.uid});

  @override
  State<CustomerMainView> createState() => _CustomerMainViewState();
}

class _CustomerMainViewState extends State<CustomerMainView> {
  int currentIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    BlocProvider.of<CustomerCubit>(context).getSingleCustomer(uid: widget.uid);
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerCubit, CustomerState>(
      builder: (context, state) {
        if (state is CustomerLoaded) {
          final currentCustomer = state.customerEntity;
          return Scaffold(
              body: PageView(
                controller: pageController,
                onPageChanged: onPageChanged,
                children: [
                  TransactionView(customerEntity: currentCustomer),
                  RestaurantListView(customerEntity: currentCustomer),
                  const CustomerOrderView(),
                  ProfileView(customerEntity: currentCustomer),
                ],
              ),
              bottomNavigationBar: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: GNav(
                    selectedIndex: currentIndex,
                    gap: 8,
                    color: Colors.grey,
                    activeColor: Colors.white,
                    tabBackgroundColor: const Color(0xffb44121),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(14),
                    onTabChange: navigationTapped,
                    tabs: const [
                      GButton(
                        icon: Icons.home_sharp,
                        text: "Home",
                      ),
                      GButton(
                        icon: Icons.restaurant_menu_sharp,
                        text: "Restaurant",
                      ),
                      GButton(
                        icon: Icons.history,
                        text: "Order",
                      ),
                      GButton(
                        icon: Icons.person_sharp,
                        text: "Profile",
                      ),
                    ],
                  ),
                ),
              ));
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orangeAccent,
            ),
          );
        }
      },
    );
  }
}
