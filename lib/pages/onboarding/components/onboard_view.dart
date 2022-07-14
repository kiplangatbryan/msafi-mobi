import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/themes/main.dart';

import '../login_options.dart';
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
          LimitedBox(
            maxHeight: (MediaQuery.of(context).size.height / 2 - 100),
            child: Lottie.asset(
              "assets/lottie/$lotieAsset",
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$title\n\n",
                  style: GoogleFonts.notoSans(
                    fontSize: 28,
                    color: kTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "$highlight\n",
                  style: GoogleFonts.notoSans(
                    fontSize: 17,
                    color: kTextColor.withOpacity(.8),
                    fontWeight: FontWeight.w600,
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
                  children: [
                    customExtendButton(
                        ctx: context,
                        child: Text(
                          "Let's go",
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: kTextLight,
                                  ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AuthenticationOptions(),
                            ),
                          );
                        })
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
