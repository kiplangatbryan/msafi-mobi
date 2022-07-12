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

  final double iconSize = 25;

  @override
  Widget build(BuildContext context) {
    final router = context.watch<MerchantRoute>();
    return Scaffold(
      body: routes[router.currentPage],
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
          fontSize: 13,
          color: Theme.of(context).primaryColor,
          height: 1.8,
          fontWeight: FontWeight.w600,
        ),
        items: [
          BottomNavigationBarItem(
            label: 'Dashboard',
            icon: Icon(
              Icons.dashboard_outlined,
              color: Theme.of(context).colorScheme.secondary,
              size: iconSize,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Orders',
            icon: Icon(
              Icons.track_changes,
              color: Theme.of(context).colorScheme.secondary,
              size: iconSize,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Chats',
            icon: Icon(
              Icons.notifications_active,
              color: Theme.of(context).colorScheme.secondary,
              size: iconSize,
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
        selectedItemColor: Theme.of(context).primaryColor,
        showSelectedLabels: true,
        currentIndex: router.currentPage,
        selectedIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        onTap: router.setCurrentPage,
      ),
    );
  }
}
