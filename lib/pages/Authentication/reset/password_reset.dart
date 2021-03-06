import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/helpers/http_services.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'code_verify.dart';

class EmailReset extends StatefulWidget {
  const EmailReset({Key? key}) : super(key: key);

  @override
  State<EmailReset> createState() => _EmailResetState();
}

class _EmailResetState extends State<EmailReset> {
// https://aa5a-41-89-160-19.in.ngrok.io
  String errors = "";
  String snackBarMessage = "";
  bool success = false;
  bool loading = false;

// form key
  final _formKey = GlobalKey<FormState>();

// user map
  final Map<String, String> user = {
    "email": "",
  };

  @override
  void initState() {
    super.initState();
  }

  _setEmail(val) {
    setState(() {
      user['email'] = val;
    });
  }

// populate user in user map

  _postErrors(msg) {
    setState(() {
      errors = msg;
    });
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
            await httHelper().post('/auth/forgot-password', data: user);
        if (response.statusCode == 204) {
          final data = response.data;

          return _handleUserSignIn(data);
        } else {
          // _postErrors(data['message']);
        }
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.connectTimeout) {
          customSnackBar("Connection Timeout Exception");
        }
        if (ex.type == DioErrorType.sendTimeout) {
          customSnackBar("Unable to reach server");
        } else {
          final msg = ex.response?.data['message'];
          if (msg != null) {
            _postErrors(ex.response?.data['message']);
          } else {
            customSnackBar("An Error occurred");
          }
        }
      }
      setState(() {
        loading = false;
      });
    }
  }

  // handleErrors() {}
  _handleUserSignIn(dynamic data) async {
    // call to User<> provider
    setState(() {
      loading = false;
      success = true;
    });

    return Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context)
          .push(CupertinoPageRoute(builder: (_) => const CodeVerify()));
    });
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
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ),
              child: success
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/lottie/sent-email-animation.json',
                          repeat: false,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Text(
                          "Email Sent",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Check your inbox for reset code",
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "\nPassword Reset",
                                style: GoogleFonts.notoSans(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "\n\nPlease enter your email address inorder to which we will send the recovery code\n\n",
                                style: GoogleFonts.notoSans(
                                    fontSize: 16,
                                    color:
                                        Theme.of(context).colorScheme.primary),
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
                                height: 30,
                              ),
                              customExtendButton(
                                ctx: context,
                                child: !loading
                                    ? Text("Email Reset Code",
                                        style: GoogleFonts.notoSans(
                                          color: kTextLight,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ))
                                    : const CircularProgressIndicator(
                                        color: kTextLight,
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
