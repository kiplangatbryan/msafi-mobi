import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/configs/data.dart';
import 'package:msafi_mobi/helpers/size_calculator.dart';
import 'package:msafi_mobi/pages/launderMarts/orders/single-order.dart';
import 'package:msafi_mobi/providers/merchant.provider.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

import '../../../components/snackback_component.dart';
import '../../../helpers/http_services.dart';
import '../../../services/store.services.dart';
import '../components/single_order.dart';

class MerchantOrders extends StatefulWidget {
  const MerchantOrders({Key? key}) : super(key: key);

  @override
  State<MerchantOrders> createState() => _MerchantOrdersState();
}

class _MerchantOrdersState extends State<MerchantOrders> {
  // text editing controller
  final searchController = TextEditingController();
  // List will hold search results
  List searchResults = [];
  late final bool autoFocus;
// loading state
  bool loading = false;
  // toggle active state
  int active = 0;
  // hold all orders
  List orderList = [];

  @override
  void initState() {
    super.initState();
    autoFocus = context.read<MerchantRoute>().autoFocusState;
    _fetchOrders();
  }

  _findOrders(val) async {
    final token = await checkAndValidateAuthToken();
    final response = await StoreService().search(val, token);

    if (double.tryParse(response) == null) {
      customSnackBar(
        context: context,
        message: "An Fatal Error Ocurred",
        onPressed: () {},
      );
    }
    setState(() {
      searchResults = response;
    });
  }

  _fetchOrders() async {
    var url =
        Uri.parse('${baseUrl()}/store/fetchOrders/62c7aa3a0be196261ce03980');
    setState(() {
      loading = true;
    });
    String authToken = await checkAndValidateAuthToken();
    if (authToken == "NaN") {
      // throw an error
      customSnackBar(
          context: context, message: "Invalid refreshToken", onPressed: () {});
      return;
    }

    try {
      // send data to server
      final response = await http.get(url, headers: {
        "Authorization": "Bearer $authToken",
      }).timeout(
        const Duration(seconds: 10),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          orderList = data;
        });
      } else {
        customSnackBar(
            context: context, message: "Server Error", onPressed: () {});
      }
    } on SocketException {
      customSnackBar(
          context: context,
          message: "Could not connect to server!",
          onPressed: () {});
    } on TimeoutException catch (e) {
      customSnackBar(
          context: context, message: "Connection timed out!", onPressed: () {});
    } on Error catch (e) {
      customSnackBar(
          context: context, message: "An error occurred", onPressed: () {});
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    // context.read<MerchantRoute>().setAutoFocusState(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 1,
        title: Text(
          'My Orders',
          style: Theme.of(context).textTheme.headline6,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: sizeCompute(small: 15, large: 20, width: maxWidth),
            right: sizeCompute(small: 15, large: 20, width: maxWidth),
            top: sizeCompute(small: 20, large: 30, width: maxWidth),
            bottom: sizeCompute(small: 20, large: 20, width: maxWidth),
          ),
          child: Column(
            children: [
              if (orderList.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Chip(
                        label: Text(
                          "completed",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Chip(
                        label: Text(
                          "completed",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Chip(
                        label: Text(
                          "completed",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      )
                    ],
                  ),
                ),
              const SizedBox(
                height: 15,
              ),
              loading
                  ? SizedBox(
                      height: 250,
                      child: Center(
                        child: Lottie.asset(
                          "assets/lottie/circular-loading.json",
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  : orderList.isEmpty
                      ? Column(
                          children: [
                            Lottie.asset(
                              'assets/lottie/empty-orders.json',
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              "You have no orders right now ):",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        )
                      : ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: orderList.length,
                          itemBuilder: (context, index) {
                            final order = orderList[index];
                            return SingleOrderComponent(
                              margin: const EdgeInsets.only(
                                bottom: 10,
                              ),
                              order: order,
                              customerName: order['userId']['name'],
                              status: order['status'],
                              orderId: order['id'],
                              stationName: order['stationId']['name'],
                              expectedDate: order['expectedPickUp'],
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField searchBar() {
    return TextFormField(
      controller: searchController,
      autofocus: autoFocus,
      style: GoogleFonts.notoSans(
        color: kTextColor,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      cursorColor: kTextColor,
      cursorHeight: 22,
      decoration: InputDecoration(
        hintText: "Enter order number",
        hintStyle: GoogleFonts.notoSans(
          color: kTextMediumColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: const EdgeInsets.fromLTRB(20, 4, 10, 4),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
          gapPadding: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor.withOpacity(.08),
          ),
          gapPadding: 10,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.secondary.withOpacity(.2),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              searchController.text = "";
            });
          },
          icon: const Icon(Icons.close),
        ),
      ),
      onChanged: (val) async {
        if (val.length > 1) {
          // throttle the search event
          await Future.delayed(const Duration(seconds: 1));
          await _findOrders(val);
        }
      },
    );
  }
}
