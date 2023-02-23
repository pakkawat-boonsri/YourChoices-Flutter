import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_choices/src/presentation/blocs/customer/customer_cubit.dart';
import 'package:your_choices/src/presentation/views/customer_side/favorite_view/favorite_view.dart';
import 'package:your_choices/src/presentation/views/customer_side/notification_view/notification_view.dart';
import 'package:your_choices/src/presentation/views/customer_side/profile_view/profile_view.dart';
import 'package:your_choices/src/presentation/views/customer_side/restaurant_view/restaurant_list_view/restaurant_list_view.dart';
import 'package:your_choices/utilities/text_style.dart';

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
          return SafeArea(
            child: Scaffold(
              body: PageView(
                controller: pageController,
                onPageChanged: onPageChanged,
                children: [
                  TransactionView(customerEntity: currentCustomer),
                  RestaurantView(customerEntity: currentCustomer),
                  const FavoriteView(),
                  const NotificationView(),
                  const ProfileView(),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.shifting,
                currentIndex: currentIndex,
                selectedItemColor: const Color(0xFFFF9C29),
                selectedIconTheme: IconTheme.of(context)
                    .copyWith(color: const Color(0xFFFF9C29)),
                selectedLabelStyle: AppTextStyle.googleFont(
                    Colors.black, 16, FontWeight.normal),
                unselectedItemColor: Colors.grey,
                unselectedIconTheme:
                    IconTheme.of(context).copyWith(color: Colors.grey),
                onTap: navigationTapped,
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
  // else {
  //   return Center(
  //     child: ElevatedButton(
  //       onPressed: () {
  //         context.read<AuthCubit>().loggingOut();
  //       },
  //       child: const Text("Sign Out"),
  //     ),
  //   );
  // }
}
