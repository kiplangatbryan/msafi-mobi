import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:flutter/cupertino.dart';

import 'package:msafi_mobi/themes/main.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:http/http.dart' as http;

import '../../../helpers/http_services.dart';
import '../../../providers/orders.providers.dart';
import '../../../providers/store.providers.dart';
import 'cloth_select.dart';

class LaunderMartView extends StatefulWidget {
  int index;
  String tagId;
  LaunderMartView({required this.index, required this.tagId, Key? key})
      : super(key: key);

  @override
  State<LaunderMartView> createState() => _LaunderMartViewState();
}

class _LaunderMartViewState extends State<LaunderMartView> {
  final PageController _pageController = PageController(initialPage: 0);
  late int page;
  String snackBarMessage = "";
  bool loading = false;
  bool showSnack = false;
  List pickUpSpots = [];

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

  @override
  void initState() {
    super.initState();
    page = _pageController.initialPage;
    _fetchPickUpSpots();
  }

  _fetchPickUpSpots() async {
    setState(() {
      loading = true;
    });
    var storeId = context.read<Store>().stores[widget.index]['id'];
    var url = Uri.parse('${baseUrl()}/store/fetchStations/$storeId');
    final token = await checkAndValidateAuthToken(context);
    try {
      // send data to server
      final response = await http
          .get(url, headers: {"Authorization": "Bearer $token"}).timeout(
        const Duration(seconds: 10),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          loading = false;
          pickUpSpots = data;
          context.read<Stations>().setPickUps(data);
        });
      } else {
        customSnackBar('There was a problem');
      }
    } on SocketException {
      customSnackBar('Could not connect to server');
    } on TimeoutException catch (e) {
      customSnackBar("Connection Timeout");
    } on Error catch (e) {
      customSnackBar("An error ocurred");
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = context.read<Store>().stores[widget.index];
    final count = store['storeImg'].length;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          "Details",
          style: Theme.of(context).textTheme.headline6!.copyWith(
              // fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            bottom: 30,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${store['name']}\n",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextSpan(
                      text: store['address'],
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            height: 1.4,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Hero(
                tag: widget.index,
                child: SizedBox(
                  height: 200,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        page = index;
                      });
                    },
                    // ignore: prefer_const_literals_to_create_immutables
                    children: List.generate(count, (id) {
                      return Container(
                        height: 200,
                        margin: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                '${baseUrl()}/${store['storeImg'][id]}'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: kSmoothIndicator,
                      dotColor: kTextLightColor,
                      dotHeight: 10,
                      dotWidth: 10,
                    ),
                    count: count,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    ContactInfo(
                      name: store['userId']['name'],
                      phoneNumber: store['userId']['email'],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    StoreInformation(description: store['description']),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(.04),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      child: loading
                          ? const SizedBox(
                              height: 100,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              ),
                            )
                          : Column(
                              children: List.generate(
                                pickUpSpots.length,
                                (i) => StationItem(
                                  name: pickUpSpots[i]['name'],
                                  lat: pickUpSpots[i]['lat'],
                                  long: pickUpSpots[i]['long'],
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    customExtendButton(
                      ctx: context,
                      child: Text(
                        "View Store",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: kTextLight,
                            ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (_) =>
                                LaundrySelection(index: widget.index)));
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoreInformation extends StatelessWidget {
  const StoreInformation({
    Key? key,
    required this.description,
  }) : super(key: key);

  final String description;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: "Information\n\n",
              style: Theme.of(context).textTheme.headline6),
          TextSpan(
              text: description, style: Theme.of(context).textTheme.subtitle1),
        ],
      ),
    );
  }
}

class StationItem extends StatelessWidget {
  String name;
  String long;
  String lat;
  StationItem({
    required this.name,
    required this.long,
    required this.lat,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 15,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 35,
                      child: Center(
                        child: Icon(
                          Icons.location_on,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Description(name: name),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.zoom_in_map_sharp,
                    size: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Description extends StatelessWidget {
  const Description({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$name\n",
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontSize: 17,
                ),
          ),
          TextSpan(
            text: "Tap to view on map",
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  height: 1.4,
                ),
          )
        ],
      ),
    );
  }
}

class ContactInfo extends StatelessWidget {
  String name;
  String phoneNumber;

  ContactInfo({
    required this.name,
    required this.phoneNumber,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              maxRadius: 22,
              minRadius: 18,
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              child: Text("A", style: Theme.of(context).textTheme.headline6),
            ),
            const SizedBox(
              width: 20,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$name\n",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontSize: 18,
                        ),
                  ),
                  TextSpan(
                    text: "Owner",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          height: 1.4,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.only(
              top: 18,
              bottom: 18,
              left: 18,
              right: 18,
            ),
            primary: Theme.of(context).primaryColor,
            shape: const CircleBorder(),
          ),
          onPressed: () {},
          child: const Icon(
            Icons.phone_outlined,
            size: 25,
          ),
        ),
      ],
    );
  }
}
