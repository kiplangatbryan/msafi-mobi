import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/pages/launderMarts/onboarding/pages/finish_line.dart';
import 'package:msafi_mobi/providers/user.provider.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SetPricingPage extends StatefulWidget {
  const SetPricingPage({Key? key}) : super(key: key);

  @override
  State<SetPricingPage> createState() => _SetPricingPagestate();
}

class _SetPricingPagestate extends State<SetPricingPage> {
  final PageController _pageController = PageController(initialPage: 0);
  late int page;

  double price = 0;
  String id = "";
  final _origBtnText = "save";
  String _btnText = "save";
  bool _btnPressed = false;

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

  _setPrice() {
    setState(() {
      _btnText = "Saved";
      _btnPressed = true;
    });
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
    }
  }

  Widget finishButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const FinishPage(),
          ),
        );
      },
      // ignore: prefer_const_constructors
      style: ElevatedButton.styleFrom(
        primary: kPrimaryColor,
        enableFeedback: true,
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 50,
        ),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        "Finish",
        style: GoogleFonts.notoSans(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  _clearAndSetField() {
    _formFieldController.clear();
    // reset button text
    setState(() {
      _btnText = _origBtnText;
      _btnPressed = false;
    });

    if (clothPrices[page] != null) {
      _formFieldController.text = clothPrices[page]["price"].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    _goback() {
      return Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, size: 18),
          onPressed: _goback,
          color: kTextMediumColor,
        ),
        title: Text(
          "Set cloth prices",
          style: GoogleFonts.notoSans(
            fontSize: 20,
            color: kTextMediumColor,
            fontWeight: FontWeight.bold,
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
                    primary: splashColor,
                    enableFeedback: true,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 50,
                    ),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    _btnText,
                    style: GoogleFonts.notoSans(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                page + 1 == context.read<MartConfig>().count && _btnPressed
                    ? finishButton()
                    : Container(),
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
            color: kTextMediumColor.withOpacity(.3),
            fontSize: 18,
          ),
          labelText: "KSH",
          labelStyle: GoogleFonts.notoSans(
            color: kTextMediumColor.withOpacity(.4),
            fontSize: 15,
          ),
          floatingLabelStyle: GoogleFonts.notoSans(
            color: kTextMediumColor.withOpacity(.4),
            fontSize: 22,
          ),
          filled: true,
          fillColor: kTextMediumColor.withOpacity(.06),
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
              color: kTextMediumColor.withOpacity(.4),
            ),
            gapPadding: 10,
          ),
        ),
      ),
    );
  }
}
