import 'package:flutter/material.dart';
import 'package:msafi_mobi/providers/basket.providers.dart';
import 'package:provider/provider.dart';

class Bucket extends StatefulWidget {
  const Bucket({Key? key}) : super(key: key);

  @override
  State<Bucket> createState() => _BucketState();
}

class _BucketState extends State<Bucket> {
  // fetch images from localstore
  List<int> basket = [];
  List storeClothes = [];

  @override
  void initState() {
    super.initState();
  }

  List _updateCart() {
    List temp = [];
    for (var i = 0; i < basket.length; i++) {
      if (basket[i] > 0) {
        temp.add({
          ...storeClothes[i],
          "count": basket[i],
        });
      }
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    final bucket = context.read<Basket>().bucketList;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 1,
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
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 30,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          children: List.generate(bucket.length, (index) {
            // return Container();
            return LaundryBox(
              decreament: () {
                if (basket[index] > 0) {
                  setState(() {
                    basket[index] = basket[index] - 1;
                  });
                }
              },
              increament: () {
                setState(() {
                  basket[index] = basket[index] + 1;
                });
              },
              value: bucket[index]['count'],
              price:
                  (bucket[index]['price'] * bucket[index]['count']).toString(),
              title: bucket[index]['id'],
              image: bucket[index]['imagePath'],
            );
          }),
        ),
      ),
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
