import 'package:flutter/material.dart';
import 'package:msafi_mobi/pages/regular/processing/checkout.dart';
import 'package:msafi_mobi/pages/regular/processing/payment_options.dart';
import 'package:msafi_mobi/pages/regular/processing/pickup_spots.dart';
import 'package:flutter/cupertino.dart';

import 'package:msafi_mobi/providers/basket.providers.dart';
import 'package:provider/provider.dart';

import '../../../components/form_components.dart';
import '../../../providers/orders.providers.dart';
import '../../../providers/store.providers.dart';
import '../../../themes/main.dart';
import '../components/laundry_box.dart';

class Bucket extends StatefulWidget {
  int index;
  Bucket({required this.index, Key? key}) : super(key: key);

  @override
  State<Bucket> createState() => _BucketState();
}

class _BucketState extends State<Bucket> {
  // fetch images from localstore
  List storeClothes = [];

  @override
  void initState() {
    super.initState();
    _initStore();
  }

  _initStore() {
    final storeInf = context.read<Store>().stores;
    setState(() {
      storeClothes = storeInf[widget.index]['pricing'];
    });
  }

  _proceed() {
    final amount = context.read<Basket>().getTotal;
    final clothes = context.read<Basket>().listOfClothes();
    context.read<Order>().setAmount(amount);
    context.read<Order>().setClothes(clothes);
    Navigator.of(context)
        .push(CupertinoPageRoute(builder: (_) => const PickUpSpots()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
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
        title: Text(
          "My Bucket",
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 30,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            children: List.generate(storeClothes.length, (index) {
              // return Container();
              int value = context.read<Basket>().basket[index];
              final price = storeClothes[index]['price'];

              return value > 0
                  ? LaundryBox(
                      decreament: () {
                        context
                            .read<Basket>()
                            .decreament(index: index, isCart: true);
                      },
                      increament: () {
                        context
                            .read<Basket>()
                            .increament(index: index, isCart: true);
                      },
                      value: context.watch<Basket>().basket[index],
                      price: (price * context.watch<Basket>().basket[index])
                          .toString(), //the price pulled * count
                      title: storeClothes[index]['id'],
                      image: storeClothes[index]['imagePath'],
                    )
                  : Container();
            }),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.warning),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Total: ksh ${context.watch<Basket>().getTotal}",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  LimitedBox(
                    maxWidth: 180,
                    child: customSmallBtn(
                      ctx: context,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Checkout",
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      color: kTextLight,
                                    ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          )
                        ],
                      ),
                      onPressed: () => _proceed(),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
