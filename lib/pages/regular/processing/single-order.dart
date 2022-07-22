import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:msafi_mobi/helpers/size_calculator.dart';
import 'package:msafi_mobi/themes/main.dart';

class SingleClientOrderView extends StatefulWidget {
  final Map order;
  const SingleClientOrderView({required this.order, Key? key})
      : super(key: key);

  @override
  State<SingleClientOrderView> createState() => _SingleOrderViewState();
}

class _SingleOrderViewState extends State<SingleClientOrderView> {
  int _counter = 0;

  String? statusLabel;
  double orderSum = 0;

  @override
  void initState() {
    super.initState();
    _calculateTotal();
  }

  _calculateTotal() {
    double totals = 0;
    List clothes = widget.order['clothes'];
    clothes
        .forEach((element) => totals += (element['price'] * element['count']));
    setState(() {
      orderSum = totals;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      statusLabel = null;
    });
  }

  double get maxWidth => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).canvasColor,
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
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.order['storeId']['name'],
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                        Chip(
                          label: Text(
                            widget.order['status'],
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: kTextMediumColor.withOpacity(.4),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    orderDets(
                        context: context,
                        key: "Order number",
                        value: widget.order['alias']),
                    const SizedBox(
                      height: 8,
                    ),
                    orderDets(
                      context: context,
                      key: "Expected pick up",
                      value: Moment.parse(widget.order['expectedPickUp'])
                          .calendar(),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    orderDets(
                        context: context,
                        key: "Dropped off place",
                        value: widget.order['stationId']['name']),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order Details",
                      style: GoogleFonts.notoSans(
                        fontSize: sizeCompute(
                            small: 23.0, large: 24.0, width: maxWidth),
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "WASHING",
                      style: GoogleFonts.notoSans(
                        fontSize: sizeCompute(
                            small: 18.0, large: 20, width: maxWidth),
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                        letterSpacing: 1.3,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: widget.order['clothes'].length,
                      itemBuilder: (context, int index) {
                        final price = widget.order['clothes'][index]["price"];
                        final count = widget.order['clothes'][index]["count"];

                        return clothItemRow(
                          count: widget.order["clothes"][index]["count"]
                              .toString(),
                          title: widget.order["clothes"][index]["id"],
                          total: (price * count).toStringAsFixed(2),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    totalsRow(
                      title: "Total",
                      total: orderSum.toStringAsFixed(2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row orderDets(
      {required BuildContext context,
      required String key,
      required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          key,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 17,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontSize: 17,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ],
    );
  }

  Row clothItemRow({
    required String title,
    required String count,
    required String total,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$count ",
                style: GoogleFonts.notoSans(
                  fontSize:
                      sizeCompute(small: 17.0, large: 20, width: maxWidth),
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              TextSpan(
                text: "x ",
                style: GoogleFonts.notoSans(
                  fontSize:
                      sizeCompute(small: 17.0, large: 20, width: maxWidth),
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              TextSpan(
                text: title,
                style: GoogleFonts.notoSans(
                  fontSize:
                      sizeCompute(small: 17.0, large: 20, width: maxWidth),
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
        Text(
          "ksh. $total",
          style: GoogleFonts.notoSans(
            fontSize: sizeCompute(small: 17.0, large: 20, width: maxWidth),
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Row subTotalsRow({
    required String title,
    required String total,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.notoSans(
            fontSize: sizeCompute(small: 18.0, large: 20, width: maxWidth),
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Text(
          "ksh. $total",
          style: GoogleFonts.notoSans(
            fontSize: sizeCompute(small: 18.0, large: 20, width: maxWidth),
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Row totalsRow({
    required String title,
    required String total,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.notoSans(
            fontSize: sizeCompute(small: 20.0, large: 22, width: maxWidth),
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          "ksh. $total",
          style: GoogleFonts.notoSans(
            fontSize: sizeCompute(small: 20.0, large: 22, width: maxWidth),
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
