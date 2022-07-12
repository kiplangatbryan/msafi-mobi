import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/helpers/size_calculator.dart';
import 'package:msafi_mobi/themes/main.dart';

class SingleOrderView extends StatefulWidget {
  final Map order;
  const SingleOrderView({required this.order, Key? key}) : super(key: key);

  @override
  State<SingleOrderView> createState() => _SingleOrderViewState();
}

class _SingleOrderViewState extends State<SingleOrderView> {
  int _counter = 0;
  List<String> statusNames = ["Started", "Awaiting", "Completed"];

  String? statusLabel;
  int orderSum = 0;

  @override
  void initState() {
    super.initState();
    statusLabel = statusNames[_counter];
    _calculateTotal();
  }

  _calculateTotal() {
    var totals = 0;
    List clothes = widget.order['clothes'];
    clothes.forEach((element) => totals += element['total'] as int);
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
              ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: kTextLight,
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
                      children: [
                        CircleAvatar(
                          minRadius: 18,
                          maxRadius: 20,
                          child: Text(
                            "${widget.order['userId']['name'][0].toUpperCase()}",
                            style:
                                Theme.of(context).textTheme.headline5!.copyWith(
                                      color: kTextLight,
                                    ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${widget.order['userId']['name']}\n",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              TextSpan(
                                text: "${widget.order['userId']['email']}\n",
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ],
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
                        value: widget.order['id']),
                    const SizedBox(
                      height: 8,
                    ),
                    orderDets(
                      context: context,
                      key: "Expected pick up",
                      value: DateTime.parse(widget.order['expectedPickUp'])
                          .toMoment()
                          .toString(),
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
                    orderDets(
                        context: context,
                        key: "Expected pick up",
                        value: widget.order['expectedPickUp']),
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
                        return clothItemRow(
                          count: widget.order["clothes"][index]["count"]
                              .toString(),
                          title: widget.order["clothes"][index]["id"],
                          total: widget.order["clothes"][index]["total"]
                              .toString(),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // subTotalsRow(
                    //   title: "Subtotal",
                    //   total: widget.order['total'].toString(),
                    // ),
                    const SizedBox(
                      height: 15,
                    ),
                    // subTotalsRow(
                    //   title: "Vat",
                    //   total: widget.order['vat'].toString(),
                    // ),
                    const SizedBox(
                      height: 15,
                    ),
                    totalsRow(
                      title: "Total",
                      total: orderSum.toString(),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kBackgroundColor,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      "This will allow the client to know that the service is complete",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    customExtendButton(
                      ctx: context,
                      child: Text(
                        "Mark as Complete",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: kTextLight,
                            ),
                      ),
                      onPressed: () {},
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
                fontSize: 17,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontSize: 17,
                color: kTextMediumColor,
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
