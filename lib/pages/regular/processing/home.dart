import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:msafi_mobi/components/snackback_component.dart';
import 'package:msafi_mobi/providers/store.providers.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../../helpers/http_services.dart';
import '../../../helpers/size_calculator.dart';
import '../../../providers/user.provider.dart';
import 'single_merchant_view.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 40,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Good Afternoon\n",
                                style: GoogleFonts.notoSans(
                                    fontSize: sizeCompute(
                                        small: 21, large: 24, width: maxWidth),
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              TextSpan(
                                text: "Welcome ${context.read<User>().name}",
                                style: GoogleFonts.notoSans(
                                  fontSize: sizeCompute(
                                      small: 16, large: 17, width: maxWidth),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.notifications_active_outlined,
                                size: 30,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.settings_outlined,
                                size: 30,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text(
                          "Around you",
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    fontSize: 18,
                                  ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Chip(
                        label: Text(
                          "Popular",
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    fontSize: 18,
                                  ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Chip(
                        label: Text(
                          "Around you",
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    fontSize: 18,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: LanderMartsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LanderMartsList extends StatefulWidget {
  const LanderMartsList({
    Key? key,
  }) : super(key: key);

  @override
  State<LanderMartsList> createState() => _LanderMartsListState();
}

class _LanderMartsListState extends State<LanderMartsList> {
  bool loading = false;
  String snackBarMessage = "";
  bool showSnack = false;
  bool errorState = false;
  List storesArr = [];

  @override
  void initState() {
    super.initState();
    fetchStores();
  }

  Future<void> fetchStores() async {
    setState(() {
      loading = true;
    });
    var url = Uri.parse('${baseUrl()}/store/fetchStores');

    try {
      // send data to server
      final response = await http.get(url).timeout(
            const Duration(seconds: 10),
          );

      List data = json.decode(response.body);

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously

        // ignore: use_build_context_synchronously
        context.read<Store>().saveStores(data);
        setState(() {
          loading = false;
          storesArr = data;
        });
      } else {
        customSnackBar(
            context: context, message: 'Something happened', onPressed: () {});
      }
    } on SocketException {
      customSnackBar(
          context: context,
          message: 'Could not connect to server',
          onPressed: () {});
    } on TimeoutException catch (e) {
      customSnackBar(
          context: context, message: 'Connection Timedout', onPressed: () {});
    } on Error catch (e) {
      customSnackBar(
          context: context,
          message: 'An Error Ocuured ${e.toString()}',
          onPressed: () {});
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !errorState
        ? loading
            ? SizedBox(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              )
            : storesArr.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/coffie-sleeping.json',
                        repeat: false,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Sorry no stores Available. They will be available soon",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 250,
                      crossAxisCount: 2,
                      mainAxisSpacing: 6.0,
                      crossAxisSpacing: 6.0,
                    ),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    // crossAxisCount is the number of columns
                    itemCount: storesArr.length,
                    // This creates two columns with two items in each column
                    itemBuilder: (BuildContext context, index) {
                      final store = storesArr[index];
                      return Hero(
                        tag: store['id'],
                        child: StoreItem(
                          index: index,
                          title: store['name'],
                        ),
                      );
                    })
        : errorHandler(context);
  }

  Container errorHandler(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            textAlign: TextAlign.center,
            "Their was a problem with Your connection.",
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                errorState = false;
              });
              fetchStores();
            },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
              horizontal: 35,
              vertical: 10,
            )),
            child: Text(
              "Try again",
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: kTextLight,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class StoreItem extends StatelessWidget {
  int index;
  String title;
  EdgeInsets margin;
  StoreItem({
    required this.title,
    this.margin = const EdgeInsets.only(
      right: 20,
    ),
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storeItem = context.read<Store>().stores[index];
    return Column(
      children: [
        Card(
          elevation: 4,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (_) =>
                      LaunderMartView(tagId: storeItem['id'], index: index),
                ),
              );
            },
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                      NetworkImage('${baseUrl()}/${storeItem["storeImg"][0]}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            storeItem['name'],
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ],
    );
  }
}

class Offers extends StatelessWidget {
  const Offers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.all(
          Radius.circular(
            10.0,
          ),
        ),
      ),
      height: 150,
      width: double.infinity,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 50,
            ),
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "25% OFF\n",
                        style: GoogleFonts.notoSans(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "First Dry Cleaning",
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: splashColor,
                      enableFeedback: true,
                      padding: const EdgeInsets.symmetric(
                        vertical: 9,
                        horizontal: 20,
                      ),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      print('clicked');
                    },
                    autofocus: true,
                    child: Text(
                      "USE CODE",
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 55,
            left: -10,
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                color: kBackgroundColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    30.0,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 55,
            right: -10,
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                color: kBackgroundColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    30.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
