import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/pages/Authentication/components/form_login.dart';
import 'package:msafi_mobi/pages/Authentication/components/google_auth.dart';
import 'package:msafi_mobi/themes/main.dart';

class LoginPageOptions extends StatelessWidget {
  const LoginPageOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _goback() {
      return Navigator.of(context).pop();
    }

    return SafeArea(
      child: Scaffold(
        appBar: null,
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
                  const Image(
                    image: AssetImage('assets/images/134.png'),
                    height: 280,
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                  ),
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "\nAdeos!",
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
                            fontSize: 16,
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
