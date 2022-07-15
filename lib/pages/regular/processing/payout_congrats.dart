import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:http/http.dart' as http;
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
  bool loading = false, stkInit = false, confirmed = true;
  int processing = 0;

  @override
  void initState() {
    super.initState();
    _requestPaymentStk();
  }

  Future _requestPaymentStk() async {
    setState(() {
      loading = true;
    });
    final url = Uri.parse('${baseUrl()}/store/stk-push/simulate');
    final token = await checkAndValidateAuthToken();
    final headers = {"Authorization": "Bearer $token"};
    // ignore: use_build_context_synchronously
    final amount = context.read<Order>().getAmount;
    final body = {"phone": "0746613059", "amount": amount.toString()};

    try {
      // send data to server
      final response =
          await http.post(url, body: body, headers: headers).timeout(
                const Duration(seconds: 10),
              );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        print(data);
      } else {
        setState(() {
          loading = false;
          processing = 2;
        });
      }
    } on SocketException {
      setState(() {
        loading = false;
        processing = 2;
      });
      // customSnackBar('Could not connect to server');
    } on TimeoutException catch (e) {
      setState(() {
        loading = false;
        processing = 2;
      });
      // customSnackBar("Connection Timeout");
    } on Error catch (e) {
      setState(() {
        loading = false;
        processing = 2;
      });
      // customSnackBar("An error ocurred");
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
                ? statusUpdate(
                    context: context,
                    status: "Waiting for payment confirmation")
                : statusUpdate(
                    context: context, status: "Initiating transaction")
            : statusUpdate(context: context, status: ""),
      ],
    );
  }

  Widget _success() {
    return Stack(
      children: [
        Container(
          height: 300,
          child: Lottie.asset(
            'assets/lottie/sent-email-animation.json',
            width: 150,
            fit: BoxFit.cover,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Text(
                "Order Success",
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                textAlign: TextAlign.center,
                "We have sent you a notification via sms containing your basket code. Please show it to the tenant at the pick up spot.",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(
                height: 50,
              ),
              customExtendButton(
                  ctx: context,
                  child: Text(
                    "Go back Home",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: kTextLight,
                        ),
                  ),
                  onPressed: () {}),
            ],
          ),
        )
      ],
    );
  }

  Widget _failed() {
    return Stack(
      children: [
        Column(
          children: [
            Lottie.asset(
              'assets/lottie/error.json',
              width: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 80,
            ),
            Text(
              textAlign: TextAlign.center,
              "There was an error processing Transaction",
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Colors.red,
                  ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: customSmallBtn(
            ctx: context,
            child: Text(
              "Try Again",
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: kTextLight,
                  ),
            ),
            onPressed: () async {
              await _requestPaymentStk();
            },
          ),
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
        child: !confirmed
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
