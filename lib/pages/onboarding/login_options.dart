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
          padding: EdgeInsets.symmetric(
            vertical: 30,
          ),
          child: Column(
            children: [
              const Image(
                image: AssetImage('assets/images/155.png'),
                height: 300,
              ),
              SizedBox(
                height: 50,
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
                          style: GoogleFonts.poppins(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: kTextColor,
                          )),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      customButton(
                        title: "Login",
                        icon: Icon(
                          Icons.login,
                          color: kTextColor,
                        ),
                        role: "login",
                        callback: () {
                          Navigator.of(context).pushNamed("/login");
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      customButton(
                        title: "Register",
                        icon: Icon(
                          Icons.app_registration,
                          color: kTextColor,
                        ),
                        role: "register",
                        callback: () {
                          Navigator.of(context).pushNamed("/register");
                        },
                      ),
                    ],
                  ))
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
          vertical: 15,
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
              style: GoogleFonts.poppins(
                fontSize: 22.0,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
                color: role == "login" ? kTextColor : Colors.white,
                decorationStyle: TextDecorationStyle.wavy,
              ),
            ),
            SizedBox(
              width: 30,
            ),
            icon,
          ],
        ),
      ),
    );
  }
}
