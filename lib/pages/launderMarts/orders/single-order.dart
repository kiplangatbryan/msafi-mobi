import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/components/form_components.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            size: 16,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: splashColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Details About\n",
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        color: kBackgroundColor,
                      ),
                    ),
                    TextSpan(
                      text: "Order #${widget.order['id']}",
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        color: kBackgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: kBackgroundColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order Details",
                      style: GoogleFonts.poppins(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: kTextColor,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "WASHING",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kTextMediumColor.withOpacity(.7),
                        letterSpacing: 1.3,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.order['clothes'].length,
                      itemBuilder: (context, int index) {
                        return clothItemRow(
                          count: widget.order["clothes"][index]["count"],
                          title: widget.order["clothes"][index]["id"],
                          total: widget.order["clothes"][index]["price"]
                              .toString(),
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
                      title: "VAT",
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
              const SizedBox(
                height: 40,
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
                        style: GoogleFonts.poppins(
                          fontSize: 18,
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
                        color: Color.fromARGB(255, 43, 222, 228),
                      ),
                      enableFeedback: true,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      items: statusNames
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: GoogleFonts.poppins(
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
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kTextColor,
                ),
              ),
              TextSpan(
                text: "x ",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kTextMediumColor.withOpacity(.7),
                ),
              ),
              TextSpan(
                text: title,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kTextMediumColor.withOpacity(.7),
                ),
              ),
            ],
          ),
        ),
        Text(
          "ksh. $total",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kTextColor,
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
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kTextMediumColor.withOpacity(.7),
          ),
        ),
        Text(
          "ksh. $total",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kTextColor,
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
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: kTextColor,
          ),
        ),
        Text(
          "ksh. $total",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: splashColor,
          ),
        ),
      ],
    );
  }
}
