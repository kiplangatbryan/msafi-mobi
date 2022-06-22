import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:msafi_mobi/pages/regular/processing/home.dart';
import 'package:msafi_mobi/pages/regular/processing/orders.dart';
import 'package:msafi_mobi/pages/regular/processing/settings.dart';
import 'package:msafi_mobi/themes/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget? _child;

  void initState() {
    _child = HomePageView();
    super.initState();
  }

  void _handleNavigationChange(int index) {
    setState(
      () {
        switch (index) {
          case 0:
            _child = const HomePageView();
            break;
          case 1:
            _child = const OrdersView();
            break;
          case 2:
            _child = const SettingsView();
            break;
        }
        _child = AnimatedSwitcher(
          // switchInCurve: Curves.easeOut,
          // switchOutCurve: Curves.easeIn,
          duration: const Duration(milliseconds: 100),
          
          child: _child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _goback() {
      return Navigator.of(context).pop();
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          bottomOpacity: .3,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.menu, size: 30),
            onPressed: () => print('show menu'),
            color: kTextColor,
          ),
          actions: [],
        ),
        body: _child,
        bottomNavigationBar: FluidNavBar(
          icons: [
            FluidNavBarIcon(
                icon: Icons.home,
                backgroundColor: kSpecialAc,
                extras: {"label": "home"}),
            FluidNavBarIcon(
                icon: Icons.bookmark_border,
                backgroundColor: kSpecialAc,
                extras: {"label": "bookmark"}),
            FluidNavBarIcon(
                icon: Icons.apps,
                backgroundColor: kSpecialAc,
                extras: {"label": "partner"}),
          ],
          onChange: _handleNavigationChange,
          style: const FluidNavBarStyle(
              barBackgroundColor: kPrimaryColor,
              iconBackgroundColor: Colors.white,
              iconSelectedForegroundColor: Colors.white,
              iconUnselectedForegroundColor: Colors.black),
          scaleFactor: 1.5,
          defaultIndex: 0,
          itemBuilder: (icon, item) => Semantics(
            label: icon.extras!["label"],
            child: item,
          ),
        ),
      ),
    );
  }
}
