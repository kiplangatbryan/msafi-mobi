// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:http/http.dart' as http;
import 'package:msafi_mobi/components/snackback_component.dart';
import 'package:msafi_mobi/pages/regular/components/app_bar.dart';
import 'package:provider/provider.dart';

import '../../../components/form_components.dart';
import '../../../helpers/http_services.dart';
import '../../../providers/orders.providers.dart';
import '../../../themes/main.dart';

class ProcessingOrder extends StatefulWidget {
  const ProcessingOrder({Key? key}) : super(key: key);

  @override
  State<ProcessingOrder> createState() => _ProcessingOrderState();
}

class _ProcessingOrderState extends State<ProcessingOrder> {
  bool loading = false, stkInit = false, confirmed = true, completed = false;
  int processing = 0;
  String code = "";

  @override
  void initState() {
    super.initState();
    _requestPaymentStk();
  }

  _processOrder(String paymentId) async {
    final token = await checkAndValidateAuthToken(context);
    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };
    final order = context.read<Order>();

    final body = {
      "paymentId": paymentId,
      "clothes": order.clothesArray,
      "storeId": order.storeId,
      "stationId": order.stationAdress['id'],
      "expectedPickUp": order.expectedDate.toString(),
      "amount": order.amount,
      "phone": order.phone,
    };

    final orderData = json.encode(body);

    try {
      Response response = await httHelper().post('/store/createOrder',
          data: orderData, options: Options(headers: headers));
      final data = response.data;

      if (response.statusCode == 201) {
        setState(() {
          loading = false;
          processing = 0;
          completed = true;
          code = data['alias'];
        });
      } else {
        processing = 2;
        loading = false;
        stkInit = false;
        confirmed = false;
      }
    } on DioError catch (err) {
      customSnackBar(
          context: context,
          message: "could not create order",
          onPressed: () {});
    }
  }

  _verifyTransaction({required String CheckoutRequestID, int? count}) async {
    const retries = 5;
    var counter = count ?? 0;
    final token = await checkAndValidateAuthToken(context);
    final headers = {"Authorization": "Bearer $token"};

    try {
      // send data to server
      Response response = await httHelper().post("/store/stk-push/query",
          data: {
            "CheckoutRequestID": CheckoutRequestID,
          },
          options: Options(headers: headers));
      final data = response.data;

      if (response.statusCode == 200) {
        setState(() {
          confirmed = true;
        });
        return _processOrder(data['_doc']['paymentId']);
      } else {
        if (data.isEmpty && counter <= retries) {
          print("retring ... ${counter + 1}");

          Future.delayed(const Duration(seconds: 8), () async {
            counter = counter + 1;
            await _verifyTransaction(
                CheckoutRequestID: CheckoutRequestID, count: counter);
          });
        } else {
          setState(() {
            stkInit = false;
            processing = 2;
            loading = false;
          });
        }
      }
    } catch (err) {
      setState(() {
        loading = false;
        processing = 2;
        stkInit = false;
      });
    }
  }

  _requestPaymentStk() async {
    setState(() {
      loading = true;
    });
    final token = await checkAndValidateAuthToken(context);
    final headers = {"Authorization": "Bearer $token"};
    final amount = context.read<Order>().getAmount;
    final phone = context.read<Order>().phone;

    final body = {"phone": phone, "amount": amount.toString()};

    try {
      // send data to server
      Response response = await httHelper().post('/store/stk-push/simulate',
          data: body, options: Options(headers: headers));

      final data = response.data;

      if (response.statusCode == 200) {
        setState(() {
          stkInit = true;
        });
        return _verifyTransaction(CheckoutRequestID: data['CheckoutRequestID']);
      } else {
        customSnackBar(
            context: context, message: 'Invalid statuscode', onPressed: () {});
        setState(() {
          loading = false;
          processing = 2;
        });
      }
    } on DioError catch (ex) {
      setState(() {
        loading = false;
        processing = 2;
      });
      customSnackBar(
        context: context,
        message: 'Could not connect to server',
        onPressed: () {},
      );
    }
  }

  Widget _loadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        loading
            ? Center(
                child: Lottie.asset(
                  'assets/lottie/circular-loading.json',
                  fit: BoxFit.cover,
                ),
              )
            : Container(),
        loading
            ? loading && stkInit
                ? loading && stkInit && confirmed
                    ? statusUpdate(
                        context: context, status: "confirmed! processing order")
                    : statusUpdate(
                        context: context,
                        status: "Waiting for payment confirmation")
                : statusUpdate(
                    context: context, status: "Initiating transaction")
            : statusUpdate(context: context, status: ""),
      ],
    );
  }

  Widget _success() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 200,
          child: Lottie.asset(
            'assets/lottie/receipt-success.json',
            repeat: false,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Order Success",
              style: Theme.of(context).textTheme.headline4!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              textAlign: TextAlign.center,
              "We have sent you a notification\nvia sms containing your basket code. use $code to trade.",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontSize: 18, color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        customExtendButton(
            ctx: context,
            child: Text(
              "Go  Home",
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: kTextLight,
                  ),
            ),
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/default-home', (route) => false);
            })
      ],
    );
  }

  Widget _failed() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/lottie/error-face.json',
          repeat: false,
          width: 150,
          fit: BoxFit.cover,
        ),
        const SizedBox(
          height: 80,
        ),
        Text(
          textAlign: TextAlign.center,
          "There was an error processing your Transaction",
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Colors.red,
                height: 1.4,
              ),
        ),
        const SizedBox(
          height: 40,
        ),
        TextButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Try Again",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(
                width: 20,
              ),
              Icon(
                Icons.replay_circle_filled,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
          onPressed: () async {
            await _requestPaymentStk();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context: context, title: "Transaction"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 50,
        ),
        child: !completed
            ? loading
                ? _loadingState()
                : _failed()
            : _success(),
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
