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
        '150386591318-81g42mric5rsimtmu1rcakn8eu7avu8s.apps.googleusercontent.com',
    scopes: <String>[
      'email',
      'password',
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
      if (_currentUser != null) {
        _handleGetContact(_currentUser!);
      }
    });
    _googleSignIn.signInSilently();
  }

  _handleGetContact(GoogleSignInAccount user) {
    print(user);
  }

  Future<void> _handleSignIn() async {
    await _googleSignIn.signIn().onError((error, stackTrace) => null);
    // dynamic googleAuth = await googleUser?.authentication;

    // print(googleUser.toString());
    // print(googleAuth.toString());
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

    final GoogleSignInAccount? user = _currentUser;

    print(user);

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
                          style: GoogleFonts.poppins(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: kTextColor,
                          ),
                        ),
                        TextSpan(
                          text:
                              "\n\nPlease enter your valid data in order to create an account",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
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
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "$errors\n",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        customTextField(
                          inputType: TextInputType.emailAddress,
                          icon: Icon(Icons.mail_outline, size: 18),
                          hint: "Enter Email Address",
                          label: "Email",
                          onChanged: _setEmail,
                          onSubmit: (val) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        customTextField(
                          icon: Icon(Icons.lock_open_outlined, size: 18),
                          inputType: TextInputType.visiblePassword,
                          hint: "Enter Password",
                          label: "Password",
                          onChanged: _setPassword,
                          onSubmit: (val) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        customButton(
                          callback: _onSubmit,
                          role: "register",
                          title: status,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "FORGOT PASSWORD",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: kTextMediumColor.withOpacity(.3),
                        width: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  customButton(
                    callback: _handleSignIn,
                    role: "login",
                    title: "Login with Google",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () => _NavigateToRegister(context),
                      child: Text(
                        "NOT SIGNED? IN REGISTER",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
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
