import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/pages/globals-components/components.dart';
import 'package:msafi_mobi/pages/launderMarts/onboarding/pages/selection.dart';
import 'package:msafi_mobi/themes/main.dart';

class BasicInformation extends StatelessWidget {
  const BasicInformation({Key? key}) : super(key: key);

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
            "Getting Started",
            style: TextStyle(
              color: kTextMediumColor,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "\n\n\nWelcome Friend\nLet's Build Together!",
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: kTextColor,
                          ),
                        ),
                        TextSpan(
                          text:
                              "\n\nPlease fill the infomation correctly to proceed\n",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: kTextColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  customTextField(
                    hint: "e.g John's Laundry",
                    label: "What's Your business name?",
                    fieldType: 'name',
                    iconType: "bs_name",
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  customTextField(
                    hint: "Business Address",
                    label: "Where can clients Find You?",
                    fieldType: 'address',
                    iconType: "bs_address",
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  customTextField(
                    hint: "Description",
                    label: "Tell us about Your Business",
                    fieldType: 'textarea',
                    iconType: "bs_info",
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  actionButton(
                    callback: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => const ProductSelection(),
                        ),
                      );
                    },
                    title: "Alright, Lets Proceed",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
