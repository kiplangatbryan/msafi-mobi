import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/components/snackback_component.dart';
import 'package:msafi_mobi/configs/data.dart';
import 'package:msafi_mobi/helpers/size_calculator.dart';
import 'package:msafi_mobi/pages/launderMarts/components/util_widgets.dart';
import 'package:msafi_mobi/pages/launderMarts/orders/main.dart';
import 'package:msafi_mobi/pages/launderMarts/orders/single-order.dart';
import 'package:msafi_mobi/pages/launderMarts/settings/main.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:http/http.dart' as http;

import '../../../helpers/http_services.dart';
import '../../../providers/merchant.provider.dart';
import '../../../providers/user.provider.dart';
import '../components/single_order.dart';
import '../profile/main.dart';

class MerchantHomePage extends StatelessWidget {
  const MerchantHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(
            // top: sizeCompute(small: 60, large: 80, width: maxWidth),
            bottom: 0,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  bottom: 70,
                  top: 50,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Good Afternoon\n",
                            style: GoogleFonts.notoSans(
                              fontSize: 21,
                              color: Theme.of(context).backgroundColor,
                            ),
                          ),
                          TextSpan(
                            text: "Welcome  ",
                            style: GoogleFonts.notoSans(
                              fontSize: 18,
                              height: 1.6,
                              color: Theme.of(context)
                                  .backgroundColor
                                  .withOpacity(.8),
                            ),
                          ),
                          TextSpan(
                            text: context.read<User>().name,
                            style: GoogleFonts.notoSans(
                              fontSize: 18,
                              color: Theme.of(context).backgroundColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.notifications_active_outlined,
                            size: 30,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(.8),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) =>
                                    const MerchantSettings()));
                          },
                          icon: Icon(
                            Icons.settings_outlined,
                            size: 30,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(.8),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -45),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 30,
                    bottom: 100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Find An Order or Basket\n",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                            ),
                            TextSpan(
                              text: "Enter a basket number",
                              style: GoogleFonts.notoSans(
                                fontSize: 16,
                                height: 1.6,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: CustomSearchField(
                              onTapped: () {
                                context.read<MerchantRoute>().setCurrentPage(1);
                                context
                                    .read<MerchantRoute>()
                                    .setAutoFocusState(true);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(60),
                            ),
                            height: 60,
                            width: 60,
                            child: Center(
                              child: Icon(
                                Icons.search_rounded,
                                size: 35,
                                color: Theme.of(context).backgroundColor,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -100),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 25,
                          right: 25,
                          top: 30,
                          bottom: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Statistics",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                StatsBadges(
                                  icon: Icon(
                                    Icons.swap_vert_outlined,
                                    size: 40,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.7),
                                  ),
                                  title: "Earnings",
                                  value: "+ 10,100.00",
                                ),
                                StatsBadges(
                                  icon: Icon(
                                    Icons.receipt_long,
                                    size: 40,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.7),
                                  ),
                                  title: "Orders",
                                  value: "+ 544",
                                ),
                                StatsBadges(
                                  icon: Icon(
                                    Icons.home_max_outlined,
                                    size: 40,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.7),
                                  ),
                                  title: "Stations",
                                  value: "3",
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            storeStats(context),
                          ],
                        ),
                      ),
                      const RecentOrders(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row storeStats(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Recent Orders",
          style: Theme.of(context).textTheme.headline6,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => const MerchantOrders(),
              ),
            );
          },
          child: Text(
            "View all",
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ),
      ],
    );
  }
}

class RecentOrders extends StatefulWidget {
  const RecentOrders({
    Key? key,
  }) : super(key: key);

  @override
  State<RecentOrders> createState() => _RecentOrdersState();
}

class _RecentOrdersState extends State<RecentOrders> {
  bool loading = false;
  List orderList = [];
  late final NUMBER_OF_ORDERS;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  _fetchOrders() async {
    final storeId = context.read<MartConfig>().id;
    var url = Uri.parse('${baseUrl()}/store/fetchOrders/$storeId');
    setState(() {
      loading = true;
    });
    String authToken = await checkAndValidateAuthToken(context);
    if (authToken == "NaN") {
      // throw an error
      customSnackBar(
          context: context, message: "Invalid refreshToken", onPressed: () {});
      return;
    }

    try {
      // send data to server
      final response = await http.get(url, headers: {
        "Authorization": "Bearer $authToken",
      }).timeout(
        const Duration(seconds: 10),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          if (data.length > 10) {
            NUMBER_OF_ORDERS = 10;
          } else {
            NUMBER_OF_ORDERS = data.length;
          }
          orderList = data;
        });
      } else {
        customSnackBar(
            context: context, message: "Server Error", onPressed: () {});
      }
    } on SocketException {
      customSnackBar(
          context: context,
          message: "Could not connect to server!",
          onPressed: () {});
    } on TimeoutException catch (e) {
      customSnackBar(
          context: context, message: "Connection timed out!", onPressed: () {});
    } on Error catch (e) {
      customSnackBar(
          context: context, message: "An error occurred", onPressed: () {});
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? SizedBox(
            child: Center(
              child: Lottie.asset(
                "assets/lottie/circular-loading.json",
                height: 150,
                fit: BoxFit.contain,
              ),
            ),
          )
        : orderList.isEmpty
            ? SizedBox(
                child: Column(
                  children: [
                    Lottie.asset(
                      "assets/lottie/sent-email-animation.json",
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "You don't have any orders yet",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: List.generate(
                    NUMBER_OF_ORDERS,
                    (index) {
                      final order = orderList[index];
                      return SingleOrderComponent(
                        order: order,
                        customerName: order['userId']['name'],
                        status: order['status'],
                        orderId: order['id'],
                        stationName: order['stationId']['name'],
                        expectedDate: order['expectedPickUp'],
                      );
                    },
                  ),
                ),
              );
  }
}

class StatsBadges extends StatelessWidget {
  String title;
  String value;
  Icon icon;
  StatsBadges({
    required this.title,
    required this.value,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(.04),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(
                height: 10,
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 14,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class CustomSearchField extends StatelessWidget {
  final onTapped;
  const CustomSearchField({
    required this.onTapped,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTapped,
      cursorColor: kTextColor,
      cursorHeight: 20,
      keyboardType: TextInputType.text,
      style: GoogleFonts.notoSans(
        color: kTextColor,
        fontWeight: FontWeight.w600,
        fontSize: 17,
      ),
      decoration: InputDecoration(
        hintText: "Enter order number",
        filled: true,
        fillColor: kDigital,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: const EdgeInsets.fromLTRB(20, 18, 0, 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
          gapPadding: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
          gapPadding: 10,
        ),
      ),
    );
  }
}
