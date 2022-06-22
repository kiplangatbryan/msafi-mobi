import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/pages/Authentication/login/main.dart';
import 'package:msafi_mobi/themes/main.dart';

import '../../helpers/custom_shared_pf.dart';
import '../onboarding/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadNavigationData();
  }

  _loadNavigationData() async {
    await Future.delayed(
      const Duration(seconds: 5),
    );
    await CustomSharedPreferences().checkOnboarding().then(
      (value) async {
        if (!value) _navigateToOnboarding();
        if (value) _navigateTologin();
      },
    );
  }

  _navigateTologin() {
    return Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => const LoginPageOptions(),
      ),
    );
  }

  _navigateToOnboarding() {
    return Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(
          builder: (context) => const OnboardingPage(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSplashBgColor,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: splashColor.withOpacity(.8),
            ),
            child: Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Msafi Mobi\n",
                      style: GoogleFonts.poppins(
                        fontSize: 35,
                        color: kDarkPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "Say goobye to dirty laundry",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: kDarkPrimary,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
