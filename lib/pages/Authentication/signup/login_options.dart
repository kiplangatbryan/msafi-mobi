import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:msafi_mobi/helpers/custom_shared_pf.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/themes/main.dart';

import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String errors = "";
  String status = "Continue with Email";

  final Map<String, String> user = {
    "email": "",
    "password": "",
    "name": "",
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
    try {
      await _googleSignIn.signIn();
      // dynamic googleAuth = await googleUser?.authentication;

      // print(googleUser.toString());
      // print(googleAuth.toString());
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  _setEmail(val) {
    setState(() {
      user['email'] = val;
    });
  }

  _setName(val) {
    setState(() {
      user['name'] = val;
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
    print(role);
    // create a user object and check type
    if (role == "merchant") {
      //
    } else if (role == "user") {
      Navigator.popAndPushNamed(context, "/mart-onboarding");
    } else {}
  }

  _onSubmit() async {
    _updateStatus("Loading ...");
    var url = Uri.parse('http://10.0.2.2:3000/v1/auth/register');

    try {
      var response = await http.post(
        url,
        body: user,
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201) {
        _updateStatus("Success");
        final uToken = json.encode(data["user"]["tokens"]);
        final result = await CustomSharedPreferences().createdFootPrint(uToken);

        if (!result) {
          _updateStatus("Promise with system");
        } else {
          _updateStatus("saved");

          _nextPage(data['user']['role']);
        }

        return;
      }
      _updateStatus("Failed!");

      _postErrorMessage(data['message']);
    } catch (err) {
      print(err);
      _updateStatus("Err! Try Again");
    }
  }

  _NavigateToLogin(BuildContext ctx) {
    return Navigator.of(context).pushNamed('/login');
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
            icon: const Icon(Icons.arrow_back_ios_new, size: 24),
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
                          text: "\nSign Up!",
                          style: GoogleFonts.notoSans(
                            fontSize: 33,
                            fontWeight: FontWeight.bold,
                            color: kTextColor,
                          ),
                        ),
                        TextSpan(
                          text:
                              "\n\nPlease enter your valid data in order to create an account",
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
                          inputType: TextInputType.name,
                          icon: const Icon(
                            Icons.person_outlined,
                            size: 18,
                          ),
                          hint: "Enter a username",
                          label: "Username",
                          onChanged: _setName,
                          onSubmit: (val) {},
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
                          onChanged: _setEmail,
                          onSubmit: (val) {},
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
                          onChanged: _setPassword,
                          onSubmit: (val) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
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
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  customButton(
                    callback: _handleSignIn,
                    role: "login",
                    title: "Continue with Google",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () => _NavigateToLogin(context),
                      child: Text(
                        "ALREADY REGISTERED? LOGIN",
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
