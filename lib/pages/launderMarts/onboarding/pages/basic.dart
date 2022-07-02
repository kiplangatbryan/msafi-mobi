import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/pages/launderMarts/onboarding/pages/selection.dart';
import 'package:msafi_mobi/providers/mart.provider.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:provider/provider.dart';

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

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _feedValues({required String key, required String value}) {
    print('called');
    switch (key) {
      case "description":
        setState(() {
          description = value;
        });
        break;
      case "name":
        setState(() {
          name = value;
        });
        break;
      case "address":
        setState(() {
          address = value;
        });
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _goback() {
      // navigate to the previous screen
      return Navigator.of(context).pop();
    }

    _storeInfo() {
      // saves the user info into the Mart providers [localstore]

      final form = _formKey.currentState;

      if (form!.validate()) {
        form.save();

        context.read<MartConfig>().setAddress(address);
        context.read<MartConfig>().setDescription(description);
        context.read<MartConfig>().setName(name);
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
                        text: "\n\nWelcome Partner Let's Build Together!",
                        style: GoogleFonts.poppins(
                          fontSize: 33,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
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
                  hint: "Business Address",
                  label: "Where can clients Find You?",
                  inputType: TextInputType.streetAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
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
                    if (value == null || value.isEmpty) {
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
                customButton(
                  title: "Continue",
                  role: "register",
                  callback: _storeInfo,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
