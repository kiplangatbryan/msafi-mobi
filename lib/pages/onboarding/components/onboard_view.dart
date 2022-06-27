import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:msafi_mobi/themes/main.dart';

import 'btn_links.dart';

class OnBoardingView extends StatelessWidget {
  final String title;
  final String lotieAsset;
  final String highlight;
  final bool hasBtn;

  const OnBoardingView({
    required this.title,
    required this.lotieAsset,
    required this.highlight,
    required this.hasBtn,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        30,
        0,
        25,
        25,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Lottie.asset(
            "assets/lottie/$lotieAsset",
            width: 380,
          ),
          const SizedBox(
            height: 30,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$title\n\n",
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    color: kTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "$highlight\n",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: kTextMediumColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          hasBtn
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    NavButtons(
                      title: "Get Started",
                      icon: Icon(
                        Icons.arrow_forward_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
