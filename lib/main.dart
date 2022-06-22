import 'package:flutter/material.dart';
import 'package:msafi_mobi/pages/Authentication/components/backup.dart';
import 'package:msafi_mobi/pages/Authentication/components/form_sign.dart';
import 'package:msafi_mobi/pages/Authentication/login/main.dart';
import 'package:msafi_mobi/pages/regular/home/main.dart';
import 'package:msafi_mobi/pages/splash/main.dart';
import 'package:msafi_mobi/store/mart.dart';
import 'package:msafi_mobi/themes/settings.dart';
import 'package:provider/provider.dart';

import 'pages/launderMarts/onboarding/main.dart';
import 'pages/launderMarts/onboarding/pages/pricing.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MartConfig()),
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
      home: const BoardingRender(),
      // home: const HomePage(),
      routes: {},
      // home: const SetPricingPage(),
    );
  }
}
