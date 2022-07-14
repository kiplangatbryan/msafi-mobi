import 'package:flutter/material.dart';
import 'package:msafi_mobi/pages/regular/processing/checkout.dart';
import 'package:msafi_mobi/providers/basket.providers.dart';
import 'package:provider/provider.dart';

import '../../../components/form_components.dart';
import '../../../providers/orders.providers.dart';
import '../../../providers/store.providers.dart';
import '../../../themes/main.dart';

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

  @override
  Widget build(BuildContext context) {
    final bucket = context.read<Basket>().bucketList;

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
      bottomSheet: BottomSheet(
          // elevation: 30,
          onClosing: () {},
          builder: (BuildContext context) {
            return Container(
              height: 150,
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black,
                      spreadRadius: 5,
                      offset: Offset(0, 8),
                    )
                  ],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 20,
              ),
              child: Column(
                children: [
                  Text(
                    "Total \$ ${context.watch<Basket>().getTotal}",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  customExtendButton(
                      ctx: context,
                      child: Text(
                        "Proceed to Chekout",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: kTextLight,
                            ),
                      ),
                      onPressed: () {
                        final amount = context.read<Basket>().getTotal;
                        final clothes = context.read<Basket>().listOfClothes();
                        context.read<Order>().setAmount(amount);
                        context.read<Order>().setClothes(clothes);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const CheckOut()));
                      }),
                ],
              ),
            );
          }),
    );
  }
}

class LaundryBox extends StatelessWidget {
  String title;
  String price;
  String image;
  int value;
  Function increament;
  Function decreament;

  LaundryBox({
    required this.image,
    required this.title,
    required this.value,
    required this.price,
    required this.increament,
    required this.decreament,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(.04),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image(
            image: AssetImage(image),
            width: 80,
          ),
          Column(children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () => decreament(),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: 2,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(.5),
                        )),
                    child: const Center(
                      child: Icon(Icons.remove),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  value.toString(),
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => increament(),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: 2,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(.5),
                        )),
                    child: const Center(
                      child: Icon(Icons.add),
                    ),
                  ),
                )
              ],
            )
          ]),
          Text(
            "KES $price",
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}
