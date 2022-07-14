import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/pages/launderMarts/onboarding/pages/selection.dart';
import 'package:msafi_mobi/providers/user.provider.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:provider/provider.dart';

import '../../../../providers/merchant.provider.dart';
import 'customize.dart';

class BasicInformation extends StatefulWidget {
  const BasicInformation({Key? key}) : super(key: key);

  @override
  State<BasicInformation> createState() => _BasicInformationState();
}

class _BasicInformationState extends State<BasicInformation> {
  // state variables to hold inital values
  String address = "";
  String name = "";
  String description = "";
  String phone = "";

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _storeInfo() {
      // saves the user info into the Mart providers [localstore]

      final form = _formKey.currentState;

      if (form!.validate()) {
        form.save();

        context.read<MartConfig>().setAddress(address);
        context.read<MartConfig>().setDescription(description);
        context.read<MartConfig>().setName(name);
        context.read<MartConfig>().setPhone(phone);

        // navigate to next page
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ProductSelection(),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        bottomOpacity: .3,
        elevation: 1,
        backgroundColor: Theme.of(context).canvasColor,
        centerTitle: true,
        title: Text(
          "Getting Started",
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontSize: 18,
              ),
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        child: Container(
          width: MediaQuery.of(context).size.height,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
          ),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "\n\nWelcome ${context.read<User>().name} Let's Build Together!",
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextSpan(
                        text:
                            "\n\nPlease fill the infomation correctly to proceed\n",
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
                    ],
                  ),
                ),
                customTextField(
                  hint: "e.g Laundry X",
                  label: "What's Your business name?",
                  validator: (value) {
                    if (value.length < 3 || value.isEmpty) {
                      return 'Business name is required';
                    }
                    return null;
                  },
                  icon: const Icon(
                    Icons.houseboat,
                    size: 18,
                  ),
                  inputType: TextInputType.name,
                  onSubmit: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                  onChanged: (val) {},
                ),
                const SizedBox(
                  height: 10,
                ),
                customTextField(
                  hint: "0700 000 000",
                  label: "Business Contact",
                  validator: (value) {
                    final pattern = RegExp(r'^0[0-9]+');
                    if (value.length < 10 ||
                        value.length > 10 ||
                        !pattern.hasMatch(value)) {
                      return 'Business contact is required';
                    }
                    return null;
                  },
                  icon: const Icon(
                    Icons.phone_outlined,
                    size: 18,
                  ),
                  inputType: TextInputType.name,
                  onSubmit: (val) {
                    setState(() {
                      phone = val;
                    });
                  },
                  onChanged: (val) {},
                ),
                const SizedBox(
                  height: 10,
                ),
                customTextField(
                  hint: "Business Address",
                  label: "Where can clients Find You?",
                  inputType: TextInputType.streetAddress,
                  validator: (value) {
                    if (value.length < 5 || value.isEmpty) {
                      return 'Business address is required';
                    }
                    return null;
                  },
                  icon: const Icon(
                    Icons.streetview_outlined,
                    size: 18,
                  ),
                  onChanged: (val) {},
                  onSubmit: (val) {
                    setState(() {
                      address = val;
                    });
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                customTextField(
                  hint: "Description",
                  validator: (value) {
                    if (value.length < 15 || value.isEmpty) {
                      return 'Description is required';
                    }
                    return null;
                  },
                  label: "Tell us about Your Business",
                  inputType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: null,
                  icon: const Icon(
                    Icons.description,
                    size: 18,
                  ),
                  onChanged: (val) {},
                  onSubmit: (val) {
                    setState(() {
                      description = val;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                customExtendButton(
                  ctx: context,
                  child: Text(
                    "Next",
                    style: GoogleFonts.notoSans(
                      fontSize: 20,
                      color: kTextLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _storeInfo,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
