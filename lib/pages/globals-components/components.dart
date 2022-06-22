import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/themes/main.dart';

Widget actionButton({
  required String title,
  required Function callback,
}) {
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
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: () {
        callback();
      },
      autofocus: true,
      child: Text(title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          )),
    ),
  );
}

Widget customTextField({
  required String hint,
  required String label,
  required String fieldType,
  required String iconType,
}) {
  final Map<String, dynamic> iconFilter = {
    "bs_image": Icons.image_search_outlined,
    "bs_info": Icons.description_outlined,
    "bs_name": Icons.title,
    "bs_address": Icons.local_laundry_service_outlined,
  };
  final Map<String, dynamic> textInputType = {
    "info": TextInputType.multiline,
    "name": TextInputType.name,
  };

// fix this later on
  return TextFormField(
    minLines: fieldType == "info" ? 7 : 1,
    maxLines: fieldType == "info" ? 12 : 1,
    onChanged: (val) {},
    onFieldSubmitted: (val) {},
    cursorColor: kTextColor,
    cursorHeight: 20,
    keyboardType: textInputType[fieldType],
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
      prefixIcon: Icon(iconFilter[iconType], size: 18),
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
