import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'components/onboard_view.dart';

class AuthenticationOptions extends StatefulWidget {
  const AuthenticationOptions({Key? key}) : super(key: key);

  @override
  State<AuthenticationOptions> createState() => _AuthenticationOptionsState();
}

class _AuthenticationOptionsState extends State<AuthenticationOptions> {
  final PageController _pageController = PageController(initialPage: 0);
  late int page;

  @override
  void initState() {
    super.initState();
    page = _pageController.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    final maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: maxHeight,
          width: maxWidth,
          padding: const EdgeInsets.symmetric(
            vertical: 30,
          ),
          child: Column(
            children: [
              LimitedBox(
                maxHeight: (MediaQuery.of(context).size.height / 2 - 100),
                child: const Image(
                  image: AssetImage('assets/images/155.png'),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: "Be part of the Community, Dont be Left Behind",
                          style: GoogleFonts.notoSans(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: kTextColor,
                          )),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    customButton(
                      title: "Login",
                      icon: const Icon(
                        Icons.login,
                        color: kTextColor,
                      ),
                      role: "login",
                      callback: () {
                        Navigator.of(context).pushNamed("/login");
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    customButton(
                      title: "Register",
                      icon: const Icon(
                        Icons.app_registration,
                        color: kTextLight,
                      ),
                      role: "register",
                      callback: () {
                        Navigator.of(context).pushReplacementNamed("/register");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector customButton(
      {required String title,
      required Icon icon,
      required String role,
      required callback}) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: role == "login" ? null : splashColor,
          border: Border.all(
            color: role == "login" ? kTextColor : splashColor,
            width: 3,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.notoSans(
                fontSize: 18.0,
                letterSpacing: 1.3,
                fontWeight: FontWeight.bold,
                color: role == "login" ? kTextColor : Colors.white,
                decorationStyle: TextDecorationStyle.wavy,
              ),
            ),
            SizedBox(
              width: 11,
            ),
            icon,
          ],
        ),
      ),
    );
  }
}
