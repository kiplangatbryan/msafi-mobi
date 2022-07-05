import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/themes/main.dart';

SizedBox customExtendButton(
    {required Widget child, required Function onPressed}) {
  return SizedBox(
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
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () => onPressed,
      autofocus: true,
      child: child,
    ),
  );
}

Widget customPasswordField({
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
    onSaved: (val) => onSubmit(val),
    cursorColor: kTextColor,
    cursorHeight: 20,
    keyboardType: inputType,
    obscureText: true,
    // ? TextInputType.visiblePassword
    // : TextInputType.emailAddress,
    style: GoogleFonts.notoSans(
      color: kTextColor,
      fontWeight: FontWeight.w600,
      fontSize: 17,
    ),
    decoration: InputDecoration(
      hintText: hint,
      labelText: label,
      labelStyle: GoogleFonts.notoSans(
        color: kTextMediumColor.withOpacity(.4),
        fontSize: 17,
      ),
      floatingLabelStyle: GoogleFonts.notoSans(
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
        borderSide: const BorderSide(
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
    onSaved: (val) => onSubmit(val),
    cursorColor: kTextColor,
    cursorHeight: 17,
    keyboardType: inputType,
    minLines: minLines,
    maxLines: maxLines,
    // ? TextInputType.visiblePassword
    // : TextInputType.emailAddress,
    style: GoogleFonts.notoSans(
      color: kTextColor,
      fontWeight: FontWeight.w600,
      fontSize: 17,
    ),
    decoration: InputDecoration(
      hintText: hint,
      labelText: label,
      labelStyle: GoogleFonts.notoSans(
        color: kTextMediumColor.withOpacity(.4),
        fontSize: 17,
      ),
      floatingLabelStyle: GoogleFonts.notoSans(
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
        borderSide: const BorderSide(
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
      padding: const EdgeInsets.symmetric(
        vertical: 12,
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
            style: GoogleFonts.notoSans(
              fontSize: 18.0,
              letterSpacing: 1.3,
              fontWeight: FontWeight.bold,
              color: role == "login" ? kTextColor : Colors.white,
              decorationStyle: TextDecorationStyle.wavy,
            ),
          ),
          const SizedBox(
            width: 13,
          ),
          role != "login"
              ? const Icon(
                  Icons.login,
                  color: kTextLight,
                )
              : const Image(
                  image: AssetImage('assets/logo/google.png'),
                  height: 26,
                ),
        ],
      ),
    ),
  );
}
