import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/pages/launderMarts/email/main.dart';
import 'package:msafi_mobi/pages/launderMarts/profile/main.dart';

import '../components/util_widgets.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        //   icon: Icon(
        //     Icons.arrow_back_ios_outlined,
        //     color: Theme.of(context).colorScheme.primary,
        //   ),
        // ),
        title: Text(
          "Account",
          style: GoogleFonts.notoSans(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 30,
          ),
          child: Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadButton(
                      onPressed: () {},
                      child: NavigateToProfile(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'User Account',
                      style: GoogleFonts.notoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomBtnLink(
                      callback: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const EmailChange()));
                        print("clicked");
                      },
                      title: "Email",
                      subtitle: "briankiplangat71@gmail.com",
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    CustomBtnLink(
                      callback: () {
                        print("clicked");
                      },
                      title: "Password",
                      subtitle: "Tap to change password",
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Preferences',
                      style: GoogleFonts.notoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomBtnLink(
                      callback: () {},
                      title: "Show Location Preferences",
                      subtitle: "Set the params for showing location",
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomBtnLink extends StatelessWidget {
  String title;
  String subtitle;
  Function callback;

  CustomBtnLink({
    required this.title,
    required this.subtitle,
    required this.callback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => callback,
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.notoSans(
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              subtitle,
              style: GoogleFonts.notoSans(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary.withOpacity(.6),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
