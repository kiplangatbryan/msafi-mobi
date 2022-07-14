// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/pages/regular/processing/bucket.dart';
import 'package:msafi_mobi/providers/basket.providers.dart';
import 'package:provider/provider.dart';

import '../../../providers/store.providers.dart';
import '../../../themes/main.dart';

class LaundrySelection extends StatefulWidget {
  int index;
  LaundrySelection({required this.index, Key? key}) : super(key: key);

  @override
  State<LaundrySelection> createState() => _LaundrySelectionState();
}

class _LaundrySelectionState extends State<LaundrySelection> {
  final searchController = TextEditingController();
  // fetch images from localstore
  List<int> basket = [];
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
      basket = List.filled(storeClothes.length, 0);
    });
    // push tracking values to store
    context.read<Basket>().setPricing(storeClothes);
    context.read<Basket>().createBucket(basket);
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {
              // updateBusketStore();
            },
            icon: Icon(
              Icons.shopping_bag_outlined,
              size: 30,
              color: Theme.of(context).colorScheme.primary.withOpacity(.7),
            ),
          )
        ],
        title: searchBar(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 100,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            children: List.generate(storeClothes.length, (index) {
              // return Container();
              return LaundryBox(
                  decreament: () {
                    context.read<Basket>().decreament(index: index);
                  },
                  increament: () {
                    context.read<Basket>().increament(index: index);
                  },
                  value: context.watch<Basket>().basket[index],
                  price: storeClothes[index]['price'].toString(),
                  title: storeClothes[index]['id'],
                  image: storeClothes[index]['imagePath']);
            }),
          ),
        ),
      ),
      bottomSheet: BottomSheet(
          // elevation: 30,
          onClosing: () {},
          builder: (BuildContext context) {
            return Container(
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
              child: customExtendButton(
                  ctx: context,
                  child: Text(
                    "Go to Basket",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: kTextLight,
                        ),
                  ),
                  onPressed: () {
                    context.read<Basket>().calculateTotal();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => Bucket(index: widget.index)));
                  }),
            );
          }),
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
