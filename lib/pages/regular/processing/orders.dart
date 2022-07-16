// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:http/http.dart' as http;
import 'package:msafi_mobi/components/snackback_component.dart';
import 'package:msafi_mobi/pages/regular/components/app_bar.dart';
import 'package:msafi_mobi/providers/placed.providers.dart';
import 'package:provider/provider.dart';

import '../../../helpers/http_services.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({Key? key}) : super(key: key);

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  bool loading = false;
  bool failed = false;
  List orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  fetchOrders() async {
    final url = Uri.parse('${baseUrl()}/store/fetchUserOrders');
    final token = await checkAndValidateAuthToken();
    final headers = {"Authorization": "Bearer $token"};
    try {
      // send data to server
      final response = await http.get(url, headers: headers).timeout(
            const Duration(seconds: 10),
          );

      try {
        final data = json.decode(response.body).catchError();

        if (response.statusCode == 200) {
          print(orders);
          if (data.isNotEmpty) {
            context.read<ExistingOrders>().populateOrders(data);
          }
        } else {
          setState(() {
            loading = false;
          });
        }
      } catch (err) {
        customSnackBar(
            context: context, message: err.toString(), onPressed: () {});
      }
    } on SocketException {
      customSnackBar(
          context: context,
          message: 'Could not connect to server',
          onPressed: () {});
    } on TimeoutException catch (e) {
      // customSnackBar("Connection Timeout");
    } on Error catch (e) {
      customSnackBar(
          context: context,
          message: 'Could not connect to server',
          onPressed: () {});
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context: context, title: "Orders"),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Chip(
                    label: Row(
                      children: [
                        const Icon(Icons.bookmark),
                        Text(
                          "Completed",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            orders.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/empty-orders.json',
                        repeat: false,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "You have no orders",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  )
                : ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: orders.length,
                    itemBuilder: (BuildContext context, index) {
                      return Container();
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

Text statusUpdate({required BuildContext context, required String status}) {
  return Text(
    status,
    style: Theme.of(context).textTheme.headline6!.copyWith(
          fontSize: 18,
          color: Theme.of(context).primaryColor,
        ),
  );
}
