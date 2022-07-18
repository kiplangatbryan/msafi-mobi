// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/pages/regular/processing/bucket.dart';
import 'package:msafi_mobi/providers/basket.providers.dart';
import 'package:provider/provider.dart';

import '../../../providers/store.providers.dart';
import '../../../themes/main.dart';
import '../components/laundry_box.dart';

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

  _proceed() {
    // calculate total
    context.read<Basket>().calculateTotal();

    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => Bucket(
          index: widget.index,
        ),
      ),
    );
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
            onPressed: () {},
            icon: Icon(
              Icons.search,
              size: 30,
              color: Theme.of(context).colorScheme.primary.withOpacity(.7),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.shopping_bag_outlined,
              size: 30,
              color: Theme.of(context).colorScheme.primary.withOpacity(.7),
            ),
          ),
        ],
        title: Text("Select clothes",
            style: Theme.of(context).textTheme.headline6),
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
          child: ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: storeClothes.length,
              itemBuilder: (context, index) {
                print(storeClothes);
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

          // return Container();
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
                    "${context.watch<Basket>().getCount} items",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontSize: 18,
                        ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LimitedBox(
                    maxWidth: 210,
                    child: customSmallBtn(
                      ctx: context,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Go to Bucket",
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      color: kTextLight,
                                    ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.shopping_bag_outlined,
                            size: 23,
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
