import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/store/mart.dart';
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

  @override
  void initState() {
    super.initState();
    setState(() {
      page = _pageController.initialPage;
    });
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
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: kTextMediumColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: LimitedBox(
            maxHeight: 800,
            child: Stack(
              children: [
                PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      page = index;
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
                Positioned(
                  top: 340,
                  right: 0,
                  left: 0,
                  child: Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      effect: const ExpandingDotsEffect(
                        activeDotColor: kSmoothIndicator,
                        dotColor: kTextLightColor,
                        dotHeight: 12,
                        dotWidth: 12,
                      ),
                      count: context.read<MartConfig>().count,
                    ),
                  ),
                ),
                Positioned(
                    top: 40,
                    left: 30,
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: const BoxDecoration(
                        color: splashColor,
                      ),
                      child: Center(
                        child: Text(
                          context.read<MartConfig>().count.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ),
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
            height: 200,
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: kTextColor.withOpacity(.8),
            ),
          ),
          const SizedBox(
            height: 70,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: customInput(),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {},
            // ignore: prefer_const_constructors
            style: ElevatedButton.styleFrom(
              primary: splashColor,
              enableFeedback: true,
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 40,
              ),
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "Set",
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget customInput() {
  return TextFormField(
    onChanged: (val) {},
    onFieldSubmitted: (val) {},
    cursorColor: kTextColor,
    cursorHeight: 20,
    keyboardType: TextInputType.number,
    style: GoogleFonts.poppins(
      color: kTextColor,
      fontWeight: FontWeight.w600,
      fontSize: 14,
    ),
    decoration: InputDecoration(
      hintText: "E.g 100",
      hintStyle: GoogleFonts.poppins(
        color: kTextMediumColor.withOpacity(.3),
        fontSize: 18,
      ),
      labelText: "KSH",
      labelStyle: GoogleFonts.poppins(
        color: kTextMediumColor.withOpacity(.4),
        fontSize: 15,
      ),
      floatingLabelStyle: GoogleFonts.poppins(
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
  );
}
