import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msafi_mobi/pages/launderMarts/profile/main.dart';
import 'package:msafi_mobi/providers/merchant.provider.dart';
import 'package:provider/provider.dart';

import '../../../components/form_components.dart';
import '../../../helpers/custom_shared_pf.dart';
import '../../../providers/user.provider.dart';
import '../../../themes/main.dart';

class MerchantSettings extends StatefulWidget {
  const MerchantSettings({Key? key}) : super(key: key);

  @override
  State<MerchantSettings> createState() => _MerchantSettingsState();
}

class _MerchantSettingsState extends State<MerchantSettings> {
  dynamic bsData;
  Person? user;

  @override
  void initState() {
    super.initState();
    user = context.read<User>().user;
    bsData = context.read<MartConfig>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontSize: 14,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.dark_mode_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const NavigateToProfile(),
              titleSegement(context: context, title: "Account"),
              CustomBtnLink(
                callback: () {},
                title: "Business Name",
                subtitle: bsData.bsname,
              ),
              CustomBtnLink(
                callback: () {},
                title: "Address",
                subtitle: bsData.address,
              ),
              titleSegement(context: context, title: "Payment"),
              CustomBtnLink(
                callback: () {},
                title: "Payment Options",
                subtitle: "Tap to configure payment",
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: customExtendButton(
                    ctx: context,
                    child: Text(
                      'Logout',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: kTextLight,
                          ),
                    ),
                    onPressed: () async {
                      final status = await CustomSharedPreferences().logout();
                      if (status) {
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login', (route) => false);
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding titleSegement(
      {required BuildContext context, required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline6!.copyWith(
              fontSize: 14,
            ),
      ),
    );
  }
}

class NavigateToProfile extends StatelessWidget {
  const NavigateToProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => const AccountSettings(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  minRadius: 25,
                  maxRadius: 30,
                  child: Text(
                    context.read<User>().name[0].toUpperCase(),
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: kTextLight,
                        ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${context.read<User>().name}\n",
                        style: GoogleFonts.notoSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(.7),
                        ),
                      ),
                      TextSpan(
                        text: "view profile",
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
          ],
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
    return InkWell(
      onTap: (() => callback),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 10,
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ),
    );
  }
}
