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
                  title: "We Are Available Full Time",
                  lotieAsset: 'delivery.json',
                  highlight:
                      'Free delivery for your laundry basket at your available for 24hrs',
                  hasBtn: false,
                ),
                const OnBoardingView(
                  title: "Let Us Worry About Everything",
                  lotieAsset: 'relax.json',
                  highlight:
                      'Take a break from buying shampoo and washing, we\'ve got you',
                  hasBtn: false,
                ),
                const OnBoardingView(
                  title: "What Are\nYou Waiting For",
                  lotieAsset: 'ride.json',
                  highlight:
                      'Hop on and lets take a look see,We promise you gonna enjoy it',
                  hasBtn: true,
                ),
              ],
            ),
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
                          setState(() {
                            _pageController.jumpToPage(2);
                          });
                        },
                        child: Text(
                          "SKIP",
                          style: GoogleFonts.notoSans(
                            fontSize: 18,
                            color: splashColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
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
