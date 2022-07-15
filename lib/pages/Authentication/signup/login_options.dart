import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/themes/main.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../helpers/http_services.dart';
import '../../../providers/user.provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String errors = "";
  String status = "Login";
  String snackBarMessage = "";
  bool showSnack = false;
  bool loading = false;

  // form key
  final _formKey = GlobalKey<FormState>();

  // user information
  final Map<String, String> user = {
    "email": "",
    "password": "",
    "name": "",
  };

  @override
  void initState() {
    super.initState();
  }

  _setName(String val) {
    setState(() {
      user['name'] = val.trim();
    });
  }

  _setEmail(String val) {
    setState(() {
      user['email'] = val.trim();
    });
  }

  _postErrors(message) {
    setState(() {
      errors = message;
    });
  }

  _setPassword(String val) {
    setState(() {
      user['password'] = val.trim();
    });
  }

  _nextPage() {
    Navigator.popAndPushNamed(context, "/default-home");
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

  // perform clean up
  _disposeData() {
    // set errors to blank
    _postErrors("");
  }

  // called when form is submitted
  _onSubmit() async {
    _disposeData();
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
      var url = Uri.parse('${baseUrl()}/auth/register');

      try {
        // send data to server
        final response = await http.post(
          url,
          body: {...user, "role": "user"},
        ).timeout(
          const Duration(seconds: 10),
        );

        final data = json.decode(response.body);

        if (response.statusCode == 201) {
          return await _handleUserSignIn(data);
        } else {
          _postErrors(data['message']);
        }
      } on SocketException {
        customSnackBar('Could not connect to server');
      } on TimeoutException catch (e) {
        customSnackBar("Connection Timeout ${e.toString()}");
      } on Error catch (e) {
        customSnackBar("An error ocurred ${e.toString()}");
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

  _navigateToLogin() {
    return Navigator.of(context).pushNamed('/login');
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
            icon: const Icon(Icons.arrow_back_ios_new, size: 24),
            onPressed: _goback,
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
                          text: "\nCreate an account",
                          style: GoogleFonts.notoSans(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        TextSpan(
                          text:
                              "\n\nPlease enter your valid data in order to create an account\n\n",
                          style: GoogleFonts.notoSans(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "$errors\n",
                                style: GoogleFonts.notoSans(
                                  fontSize: 15,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        customTextField(
                          inputType: TextInputType.name,
                          icon: const Icon(
                            Icons.person_outlined,
                            size: 18,
                          ),
                          hint: "Enter a username",
                          label: "Username",
                          onChanged: (val) {},
                          onSubmit: _setName,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter a valid username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        customTextField(
                          inputType: TextInputType.emailAddress,
                          icon: const Icon(Icons.mail_outline, size: 18),
                          hint: "Enter Email Address",
                          label: "Email",
                          onChanged: (val) {},
                          onSubmit: _setEmail,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter a valid Email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        customPasswordField(
                          icon: const Icon(Icons.lock_open_outlined, size: 18),
                          inputType: TextInputType.visiblePassword,
                          hint: "Enter Password",
                          label: "Password",
                          onChanged: (val) {},
                          onSubmit: _setPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter a valid password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        customExtendButton(
                          ctx: context,
                          child: !loading
                              ? Text(
                                  "Sign Up",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                        color: kTextLight,
                                        fontWeight: FontWeight.bold,
                                      ),
                                )
                              : const CircularProgressIndicator(
                                  color: kTextLight,
                                ),
                          onPressed: _onSubmit,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account",
                          style: GoogleFonts.notoSans(
                            fontSize: 16,
                            letterSpacing: 1.3,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () => _navigateToLogin(),
                          child: Text(
                            "Sign In",
                            style: GoogleFonts.notoSans(
                              fontSize: 16,
                              letterSpacing: 1.3,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
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
