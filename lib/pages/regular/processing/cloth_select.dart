// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/configs/data.dart';
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
  final clothes = fetchClothes();
  late final basket;
  late final storeClothes;

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
  }

  List _getImgUrl(String id) {
    List temp = [];
    temp.addAll(clothes);
    // return clothes.where((element) => element['id'] == id);
    temp.retainWhere((element) => element['title'] == id);
    return temp;
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 30,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          children: List.generate(storeClothes.length, (index) {
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
                  // print(basket[index]++);
                  basket[index] = basket[index] + 1;
                });
              },
              value: basket[index],
              price: storeClothes[index]['price'].toString(),
              title: storeClothes[index]['id'],
              image: _getImgUrl(storeClothes[index]['id'])[0]['imagePath'],
            );
          }),
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
        color: Theme.of(context).primaryColor.withOpacity(.08),
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
