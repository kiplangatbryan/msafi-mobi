import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/themes/main.dart';

import 'btn_links.dart';

class OnBoardingView extends StatelessWidget {
  final String title;
  final String imgUrl;
  final String highlight;
  final bool hasBtn;

  const OnBoardingView({
    required this.title,
    required this.imgUrl,
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
          Image(
            image: AssetImage('assets/images/$imgUrl'),
            height: 300,
          ),
          const SizedBox(
            height: 30,
          ),
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$highlight\n",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: splashColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: title,
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    color: kTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          hasBtn
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    NavButtons(
                      title: "Login",
                      fade: false,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    NavButtons(
                      title: "Sign up",
                      fade: true,
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
