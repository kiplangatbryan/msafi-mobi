import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/themes/main.dart';

class FinishPage extends StatefulWidget {
  const FinishPage({Key? key}) : super(key: key);

  @override
  State<FinishPage> createState() => _FinishPageState();
}

class _FinishPageState extends State<FinishPage> {
  bool _animate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _finishSetup() async {
    setState(() {
      _animate = true;
    });
    await Future.delayed(
      const Duration(seconds: 4),
      () {
        setState(() {
          _animate = false;
        });

        Navigator.of(context).pushNamed('/mart-home');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LimitedBox(
                    maxHeight: MediaQuery.of(context).size.height / 3,
                    child: Lottie.asset(
                      "assets/lottie/happy.json",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Congratulations\n\n",
                          style: GoogleFonts.notoSans(
                            color: kTextColor,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text:
                              "You have successfully finished setting your Launder Mart, Lets get mula!",
                          style: GoogleFonts.notoSans(
                            color: kTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                    ),
                    child: customButton(
                      title: "Complete",
                      role: "login",
                      callback: _finishSetup,
                    ),
                  )
                ],
              ),
            ),
            _animate
                ? Positioned(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: kPrimaryColor,
                        backgroundBlendMode: BlendMode.darken,
                      ),
                      child: Center(
                        child: LimitedBox(
                          maxHeight: MediaQuery.of(context).size.height / 3,
                          child: Lottie.asset(
                            "assets/lottie/loader.json",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
