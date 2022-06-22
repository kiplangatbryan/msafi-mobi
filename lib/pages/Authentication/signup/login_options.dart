import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/pages/Authentication/components/form_login.dart';
import 'package:msafi_mobi/pages/Authentication/components/google_auth.dart';
import 'package:msafi_mobi/themes/main.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

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
            "Sign Up",
            style: TextStyle(
              color: kTextMediumColor,
            ),
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image(
                  //   image: AssetImage('images/054.png'),
                  // ),
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "\nLet's \nGet Started",
                          style: GoogleFonts.poppins(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: kTextColor,
                          ),
                        ),
                        TextSpan(
                          text:
                              "\n\nPlease enter your valid data inorder to create an account",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: kTextColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const LoginForm(),
                  const SizedBox(
                    height: 40,
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
