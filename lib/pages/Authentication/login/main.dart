import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:msafi_mobi/helpers/custom_shared_pf.dart';

class LoginPageOptions extends StatefulWidget {
  const LoginPageOptions({Key? key}) : super(key: key);

  @override
  State<LoginPageOptions> createState() => _LoginPageOptionsState();
}

class _LoginPageOptionsState extends State<LoginPageOptions> {
// https://aa5a-41-89-160-19.in.ngrok.io
  String errors = "";
  String status = "Login";

  final Map<String, String> user = {
    "email": "",
    "password": "",
  };

  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    clientId:
        '1040045272468-do114pg48n1p7sund8ds6u8g916f87v6.apps.googleusercontent.com',
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  GoogleSignInAccount? _currentUser;
  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    // if already signed in automatically sign in
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (err) {
      print(err);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  _setEmail(val) {
    setState(() {
      user['email'] = val;
    });
  }

  _postErrorMessage(message) {
    setState(() {
      errors = message;
    });
  }

  _setPassword(val) {
    setState(() {
      user['password'] = val;
    });
  }

  _updateStatus(msg) {
    setState(() {
      status = msg;
    });
  }

  _nextPage(role) {
    // create a user object and check type
    if (role == "merchant") {
      Navigator.popAndPushNamed(context, "/mart-onboarding");
    } else if (role == "user") {
    } else {}
  }

  _onSubmit() async {
    _updateStatus("Loading ...");

    Navigator.of(context).pushNamed('/mart-onboarding');

    var url = Uri.parse('http://10.0.2.2:3000/v1/auth/login');

    try {
      var response = await http.post(
        url,
        body: user,
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        _updateStatus("Success");
        final uToken = json.encode(data["user"]["tokens"]);

        final result = await CustomSharedPreferences().createdFootPrint(uToken);

        if (!result) {
          _updateStatus("Promise with system");
        } else {
          _updateStatus("saved");
          _nextPage(data["user"]["role"]);
        }

        return;
      }
      _updateStatus("Failed!");

      _postErrorMessage(data['message']);
    } catch (err) {
      print(err);
      _updateStatus("Connection Err!");
    }
  }

  _NavigateToRegister(BuildContext ctx) {
    return Navigator.of(context).pushNamed('/register');
  }

  @override
  Widget build(BuildContext context) {
    _goback() {
      return Navigator.of(context).pop();
    }

    // void _showSnackBar(String message) {
    //   Scaffold.of(context).showSnackBar(SnackBar(
    //     content: Text(message,
    //         style: GoogleFonts.notoSans(
    //           fontSize: 15,
    //           color: kTextLight,
    //         )),
    //     duration: const Duration(milliseconds: 1000),
    //   ));
    // }

    final GoogleSignInAccount? user = _currentUser;

    // _showSnackBar(user.toString());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          bottomOpacity: .3,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 22),
            onPressed: _goback,
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
                            fontWeight: FontWeight.bold,
                            color: kTextColor,
                          ),
                        ),
                        TextSpan(
                          text:
                              "\n\nPlease enter your valid data in order to sign in to account",
                          style: GoogleFonts.notoSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kTextColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // RichText(
                        //   textAlign: TextAlign.left,
                        //   text: TextSpan(
                        //     children: [
                        //       TextSpan(
                        //         text: "$errors\n",
                        //         style: GoogleFonts.notoSans(
                        //           fontSize: 15,
                        //           color: Colors.red,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        customTextField(
                          inputType: TextInputType.emailAddress,
                          icon: const Icon(Icons.mail_outline, size: 18),
                          hint: "Enter Email Address",
                          label: "Email",
                          onChanged: _setEmail,
                          onSubmit: (val) {},
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
                          onChanged: _setPassword,
                          onSubmit: (val) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "password is required";
                            } else if (RegExp(r'/[a-zA-Z]/')
                                        .firstMatch(value) !=
                                    null ||
                                RegExp(r'/\d/').firstMatch(value) != null) {
                              return "Password must contain at least one letter and one number";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        customButton(
                          callback: _onSubmit,
                          role: "register",
                          title: status,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "FORGOT PASSWORD",
                              style: GoogleFonts.notoSans(
                                fontSize: 15,
                                letterSpacing: 1.3,
                                fontWeight: FontWeight.bold,
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
                  customButton(
                    callback: _handleSignIn,
                    role: "login",
                    title: "Login with Google",
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () => _NavigateToRegister(context),
                      child: Text(
                        "NOT SIGNED? IN REGISTER",
                        style: GoogleFonts.notoSans(
                          fontSize: 15,
                          letterSpacing: 1.3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
