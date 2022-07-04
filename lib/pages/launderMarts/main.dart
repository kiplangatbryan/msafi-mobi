import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/pages/launderMarts/profile/main.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:provider/provider.dart';

import '../../providers/merchant.provider.dart';
import 'home/main.dart';
import 'notifications/main.dart';
import 'orders/main.dart';
import 'settings/main.dart';

class MerchantHome extends StatefulWidget {
  const MerchantHome({Key? key}) : super(key: key);

  @override
  State<MerchantHome> createState() => _MerchantHomeState();
}

class _MerchantHomeState extends State<MerchantHome> {
  List<Widget> routes = const [
    MerchantHomePage(),
    MerchantOrders(),
    NotificationsScreen(),
    AccountSettings(),
  ];
  Widget _currentPage = Container();
  dynamic merchantRoute;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentPage = routes[_count];
    });
    merchantRoute = context.read<MerchantRoute>();
    _count = merchantRoute.current;
  }

  _handleNavigation(index) {
    // update global  state
    merchantRoute.setCurrentPage(index);
    setState(() {
      // read from global state
      _count = merchantRoute.current;
      _currentPage = routes[_count];
      // set the current index to the index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPage,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 50,
        enableFeedback: true,
        showUnselectedLabels: true,
        unselectedLabelStyle: GoogleFonts.notoSans(
          fontSize: 12,
          color: kTextMediumColor,
          height: 1.2,
          fontWeight: FontWeight.w600,
        ),
        unselectedItemColor: kTextMediumColor,
        selectedLabelStyle: GoogleFonts.notoSans(
          fontSize: 16,
          color: Theme.of(context).colorScheme.tertiary,
          height: 1.8,
          fontWeight: FontWeight.w600,
        ),
        items: [
          BottomNavigationBarItem(
            label: 'Dashboard',
            icon: Icon(
              Icons.dashboard_outlined,
              color: Theme.of(context).colorScheme.secondary,
              size: 28,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Orders',
            icon: Icon(
              Icons.track_changes,
              color: Theme.of(context).colorScheme.secondary,
              size: 28,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Chats',
            icon: Icon(
              Icons.notifications_active,
              color: Theme.of(context).colorScheme.secondary,
              size: 28,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            tooltip: "Profile",
            icon: Icon(
              Icons.person_outline_outlined,
              color: Theme.of(context).colorScheme.secondary,
              size: 28,
            ),
          ),
        ],
        selectedItemColor: Theme.of(context).colorScheme.tertiary,
        showSelectedLabels: true,
        currentIndex: _count,
        selectedIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.tertiary,
        ),
        onTap: _handleNavigation,
      ),
    );
  }
}
