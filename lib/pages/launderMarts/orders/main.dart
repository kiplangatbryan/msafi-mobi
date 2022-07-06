import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/configs/data.dart';
import 'package:msafi_mobi/helpers/size_calculator.dart';
import 'package:msafi_mobi/pages/launderMarts/orders/single-order.dart';
import 'package:msafi_mobi/themes/main.dart';

class MerchantOrders extends StatefulWidget {
  const MerchantOrders({Key? key}) : super(key: key);

  @override
  State<MerchantOrders> createState() => _MerchantOrdersState();
}

class _MerchantOrdersState extends State<MerchantOrders> {
  // text editing controller
  final searchController = TextEditingController();

  // toggle active state
  int active = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: searchBar(),
        centerTitle: true,
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(.3),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 3,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            active = 0;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: active == 0
                                ? Theme.of(context).colorScheme.background
                                : null,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 13,
                          ),
                          child: Text(
                            "Pending",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: active == 0
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            active = 1;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: active == 1 ? kBackgroundColor : null,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 13,
                          ),
                          child: Text(
                            "Completed",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: active == 1
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: fetchOrders().length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              SingleOrder(order: fetchOrders()[index])));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          padding: EdgeInsets.symmetric(
                            vertical: sizeCompute(
                                small: 25, large: 15, width: maxWidth),
                          ),
                          child: Icon(
                            Icons.history_toggle_off,
                            size: 30,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: sizeCompute(
                                  small: 15, large: 15, width: maxWidth),
                              horizontal: sizeCompute(
                                  small: 15, large: 15, width: maxWidth),
                            ),
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${fetchOrders()[index]['id']}",
                                      style: GoogleFonts.notoSans(
                                        fontSize: sizeCompute(
                                            small: 18,
                                            large: 19,
                                            width: maxWidth),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${fetchOrders()[index]['total'].toString()} KES",
                                      style: GoogleFonts.notoSans(
                                        fontSize: sizeCompute(
                                            small: 18,
                                            large: 19,
                                            width: maxWidth),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Placed on:",
                                      style: GoogleFonts.notoSans(
                                        fontSize: sizeCompute(
                                            small: 14,
                                            large: 16,
                                            width: maxWidth),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    Text(
                                      DateTime.parse(
                                        fetchOrders()[index]
                                            ['expected_pick_up'],
                                      ).toMoment().toString(),
                                      style: GoogleFonts.notoSans(
                                        fontSize: sizeCompute(
                                            small: 14,
                                            large: 16,
                                            width: maxWidth),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        "Placed at:",
                                        style: GoogleFonts.notoSans(
                                          fontSize: sizeCompute(
                                              small: 14,
                                              large: 16,
                                              width: maxWidth),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      fetchOrders()[index]['pick_up_station'],
                                      style: GoogleFonts.notoSans(
                                        fontSize: sizeCompute(
                                            small: 14,
                                            large: 16,
                                            width: maxWidth),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
      style: GoogleFonts.notoSans(
        color: kTextColor,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      cursorColor: kTextColor,
      cursorHeight: 22,
      decoration: InputDecoration(
        hintText: "Search",
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
      onChanged: (val) {},
    );
  }
}
