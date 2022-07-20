import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/helpers/http_services.dart';
import 'package:msafi_mobi/providers/merchant.provider.dart';
import 'package:msafi_mobi/providers/user.provider.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../reset/forgot_password.dart';

class LoginPageOptions extends StatefulWidget {
  const LoginPageOptions({Key? key}) : super(key: key);

  @override
  State<LoginPageOptions> createState() => _LoginPageOptionsState();
}

class _LoginPageOptionsState extends State<LoginPageOptions> {
// https://aa5a-41-89-160-19.in.ngrok.io
  String errors = "";
  String status = "Login";
  String snackBarMessage = "";
  bool showSnack = false;
  bool loading = false;

// form key
  final _formKey = GlobalKey<FormState>();

// user map
  final Map<String, String> user = {
    "email": "",
    "password": "",
  };

  @override
  void initState() {
    super.initState();
  }

  _setEmail(val) {
    setState(() {
      user['email'] = val.trim();
    });
  }

// populate user in user map
  _setPassword(val) {
    setState(() {
      user['password'] = val.trim();
    });
  }

  _postErrors(msg) {
    setState(() {
      errors = msg;
    });
  }

  _nextPage(List stores) {
    // create a user object and check type
    final role = context.read<User>().role;
    if (role == "merchant") {
      if (stores.isNotEmpty) {
        // populate the stores state
        context.read<MartConfig>().populateStore(stores[0]);
        Navigator.pushNamedAndRemoveUntil(
            context, "/mart-home", (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, "/mart-onboarding", (route) => false);
      }
    } else if (role == "user") {
      Navigator.pushNamedAndRemoveUntil(
          context, "/default-home", (route) => false);
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

      try {
        Response response =
            await httHelper().post('${baseUrl()}/auth/login', data: user);
        if (response.statusCode == 200) {
          final data = response.data;

          return await _handleUserSignIn(data);
        } else {
          // _postErrors(data['message']);
        }
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.connectTimeout) {
          customSnackBar("Connection  Timeout Exception");
        }
        _postErrors(ex.response?.data['message']);
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
      _nextPage(data['stores']);
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
    return Scaffold(
      appBar: AppBar(
        bottomOpacity: .3,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 22),
          onPressed: () => Navigator.of(context).pop(),
          color: kTextColor,
        ),
        actions: [],
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
                        text: "\nSign In!",
                        style: GoogleFonts.notoSans(
                          fontSize: 33,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      TextSpan(
                        text:
                            "\n\nPlease enter your valid data in order to sign in to account\n\n",
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
                        inputType: TextInputType.emailAddress,
                        icon: const Icon(Icons.mail_outline, size: 18),
                        hint: "Enter Email Address",
                        label: "Email",
                        onChanged: (val) {},
                        onSubmit: _setEmail,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter a valid email address';
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
                            return "password is required";
                          } else if (RegExp(r'/[a-zA-Z]/').firstMatch(value) !=
                                  null ||
                              RegExp(r'/\d/').firstMatch(value) != null) {
                            return "Password must contain at least one letter and one number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      customExtendButton(
                        ctx: context,
                        onPressed: _onSubmit,
                        child: !loading
                            ? Text(
                                "Login",
                                style: GoogleFonts.notoSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: kTextLight,
                                ),
                              )
                            : const CircularProgressIndicator(
                                color: kTextLight,
                              ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (_) => const EmailReset()));
                          },
                          child: Text(
                            "Forgot password",
                            style: GoogleFonts.notoSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
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
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account",
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
                          letterSpacing: 1.3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () => _navigateToRegister(),
                        child: Text(
                          "Sign Up",
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
    );
  }
}
