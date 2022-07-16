import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/themes/main.dart';

SizedBox customExtendButton(
    {required BuildContext ctx,
    required Widget child,
    Color? background,
    required onPressed}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: background ?? Theme.of(ctx).primaryColor,
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
      child: child,
    ),
  );
}

SizedBox customSmallBtn(
    {required BuildContext ctx, required Widget child, required onPressed}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(ctx).primaryColor,
        enableFeedback: true,
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 30,
        ),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: onPressed,
      autofocus: true,
      child: child,
    ),
  );
}

class customPasswordField extends StatelessWidget {
  String hint;
  String label;
  TextInputType inputType;
  Icon icon;
  Function validator;
  Function onChanged;
  Function onSubmit;
  int? minLines;
  int? maxLines;

  customPasswordField(
      {required this.hint,
      required this.label,
      required this.inputType,
      required this.icon,
      required this.validator,
      required this.onChanged,
      required this.onSubmit,
      this.minLines,
      this.maxLines,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        fillColor: Theme.of(context).primaryColor.withOpacity(.06),
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
            color: Theme.of(context).primaryColor.withOpacity(.3),
          ),
          gapPadding: 10,
        ),
      ),
    );
  }
}

class customTextField extends StatelessWidget {
  String hint;
  String label;
  TextInputType inputType;
  Icon icon;
  Function validator;
  Function onChanged;
  Function onSubmit;
  int? minLines;
  int? maxLines;
  customTextField(
      {required this.hint,
      required this.label,
      required this.inputType,
      required this.icon,
      required this.validator,
      required this.onChanged,
      required this.onSubmit,
      this.minLines,
      this.maxLines,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (val) => validator(val),
      onChanged: (val) => onChanged(val),
      onSaved: (val) => onSubmit(val),
      cursorColor: kTextColor,
      cursorHeight: 17,
      keyboardType: inputType,
      minLines: minLines,
      maxLines: maxLines,
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
        fillColor: Theme.of(context).primaryColor.withOpacity(.06),
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
            color: Theme.of(context).primaryColor.withOpacity(.3),
          ),
          gapPadding: 10,
        ),
      ),
    );
  }
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
