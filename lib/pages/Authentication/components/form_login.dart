import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/pages/launderMarts/onboarding/main.dart';
import 'package:msafi_mobi/pages/regular/home/main.dart';
import 'package:msafi_mobi/themes/main.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var email = '';
  var password = "";

  _setEmail(value) {
    setState(() {
      email = value;
    });
  }

  _setPassword(value) {
    setState(() {
      password = value;
    });
  }

  _submitForm(value) async {
    print('submitting ....');
  }

  _customSubmit(value) async {}

  Widget customTextField({
    required String hint,
    required String label,
    required String field_type,
  }) {
    return TextFormField(
      onChanged: (val) {},
      onFieldSubmitted: (val) async {
        await _submitForm(val);
      },
      cursorColor: kTextColor,
      cursorHeight: 20,
      keyboardType: field_type == "email"
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
      style: GoogleFonts.poppins(
        color: kTextColor,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: kTextMediumColor.withOpacity(.4),
        ),
        floatingLabelStyle: GoogleFonts.poppins(
          color: kTextMediumColor.withOpacity(.4),
        ),
        filled: true,
        fillColor: kTextMediumColor.withOpacity(.06),
        prefixIcon: field_type == "email"
            ? const Icon(Icons.mail_outline, size: 18)
            : const Icon(Icons.lock_open_outlined, size: 18),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
          gapPadding: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: kTextMediumColor.withOpacity(.4),
          ),
          gapPadding: 10,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          customTextField(
            hint: "Email Address",
            label: "Email",
            field_type: 'email',
          ),
          SizedBox(
            height: 20,
          ),
          customTextField(
            hint: "Enter password",
            label: "Password",
            field_type: 'passwd',
          ),
          const SizedBox(
            height: 25,
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: splashColor,
                enableFeedback: true,
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 40,
                ),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () async {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const BoardingRender(),
                  ),
                );
              },
              autofocus: true,
              child: Text("Login",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
