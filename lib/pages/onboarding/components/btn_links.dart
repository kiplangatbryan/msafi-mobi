import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/pages/Authentication/login/main.dart';
import 'package:msafi_mobi/pages/Authentication/signup/login_options.dart';
import 'package:msafi_mobi/themes/main.dart';

class NavButtons extends StatelessWidget {
  final String title;
  final bool fade;
  const NavButtons({
    required this.title,
    required this.fade,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _navigateToLogin() async {
      return Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => const LoginPageOptions(),
        ),
      );
    }

    _navigateToSignUp() async {
      return Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => const SignUpPage(),
        ),
      );
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: fade ? kTextColor : splashColor,
        enableFeedback: true,
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 40,
        ),
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: fade ? _navigateToSignUp : _navigateToLogin,
      autofocus: true,
      child: Text("$title",
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )),
    );
  }
}
