import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/configs/data.dart';
import 'package:msafi_mobi/pages/launderMarts/onboarding/pages/location.dart';
import 'package:msafi_mobi/pages/launderMarts/onboarding/pages/pricing.dart';
import 'package:msafi_mobi/providers/mart.provider.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:provider/provider.dart';

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
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_outlined, size: 18),
            onPressed: _goback,
            color: kTextMediumColor,
          ),
          title: const Text(
            "Cloth selection",
            style: TextStyle(
              color: kTextMediumColor,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "\nTime To Pick Your Poison",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: kTextColor,
                        ),
                      ),
                      TextSpan(
                        text: "\n\n' ✨ 'Tap on clothing items that you wash",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: kTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                LimitedBox(
                  maxHeight: 930,
                  child: clothSelect(),
                ),
                customButton(
                  title: "Next ($selectedItems)",
                  role: "login",
                  callback: () {
                    // make selection persist
                    context
                        .read<MartConfig>()
                        .mapSelectedItems(addSelectedClothes());

                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const SetPricingPage(),
                      ),
                    );
                  },
                ),
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
    return GridView(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180,
        mainAxisSpacing: 6.0,
        crossAxisSpacing: 6.0,
      ),
      physics: const ScrollPhysics(),
      children: List.generate(
        fetchClothes().length,
        (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selected[index] = selected[index] == null ? true : null;
              });
            },
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: selected[index] != null
                    ? kSelectionActive.withOpacity(.3)
                    : kTextMediumColor.withOpacity(.1),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(
                      fetchClothes()[index]['imagePath'].toString(),
                    ),
                    height: 70,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    fetchClothes()[index]['title'].toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kTextMediumColor.withOpacity(.9),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
