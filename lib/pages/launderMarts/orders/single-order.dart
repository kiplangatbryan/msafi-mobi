import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/helpers/size_calculator.dart';
import 'package:msafi_mobi/themes/main.dart';

class SingleOrder extends StatefulWidget {
  final Map order;
  const SingleOrder({required this.order, Key? key}) : super(key: key);

  @override
  State<SingleOrder> createState() => _SingleOrderState();
}

class _SingleOrderState extends State<SingleOrder> {
  int _counter = 0;
  List<String> statusNames = ["Started", "Awaiting", "Completed"];

  String? statusLabel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    statusLabel = statusNames[_counter];
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
        automaticallyImplyLeading: true,
      ),
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 50,
                horizontal: 30,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  image: const DecorationImage(
                    image: AssetImage(
                      "assets/images/054.png",
                    ),
                    opacity: .4,
                    alignment: Alignment.bottomRight,
                    fit: BoxFit.fitHeight,
                  ),
                  backgroundBlendMode: BlendMode.darken),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Details About\n",
                      style: GoogleFonts.notoSans(
                        fontSize: sizeCompute(
                            small: 27.0, large: 30, width: maxWidth),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    TextSpan(
                      text: "Order #${widget.order['id']}",
                      style: GoogleFonts.notoSans(
                        fontSize: sizeCompute(
                            small: 27.0, large: 30, width: maxWidth),
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 30,
              ),
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(30),
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
                      fontSize:
                          sizeCompute(small: 18.0, large: 20, width: maxWidth),
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
                        count: widget.order["clothes"][index]["count"],
                        title: widget.order["clothes"][index]["id"],
                        total:
                            widget.order["clothes"][index]["price"].toString(),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  subTotalsRow(
                    title: "Subtotal",
                    total: widget.order['total'].toString(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  subTotalsRow(
                    title: "Vat",
                    total: widget.order['vat'].toString(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  totalsRow(
                    title: "Total",
                    total: (widget.order['total'] + widget.order['vat'])
                        .toString(),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: sizeCompute(small: 35.0, large: 40, width: maxWidth),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: kBackgroundColor,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 30,
              ),
              child: Column(
                children: [
                  DropdownButtonFormField2(
                    decoration: InputDecoration(
                      //Add isDense true and zero Padding.
                      //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      //Add more decoration as you want here
                      //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                    ),
                    isExpanded: true,
                    hint: Text(
                      'Toggle Laundry Progress',
                      style: GoogleFonts.notoSans(
                        fontSize: sizeCompute(
                            small: 16.0, large: 18, width: maxWidth),
                        color: Colors.white,
                      ),
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                    ),
                    iconSize: 30,
                    buttonHeight: 60,
                    buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: kBackgroundColor,
                    ),
                    enableFeedback: true,
                    style: GoogleFonts.notoSans(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    items: statusNames
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: GoogleFonts.notoSans(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: kTextMediumColor,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select gender.';
                      }
                    },
                    onChanged: (value) {
                      //Do something when changing the item if you want.
                    },
                    onSaved: (value) {
                      statusLabel = value.toString();
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  customButton(
                    title: "Update",
                    role: "register",
                    callback: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ],
    );
  }
}
