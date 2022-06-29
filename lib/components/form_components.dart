import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/themes/main.dart';

Container MergeButton({required BuildContext context, required onPressed}) {
  return Container(
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
      onPressed: onPressed,
      autofocus: true,
      child: Text("Login",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          )),
    ),
  );
}

Widget customTextField({
  required String hint,
  required String label,
  required TextInputType inputType,
  required Icon icon,
  required Function validator,
  required Function onChanged,
  required Function onSubmit,
  int? minLines,
  int? maxLines,
}) {
  return TextFormField(
    validator: (val) => validator(val),
    onChanged: (val) => onChanged(val),
    onFieldSubmitted: (val) => onSubmit(val),
    cursorColor: kTextColor,
    cursorHeight: 20,
    keyboardType: inputType,
    minLines: minLines,
    maxLines: maxLines,
    // ? TextInputType.visiblePassword
    // : TextInputType.emailAddress,
    style: GoogleFonts.poppins(
      color: kTextColor,
      fontWeight: FontWeight.w600,
      fontSize: 17,
    ),
    decoration: InputDecoration(
      hintText: hint,
      labelText: label,
      labelStyle: GoogleFonts.poppins(
        color: kTextMediumColor.withOpacity(.4),
        fontSize: 17,
      ),
      floatingLabelStyle: GoogleFonts.poppins(
        color: kTextMediumColor.withOpacity(.4),
        fontSize: 17,
      ),
      filled: true,
      fillColor: kTextMediumColor.withOpacity(.06),
      prefixIcon: icon,

      // ? const Icon(Icons.mail_outline, size: 18)
      // : const Icon(Icons.lock_open_outlined, size: 18),
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

GestureDetector customButton(
    {required String title, required String role, required callback}) {
  return GestureDetector(
    onTap: callback,
    child: Container(
      padding: EdgeInsets.symmetric(
        vertical: 13,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: role == "login" ? null : splashColor,
        border: Border.all(
          color: role == "login" ? kTextColor : splashColor,
          width: 3,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 21.0,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold,
              color: role == "login" ? kTextColor : Colors.white,
              decorationStyle: TextDecorationStyle.wavy,
            ),
          ),
          SizedBox(
            width: 18,
          ),
          role != "login"
              ? Icon(Icons.login)
              : Image(
                  image: AssetImage('assets/logo/google.png'),
                  height: 26,
                ),
        ],
      ),
    ),
  );
}
