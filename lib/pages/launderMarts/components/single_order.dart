import 'package:flutter/material.dart';
import 'package:moment_dart/moment_dart.dart';

import '../orders/single-order.dart';

class SingleOrderComponent extends StatelessWidget {
  Map order;
  String status;
  String expectedDate;
  String orderId;
  String? avatarUrl = "";
  String stationName;
  String customerName;

  SingleOrderComponent({
    required this.order,
    required this.status,
    required this.expectedDate,
    required this.orderId,
    this.avatarUrl,
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
        margin: const EdgeInsets.only(
          left: 25,
          right: 25,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.rectangle,
                        size: 25,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "$customerName\n",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          TextSpan(
                            text: "$stationName\n",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Chip(
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  label: Text(
                    status,
                    style: Theme.of(context).textTheme.headline6,
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
