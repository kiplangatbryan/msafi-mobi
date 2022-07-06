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
      const Duration(seconds: 4),
    );
    await CustomSharedPreferences().checkOnboarding().then(
      (value) async {
        if (!value) _navigateToOnboarding();
        if (value) _handleUser();
      },
    );
  }

  // validate user token and route accordingly
  _handleUser() async {
    final res = await CustomSharedPreferences().checkOrFetchUser();
    if (res == null) {
      await Future.delayed(
        const Duration(seconds: 1),
       () => _navigateTologin(),
      );
    } else {
      //Later validate the token
      await Future.delayed(
        const Duration(seconds: 1),
        () => _navigateTologin(),
      );
    }
  }

  _navigateTologin() {
    return Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => const LoginPageOptions(),
      ),
    );
  }

  _navigateToOnboarding() {
    return Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => const OnboardingPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: splashColor.withOpacity(.5),
        ),
        child: Stack(
          children: [
            Center(
              child: LimitedBox(
                maxWidth: MediaQuery.of(context).size.width,
                child: const Image(
                  image: AssetImage(
                    "assets/logo/msafi-logo-one.png",
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
