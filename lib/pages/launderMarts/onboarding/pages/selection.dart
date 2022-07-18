import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/configs/data.dart';
import 'package:msafi_mobi/pages/launderMarts/onboarding/pages/pricing.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:provider/provider.dart';

import '../../../../providers/merchant.provider.dart';

class ProductSelection extends StatefulWidget {
  const ProductSelection({Key? key}) : super(key: key);

  @override
  State<ProductSelection> createState() => _ProductSelectionState();
}

class _ProductSelectionState extends State<ProductSelection> {
  final List<dynamic> selected = List.filled(fetchClothes().length, null);

  @override
  void initState() {
    super.initState();

    setState(() {});
  }

  List<Map> addSelectedClothes() {
    var allClothes = fetchClothes();
    List<Map> clothes = [];

    for (var i = 0; i < selected.length; i++) {
      if (selected[i] == true) {
        clothes.add(allClothes[i]);
      }
    }

    return clothes;
  }

  get selectedItems {
    var count = 0;
    for (var element in selected) {
      if (element == true) {
        count += 1;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    _goback() {
      return Navigator.of(context).pop();
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          bottomOpacity: .3,
          elevation: 1,
          backgroundColor: Theme.of(context).canvasColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_outlined, size: 18),
            onPressed: _goback,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Text(
            "Cloth selection",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: "\n\nChoose your business product",
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  )),
                      TextSpan(
                        text:
                            "\n\n' ✨ 'Tap on clothing items that you wash, you can choose more than one",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                clothSelect(),
                const SizedBox(
                  height: 40,
                ),
                customExtendButton(
                    ctx: context,
                    child: Text(
                      "Next ( $selectedItems )",
                      style: GoogleFonts.notoSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      context
                          .read<MartConfig>()
                          .mapSelectedItems(addSelectedClothes());

                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => const SetPricingPage(),
                        ),
                      );
                    }),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GridView clothSelect() {
    final count = fetchClothes().length;
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180,
        mainAxisSpacing: 6.0,
        crossAxisSpacing: 6.0,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: count,
      itemBuilder: (BuildContext context, index) {
        return InkWell(
          onTap: () {
            setState(() {
              selected[index] = selected[index] == null ? true : null;
            });
          },
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: selected[index] != null
                  ? Theme.of(context).indicatorColor
                  : kTextLight,
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(.2),
                  blurRadius: 2,
                  offset: const Offset(2, 6),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(
                    fetchClothes()[index]['imagePath'].toString(),
                  ),
                  height: 50,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  fetchClothes()[index]['title'].toString(),
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    color: selected[index] != null
                        ? Theme.of(context).scaffoldBackgroundColor
                        : Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
