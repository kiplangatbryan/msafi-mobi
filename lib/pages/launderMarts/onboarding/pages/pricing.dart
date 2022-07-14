import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../providers/merchant.provider.dart';
import 'map_summary.dart';

class SetPricingPage extends StatefulWidget {
  const SetPricingPage({Key? key}) : super(key: key);

  @override
  State<SetPricingPage> createState() => _SetPricingPagestate();
}

class _SetPricingPagestate extends State<SetPricingPage> {
  final PageController _pageController = PageController(initialPage: 0);
  late int page;

  final _origBtnText = "Save";
  final String _finishBtnText = "Save and Continue";
  // variables to keep track of data
  double price = 0;
  String id = "";
  String _btnText = "Save";

// form field controller
  final _formKey = GlobalKey<FormState>();

  // text editing controller
  final _formFieldController = TextEditingController();

  List clothPrices = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      page = _pageController.initialPage;
      clothPrices = List.filled(context.read<MartConfig>().count, null);
    });
  }

// update price of item
  _setPrice() async {
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();
      late String clothid;
      if (id == "") {
        clothid = context.read<MartConfig>().getClothes[0]['title'];
        clothPrices[page] = {"id": clothid, "price": price};
      } else {
        clothPrices[page] = {"id": id, "price": price};
      }
      setState(() {
        _btnText = "Saved";
      });

      // save all the to store
      if (page + 1 == context.read<MartConfig>().count) {
        await _updateStoreInformation();
        return;
      }
      _pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    }
  }

  // reset recurrent fields
  _clearAndSetField() {
    _formFieldController.clear();
    // reset button text
    setState(() {
      _btnText = _origBtnText;
    });

    if (clothPrices[page] != null) {
      _formFieldController.text = clothPrices[page]["price"].toString();
    }
  }

  // persist changes in global provider
  _updateStoreInformation() async {
    context.read<MartConfig>().setPricing(clothPrices);
    // final authToken = await checkAndValidateAuthToken();
    // final response =
    //     // ignore: use_build_context_synchronously
    //     await context.read<MartConfig>().createOrUpdateStore(authToken);

    // ignore: use_build_context_synchronously
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const MapIntro()));
  }

  @override
  Widget build(BuildContext context) {
    _goback() {
      return Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, size: 18),
          onPressed: _goback,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          "Set cloth prices",
          style: GoogleFonts.notoSans(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: (MediaQuery.of(context).size.height) / 2 - 70,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    page = index;
                    id = context.read<MartConfig>().getClothes[index]['title'];

                    // cleat text field and set old values
                    _clearAndSetField();
                  });
                },
                // ignore: prefer_const_literals_to_create_immutables
                children: List.generate(
                  context.read<MartConfig>().count,
                  (index) {
                    return clothView(
                      imgUrl: context
                          .read<MartConfig>()
                          .getClothes[index]['imagePath']
                          .toString(),
                      title: context
                          .read<MartConfig>()
                          .getClothes[index]['title']
                          .toString(),
                    );
                  },
                ),
              ),
            ),
            Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                effect: const ExpandingDotsEffect(
                  activeDotColor: kSmoothIndicator,
                  dotColor: kTextLightColor,
                  dotHeight: 13,
                  dotWidth: 13,
                ),
                count: context.read<MartConfig>().count,
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: customInput(onSaved: (val) {
                    setState(() {
                      price = double.parse(val);
                    });
                  }),
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () {
                    _setPrice();
                  },
                  // ignore: prefer_const_constructors
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    enableFeedback: true,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 50,
                    ),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    page + 1 == context.read<MartConfig>().count
                        ? _finishBtnText
                        : _btnText,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: kTextLight,
                          fontSize: 25,
                        ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding clothView({
    required String title,
    required String imgUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 40,
        horizontal: 20,
      ),
      child: Column(
        children: [
          Image(
            image: AssetImage(imgUrl),
            height: 180,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            title,
            style: GoogleFonts.notoSans(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: kTextColor.withOpacity(.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget customInput({
    required Function onSaved,
  }) {
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _formFieldController,
        onChanged: (val) {},
        onSaved: (val) => onSaved(val),
        cursorColor: kTextColor,
        cursorHeight: 20,
        keyboardType: TextInputType.number,
        style: GoogleFonts.notoSans(
          color: kTextColor,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        validator: (val) {
          if (val!.isEmpty) {
            return "Price cannot be empty";
          }
        },
        decoration: InputDecoration(
          hintText: "E.g 100",
          hintStyle: GoogleFonts.notoSans(
            color: kTextMediumColor.withOpacity(.5),
            fontSize: 17,
          ),
          labelText: "Price Tag",
          labelStyle: GoogleFonts.notoSans(
            color: kTextMediumColor.withOpacity(.8),
            fontSize: 17,
          ),
          floatingLabelStyle: GoogleFonts.notoSans(
            color: kTextMediumColor.withOpacity(.8),
            fontSize: 17,
          ),
          filled: true,
          fillColor: Theme.of(context).primaryColor.withOpacity(.06),
          prefixIcon: const Icon(Icons.account_balance, size: 22),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: kTextMediumColor.withOpacity(.1),
            ),
            gapPadding: 10,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor.withOpacity(.3),
            ),
            gapPadding: 10,
          ),
        ),
      ),
    );
  }
}
