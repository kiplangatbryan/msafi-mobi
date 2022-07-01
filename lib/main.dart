import 'package:flutter/material.dart';
import 'package:msafi_mobi/pages/Authentication/login/main.dart';
import 'package:msafi_mobi/pages/Authentication/signup/login_options.dart';
import 'package:msafi_mobi/pages/onboarding/main.dart';
import 'package:msafi_mobi/pages/splash/main.dart';
import 'package:msafi_mobi/pages/launderMarts/onboarding/pages/selection.dart';

import 'package:msafi_mobi/providers/map.provider.dart';
import 'package:msafi_mobi/providers/mart.provider.dart';
import 'package:msafi_mobi/themes/settings.dart';
import 'package:provider/provider.dart';

import 'pages/launderMarts/onboarding/main.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MartConfig()),
        ChangeNotifierProvider(create: (context) => SearchToggle()),
        ChangeNotifierProvider(create: (context) => PlacesResults()),
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
        "/": (context) => const ProductSelection(),
        "/user-onboarding": (context) => const OnboardingPage(),
        "/mart-onboarding": (context) => const BoardingRender(),
        "/login": (context) => const LoginPageOptions(),
        "/register": (context) => const SignUpPage(),
      },
      // home: const SetPricingPage(),
    );
  }
}
