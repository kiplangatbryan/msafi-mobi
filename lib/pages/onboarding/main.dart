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
                        onPressed: () {},
                        child: Text(
                          "Skip",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: splashColor,
                            fontWeight: FontWeight.bold,
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
                  title: "Laundry Basket\nDelivery Service",
                  imgUrl: '091.png',
                  highlight: 'FREE',
                  hasBtn: false,
                ),
                const OnBoardingView(
                  title: "Laundry\nService On Hand",
                  imgUrl: '054.png',
                  highlight: 'AVAILABLE',
                  hasBtn: false,
                ),
                const OnBoardingView(
                  title: "What Are\nYou Waiting For",
                  imgUrl: '091.png',
                  highlight: 'Let\'s go',
                  hasBtn: true,
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: SmoothPageIndicator(
                  controller: _pageController,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: kSmoothIndicator,
                    dotColor: kTextLightColor,
                    dotHeight: 12,
                    dotWidth: 12,
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
