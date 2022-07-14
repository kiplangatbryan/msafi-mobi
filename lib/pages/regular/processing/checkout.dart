import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../../providers/orders.providers.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({Key? key}) : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  List clothesArr = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      clothesArr = context.read<Order>().clothesArray;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.shopping_bag_outlined,
              size: 30,
              color: Theme.of(context).colorScheme.primary.withOpacity(.7),
            ),
          )
        ],
        title: Text(
          "Review and Checkout",
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Summary",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: List.generate(
                clothesArr.length,
                (index) {
                  final count = clothesArr[index]['count'];
                  final total = (clothesArr[index]['price'] * count);
                  final title = clothesArr[index]['id'];
                  return Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: count.toString(),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            TextSpan(
                              text: " x ",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            TextSpan(
                              text: title,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        total.toString(),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              children: [
                Text(
                  "Total",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  context.read<Order>().getAmount.toString(),
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            checkOutItem(
              btnLabel: "change",
              onPressed: () {},
              title: "Launder Clothes",
              value: "6 items",
            ),
            checkOutItem(
              btnLabel: "change",
              onPressed: () {},
              title: "Launder Clothes",
              value: "6 items",
            ),
          ],
        ),
      )),
    );
  }
}

class checkOutItem extends StatelessWidget {
  String title;
  String value;
  Function onPressed;
  String btnLabel;

  checkOutItem({
    required this.title,
    required this.value,
    required this.btnLabel,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headline6,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  btnLabel,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
