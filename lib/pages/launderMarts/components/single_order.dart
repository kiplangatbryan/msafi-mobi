import 'package:flutter/material.dart';
import 'package:moment_dart/moment_dart.dart';

import '../../../themes/main.dart';
import '../orders/single-order.dart';

class SingleOrderComponent extends StatelessWidget {
  Map order;
  String status;
  String expectedDate;
  String orderId;
  String? avatarUrl = "";
  String stationName;
  String customerName;
  EdgeInsets margin;

  SingleOrderComponent({
    required this.order,
    required this.status,
    required this.expectedDate,
    required this.orderId,
    this.avatarUrl,
    this.margin = const EdgeInsets.only(
      left: 20,
      right: 2,
      bottom: 5,
      top: 5,
    ),
    required this.stationName,
    required this.customerName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SingleOrderView(order: order),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width - 50,
        padding: const EdgeInsets.symmetric(
          vertical: 25,
          horizontal: 15,
        ),
        margin: margin,
        decoration: BoxDecoration(
          // color: Theme.of(context).primaryColor.withOpacity(.08),
          color: Theme.of(context).backgroundColor,
          // border: Border.all(
          //   color: Color.fromARGB(255, 100, 100, 100),
          //   width: 1,
          // ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color.fromARGB(255, 206, 206, 206),
              offset: Offset(0, 2),
              spreadRadius: 1,
            )
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      minRadius: 18,
                      maxRadius: 20,
                      child: Text(
                        customerName[0].toUpperCase(),
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              color: kTextLight,
                            ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "$customerName\n",
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    height: 0.8,
                                  ),
                        ),
                        Text(
                          "$stationName\n",
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    height: 0.2,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
                Chip(
                  backgroundColor:
                      Theme.of(context).colorScheme.tertiary.withOpacity(.3),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    child: Text(
                      status,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '${DateTime.parse(expectedDate).toMoment().toString()}\n',
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    fontSize: 16,
                                  ),
                        ),
                        TextSpan(
                          text: "Expected pickup date",
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    height: 1.3,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "$orderId\n",
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    fontSize: 16,
                                  ),
                        ),
                        TextSpan(
                          text: "Order Number",
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    height: 1.3,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
