import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/components/form_components.dart';

class LocationFeedScreen extends StatefulWidget {
  const LocationFeedScreen({Key? key}) : super(key: key);

  @override
  State<LocationFeedScreen> createState() => _LocationFeedScreenState();
}

class _LocationFeedScreenState extends State<LocationFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "How many pick up locations do you have",
                        style: GoogleFonts.notoSans(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                customButton(
                  title: "Next",
                  role: "next",
                  callback: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
