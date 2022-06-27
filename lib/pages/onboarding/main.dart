import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'components/onboard_view.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController(initialPage: 0);
  late int page;

  @override
  void initState() {
    super.initState();
    page = _pageController.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            page < 2
                ? Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        0,
                        20,
                        10,
                        0,
                      ),
                      child: TextButton(
                        onPressed: () {
                          print("skipping");
                        },
                        child: Text(
                          "SKIP",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: splashColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  page = index;
                });
              },
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const OnBoardingView(
                  title: "24Hrs Delivery Service",
                  lotieAsset: 'delivery.json',
                  highlight:
                      'Free delivery for your laundry basket at your doorstep anytime',
                  hasBtn: false,
                ),
                const OnBoardingView(
                  title: "Doing the heavy lifting",
                  lotieAsset: 'relax.json',
                  highlight:
                      'Take a break from buying shampoo and washing, we\'ve got you',
                  hasBtn: false,
                ),
                const OnBoardingView(
                  title: "What Are\nYou Waiting For",
                  lotieAsset: 'ride.json',
                  highlight:
                      'Hop on and lets take a look see, promise you gonna enjoy it',
                  hasBtn: true,
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: SmoothPageIndicator(
                  controller: _pageController,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: kSmoothIndicator,
                    dotColor: kTextLightColor,
                  ),
                  count: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
