// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:http/http.dart' as http;
import 'package:moment_dart/moment_dart.dart';
import 'package:msafi_mobi/components/snackback_component.dart';
import 'package:msafi_mobi/pages/regular/components/app_bar.dart';
import 'package:msafi_mobi/providers/placed.providers.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:provider/provider.dart';

import '../../../helpers/http_services.dart';
import 'single-order.dart';

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
    var storeOrders = context.read<ExistingOrders>().orders;
    if (storeOrders.isEmpty) {
      fetchOrders();
    } else {
      setState(() {
        orders = storeOrders;
      });
    }
  }

  fetchOrders() async {
    setState(() {
      loading = true;
    });
    final url = Uri.parse('${baseUrl()}/store/fetch-user-orders');
    final token = await checkAndValidateAuthToken(context);
    final headers = {"Authorization": "Bearer $token"};
    try {
      // send data to server
      final response = await http.get(url, headers: headers).timeout(
            const Duration(seconds: 10),
          );

      try {
        final data = json.decode(response.body);

        if (response.statusCode == 200) {
          if (data.isNotEmpty) {
            context.read<ExistingOrders>().populateOrders(data);
            setState(() {
              orders = data;
            });
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
      appBar: mainAppBar(context: context, title: "My Orders"),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          children: [
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
                      final orderItem = orders[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 18,
                        ),
                        margin: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colors.blue,
                              Color.fromRGBO(195, 14, 250, 1),
                            ],
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            print('tapped');
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (_) => SingleClientOrderView(
                                      order: orderItem,
                                    )));
                          },
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    orderItem['alias'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                  ),
                                  Chip(
                                    label: Text(
                                      orderItem['status'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "LaunderMart",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                      ),
                                      Text(
                                        orderItem['storeId']['name'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Expected Date",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                      ),
                                      Text(
                                        Moment.parse(
                                                orderItem['expectedPickUp'])
                                            .calendar(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
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
