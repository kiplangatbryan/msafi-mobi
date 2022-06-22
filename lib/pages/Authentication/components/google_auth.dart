import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/themes/main.dart';

class GooglAuth extends StatelessWidget {
  const GooglAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        
        style: ElevatedButton.styleFrom(
          primary: splashColor,
          enableFeedback: true,
          padding: const EdgeInsets.symmetric(
            vertical: 22,
            horizontal: 40,
          ),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () async {
          print('google auth');
        },
        autofocus: true,
        child: Text("Login",
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            )),
      ),
    );
  }
}
