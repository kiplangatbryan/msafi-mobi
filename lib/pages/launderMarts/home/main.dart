import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/configs/data.dart';
import 'package:msafi_mobi/helpers/size_calculator.dart';
import 'package:msafi_mobi/pages/launderMarts/components/util_widgets.dart';
import 'package:msafi_mobi/pages/launderMarts/orders/main.dart';
import 'package:msafi_mobi/pages/launderMarts/orders/single-order.dart';
import 'package:msafi_mobi/pages/launderMarts/settings/main.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../profile/main.dart';

class MerchantHomePage extends StatefulWidget {
  const MerchantHomePage({Key? key}) : super(key: key);

  @override
  State<MerchantHomePage> createState() => _MerchantHomePageState();
}

class _MerchantHomePageState extends State<MerchantHomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  late int page;

  @override
  void initState() {
    super.initState();
    page = _pageController.initialPage;
  }

  double get maxWidth => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: sizeCompute(small: 60, large: 80, width: maxWidth),
            bottom: sizeCompute(small: 20, large: 20, width: maxWidth),
          ),
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            sizeCompute(small: 15, large: 20, width: maxWidth)),
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
                                    fontSize: sizeCompute(
                                        small: 21, large: 24, width: maxWidth),
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              TextSpan(
                                text: "Welcome back",
                                style: GoogleFonts.notoSans(
                                  fontSize: sizeCompute(
                                      small: 16, large: 17, width: maxWidth),
                                  color: Theme.of(context).colorScheme.primary,
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
                              icon: const Icon(
                                Icons.notifications_active_outlined,
                                size: 30,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const MerchantSettings()));
                              },
                              icon: const Icon(
                                Icons.settings_outlined,
                                size: 30,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Column(
                    children: [
                      LimitedBox(
                        maxHeight: 200,
                        child: PageView(
                          pageSnapping: true,
                          controller: _pageController,
                          allowImplicitScrolling: true,

                          onPageChanged: (index) {
                            setState(() {
                              page = index;
                            });
                          },
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: sizeCompute(
                                    small: 15, large: 20, width: maxWidth),
                              ),
                              child: transactionsSummary(context),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: sizeCompute(
                                    small: 15, large: 20, width: maxWidth),
                              ),
                              child: transactionsSummary(context),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          effect: const ExpandingDotsEffect(
                            dotHeight: 11,
                            dotWidth: 11,
                            activeDotColor: kSmoothIndicator,
                            dotColor: kTextLightColor,
                          ),
                          count: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      sizeCompute(small: 15, large: 20, width: maxWidth),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Orders",
                          style: GoogleFonts.notoSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const MerchantOrders(),
                              ),
                            );
                          },
                          child: Text(
                            "view all",
                            style: GoogleFonts.notoSans(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: splashColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ordersSummary(maxWidth),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container transactionsSummary(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      padding: EdgeInsets.symmetric(
        vertical: sizeCompute(small: 18, large: 18, width: maxWidth),
        horizontal: sizeCompute(small: 15, large: 15, width: maxWidth),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            child: Lottie.asset(
              "assets/lottie/relax.json",
              fit: BoxFit.contain,
              width: 180,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Ksh. 400,000.00\n\n",
                      style: GoogleFonts.notoSans(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    TextSpan(
                      text: "Transactions so far.\n",
                      style: GoogleFonts.notoSans(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 180,
                child: customOrderBtn(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ListView ordersSummary(double maxWidth) {
    return ListView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    SingleOrder(order: fetchOrders()[index])));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  padding: EdgeInsets.symmetric(
                    vertical:
                        sizeCompute(small: 18, large: 15, width: maxWidth),
                  ),
                  child: Icon(
                    Icons.history_toggle_off,
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical:
                          sizeCompute(small: 15, large: 15, width: maxWidth),
                      horizontal:
                          sizeCompute(small: 15, large: 15, width: maxWidth),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${fetchOrders()[index]['id']}",
                              style: GoogleFonts.notoSans(
                                fontSize: sizeCompute(
                                    small: 18, large: 19, width: maxWidth),
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${fetchOrders()[index]['total'].toString()} KES",
                              style: GoogleFonts.notoSans(
                                fontSize: sizeCompute(
                                    small: 18, large: 19, width: maxWidth),
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Placed on:",
                              style: GoogleFonts.notoSans(
                                fontSize: sizeCompute(
                                    small: 14, large: 16, width: maxWidth),
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              DateTime.parse(
                                fetchOrders()[index]['expected_pick_up'],
                              ).toMoment().toString(),
                              style: GoogleFonts.notoSans(
                                fontSize: sizeCompute(
                                    small: 14, large: 16, width: maxWidth),
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                "Placed at:",
                                style: GoogleFonts.notoSans(
                                  fontSize: sizeCompute(
                                      small: 14, large: 16, width: maxWidth),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              fetchOrders()[index]['pick_up_station'],
                              style: GoogleFonts.notoSans(
                                fontSize: sizeCompute(
                                    small: 14, large: 16, width: maxWidth),
                                color: kTextMediumColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  GestureDetector customOrderBtn() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.tertiary,
        ),
        child: Center(
          child: Text(
            "View summary",
            style: GoogleFonts.notoSans(
              fontSize: 18.0,
              letterSpacing: 1.3,
              fontWeight: FontWeight.bold,
              color: kTextLight,
              decorationStyle: TextDecorationStyle.wavy,
            ),
          ),
        ),
      ),
    );
  }
}
