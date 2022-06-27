import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/components/form_components.dart';
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
          child: Container(
            width: double.infinity,
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
                  icon: Icon(
                    Icons.houseboat,
                    size: 18,
                  ),
                  inputType: TextInputType.name,
                  onSubmit: () {},
                  onChanged: () {},
                ),
                const SizedBox(
                  height: 15,
                ),
                customTextField(
                  hint: "Business Address",
                  label: "Where can clients Find You?",
                  inputType: TextInputType.streetAddress,
                  icon: Icon(
                    Icons.streetview_outlined,
                    size: 18,
                  ),
                  onChanged: () {},
                  onSubmit: () {},
                ),
                const SizedBox(
                  height: 15,
                ),
                customTextField(
                  hint: "Description",
                  label: "Tell us about Your Business",
                  inputType: TextInputType.multiline,
                  icon: Icon(
                    Icons.description,
                    size: 18,
                  ),
                  onChanged: () {},
                  onSubmit: () {},
                ),
                Spacer(),
                customButton(
                  title: "Continue",
                  role: "login",
                  callback: () {},
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
