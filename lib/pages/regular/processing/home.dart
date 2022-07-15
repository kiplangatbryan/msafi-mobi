import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/helpers/custom_shared_pf.dart';
import 'package:msafi_mobi/providers/store.providers.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../../components/form_components.dart';
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 50,
              bottom: 0,
            ),
            child: Column(children: [
              Row(
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
                              color: Theme.of(context).colorScheme.primary),
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
              const SizedBox(
                height: 30,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: kTextColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      10.0,
                    ),
                  ),
                ),
                height: 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Container(
                        width: 55,
                        height: 55,
                        decoration: const BoxDecoration(
                          color: kSpecialAc,
                          borderRadius: BorderRadius.all(Radius.circular(55.0)),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.location_on,
                            size: 25,
                            color: kBackgroundColor,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 18,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Your Location\n",
                                style: GoogleFonts.notoSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: "Royal Ln.Mesa New Jersey\n",
                                style: GoogleFonts.notoSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // const Offers(),
            ]),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Cleaners",
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "see all",
                    style: GoogleFonts.notoSans(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const LanderMartsList(),
          const SizedBox(
            height: 50,
          ),
          // customExtendButton(
          //     ctx: context,
          //     child: Text(
          //       'Logout',
          //       style: Theme.of(context).textTheme.headline6!.copyWith(
          //             color: kTextLight,
          //           ),
          //     ),
          //     onPressed: () async {
          //       final status = await CustomSharedPreferences().logout();
          //       if (status) {
          //         // ignore: use_build_context_synchronously
          //         Navigator.of(context)
          //             .pushNamedAndRemoveUntil('/login', (route) => false);
          //       }
          //     }),
        ],
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
  int _sizePreview = 0;

  @override
  void initState() {
    super.initState();
    fetchStores();
  }

  // snack bar
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> customSnackBar(
      String message) {
    setState(() {
      snackBarMessage = message;
    });
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(snackBarMessage),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      ),
    );
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
        if (data.length > 3) {
          setState(() {
            _sizePreview = 3;
          });
        } else {
          setState(() {
            _sizePreview = data.length;
          });
        }
        // ignore: use_build_context_synchronously
        context.read<Store>().saveStores(data);

        Future.delayed(
            const Duration(seconds: 1),
            () => {
                  setState(() {
                    loading = false;
                  })
                });
      } else {
        // _postErrors("Email or password is Incorrect");
      }
    } on SocketException {
      customSnackBar('Could not connect to server');
    } on TimeoutException catch (e) {
      customSnackBar("Connection Timeout");
    } on Error catch (e) {
      // print(e);
      setState(() {
        errorState = true;
      });
      customSnackBar("$e");
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          )
        : errorState
            ? Container(
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
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  child: Row(
                    children: List.generate(_sizePreview, (index) {
                      return Hero(
                        tag: context.read<Store>().stores[index]['id'],
                        child: StoreItem(
                          index: index,
                          title: context.read<Store>().stores[index]['name'],
                        ),
                      );
                    }),
                  ),
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
    return InkWell(
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (_) => LaunderMartView(
                tagId: context.read<Store>().stores[index]['id'],
                index: index)));
      },
      child: Container(
          width: MediaQuery.of(context).size.width,
          margin: margin,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: kTextLight,
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  color: Theme.of(context).colorScheme.secondary,
                  offset: const Offset(0, 5),
                  spreadRadius: 1,
                ),
              ]),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        '${baseUrl()}/${context.read<Store>().stores[index]['storeImg'][0]}'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                height: 180,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: Text(
                  textAlign: TextAlign.start,
                  title,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ],
          )),
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
