import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/pages/Authentication/login/main.dart';
import 'package:msafi_mobi/pages/Authentication/signup/login_options.dart';
import 'package:msafi_mobi/pages/onboarding/login_options.dart';
import 'package:msafi_mobi/themes/main.dart';

class NavButtons extends StatelessWidget {
  final String title;
  final Icon icon;
  const NavButtons({
    required this.title,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _navigateToLogin() async {
      return Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => const AuthenticationOptions(),
        ),
      );
    }

    return GestureDetector(
      onTap: _navigateToLogin,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 15,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: splashColor,
          border: Border.all(
            color: splashColor,
            width: 3,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 22.0,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 30,
            ),
            icon,
          ],
        ),
      ),
    );
  }
}
