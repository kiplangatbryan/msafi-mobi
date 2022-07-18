// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/pages/Authentication/login/main.dart';
import 'package:msafi_mobi/providers/merchant.provider.dart';
import 'package:msafi_mobi/providers/store.providers.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:provider/provider.dart';

import '../../helpers/custom_shared_pf.dart';
import '../../providers/user.provider.dart';
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
      const Duration(seconds: 2),
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
      await Future.delayed(const Duration(seconds: 1),
          // () => _navigateTologin(),
          () async {
        final data = json.decode(res);

        await context.read<User>().createUser(data);
        if (data['user']['role'] == 'user') {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/default-home', (route) => false);
        } else if (data['stores'].length > 0) {
          context.read<MartConfig>().populateStore(data['stores'][0]);
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/mart-home', (route) => false);
        } else {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/mart-onboarding', (route) => false);
        }
      });
    }
  }

  _navigateTologin() {
    return Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(
        builder: (context) => const LoginPageOptions(),
      ),
      (route) => false,
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.jpg'),
            fit: BoxFit.cover,
          ),
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
