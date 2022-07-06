import 'package:flutter/material.dart';
import 'package:msafi_mobi/pages/Authentication/login/main.dart';
import 'package:msafi_mobi/pages/Authentication/signup/login_options.dart';
import 'package:msafi_mobi/pages/onboarding/main.dart';
import 'package:msafi_mobi/pages/regular/home/main.dart';
import 'package:msafi_mobi/providers/basket.providers.dart';
import 'package:msafi_mobi/providers/map.provider.dart';
import 'package:msafi_mobi/providers/store.providers.dart';
import 'package:msafi_mobi/providers/user.provider.dart';
import 'package:msafi_mobi/themes/settings.dart';
import 'package:provider/provider.dart';

import 'pages/launderMarts/main.dart';
import 'pages/launderMarts/onboarding/main.dart';
import 'pages/splash/main.dart';
import 'providers/merchant.provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MartConfig()),
        ChangeNotifierProvider(create: (context) => SearchToggle()),
        ChangeNotifierProvider(create: (context) => PlacesResults()),
        ChangeNotifierProvider(create: (context) => MerchantRoute()),
        ChangeNotifierProvider(create: (context) => User()),
        ChangeNotifierProvider(create: (context) => Basket()),
        ChangeNotifierProvider(create: (context) => Store()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      themeMode: ThemeMode.system,
      title: "Msafi-Mobi",
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashScreen(),
        "/user-onboarding": (context) => const OnboardingPage(),
        "/mart-onboarding": (context) => const BoardingRender(),
        "/login": (context) => const LoginPageOptions(),
        "/register": (context) => const SignUpPage(),
        "/mart-home": (context) => const MerchantHome(),
        "/default-home": (context) => const ClientHomePage(),
      },
      // home: const SetPricingPage(),
    );
  }
}
