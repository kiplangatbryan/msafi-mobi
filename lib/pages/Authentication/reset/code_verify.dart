import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/helpers/http_services.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../providers/user.provider.dart';

class CodeVerify extends StatefulWidget {
  const CodeVerify({Key? key}) : super(key: key);

  @override
  State<CodeVerify> createState() => _CodeVerifyState();
}

class _CodeVerifyState extends State<CodeVerify> {
// https://aa5a-41-89-160-19.in.ngrok.io
  String errors = "";
  String snackBarMessage = "";
  bool showSnack = false;
  bool loading = false;

// form key
  final _formKey = GlobalKey<FormState>();

// user map
  final Map<String, String> user = {
    "code": "",
  };

  @override
  void initState() {
    super.initState();
  }

  _setEmail(val) {
    setState(() {
      user['code'] = val;
    });
  }

// populate user in user map

  _postErrors(msg) {
    setState(() {
      errors = msg;
    });
  }

  _nextPage() {
    // create a user object and check type
    final role = context.read<User>().role;
    if (role == "merchant") {
      Navigator.popAndPushNamed(context, "/mart-onboarding");
    } else if (role == "user") {
    } else {
      // do nothing
    }
  }

  // snack bar
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> customSnackBar(
      String message) {
    setState(() {
      snackBarMessage = message;
    });
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(snackBarMessage),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      ),
    );
  }

// called when form is submitted
  _onSubmit() async {
    // get current state of Form
    final form = _formKey.currentState;
    // Navigator.of(context).pushNamed('/mart-onboarding');
    if (form!.validate()) {
      // call saved event on every textfield on the form
      form.save();
      // show loading
      setState(() {
        loading = true;
      });
      var url = Uri.parse('${baseUrl()}/auth/forgot-password');

      try {
        // send data to server
        final response = await http
            .post(
              url,
              body: user,
            )
            .timeout(
              const Duration(seconds: 5),
            );

        // final data = json.decode(response.body);

        if (response.statusCode == 200) {
        } else {
          _postErrors("Email or password is Incorrect");
        }
      } on SocketException {
        customSnackBar('Could not connect to server');
      } on TimeoutException catch (e) {
        customSnackBar("Connection Timeout");
      } on Error catch (e) {
        customSnackBar("An error ocurred");
      }
      setState(() {
        loading = false;
      });
    }
  }

  // handleErrors() {}
  _handleUserSignIn(dynamic data) async {
    // call to User<> provider
    final res = await context.read<User>().createUser(data);
    if (res) {
      customSnackBar("Success");
      _nextPage();
    } else {
      customSnackBar("Error occurred whilst saving");
    }

    setState(() {
      loading = false;
    });
  }

  _navigateToRegister() {
    Navigator.of(context).pushNamed('/register');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          bottomOpacity: .3,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 22),
            onPressed: () => Navigator.of(context).pop(),
            color: kTextColor,
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "\nEnter Reset Code to Verify",
                          style: GoogleFonts.notoSans(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        TextSpan(
                          text:
                              "\n\nWe need to verify the code that was sent to your email address\n\n",
                          style: GoogleFonts.notoSans(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    errors,
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customTextField(
                          inputType: TextInputType.text,
                          icon: const Icon(Icons.mail_outline, size: 18),
                          hint: "reset code",
                          label: "code",
                          onChanged: (val) {},
                          onSubmit: _setEmail,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field cannot be blank';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        customExtendButton(
                          ctx: context,
                          child: Text(
                            "Verify",
                            style: GoogleFonts.notoSans(
                              color: kTextLight,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: _onSubmit,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: kTextMediumColor.withOpacity(.1),
                        width: 1,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
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
