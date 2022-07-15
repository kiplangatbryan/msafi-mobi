import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/user.provider.dart';

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
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          "Account Profile",
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontSize: 14,
              ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
          ),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: const [
                        ClipOval(
                          child: Image(
                            image: AssetImage('assets/app/user.png'),
                            width: 120,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            minRadius: 25,
                            maxRadius: 35,
                            child: Icon(
                              Icons.camera_outlined,
                              size: 35,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  profileBox(
                    label: "+254746613059",
                    icon: const Icon(
                      Icons.phone_outlined,
                      size: 20,
                    ),
                    hint: "Tap to change phone number",
                    onTap: () {},
                  ),
                  profileBox(
                    label: "@${context.read<User>().name}",
                    icon: const Icon(
                      Icons.person_outlined,
                      size: 20,
                    ),
                    hint: "Tap to change your name",
                    onTap: () {},
                  ),
                  profileBox(
                    label: "${context.read<User>().email}",
                    icon: const Icon(
                      Icons.mail_outline_outlined,
                      size: 20,
                    ),
                    hint: "Tap to change your email",
                    onTap: () {},
                  ),
                  profileBox(
                    label: "Change password",
                    icon: const Icon(
                      Icons.password_outlined,
                      size: 2,
                    ),
                    hint: "Tap to change your password",
                    onTap: () {},
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class profileBox extends StatelessWidget {
  String label;
  Icon icon;
  String hint;
  Function onTap;

  profileBox({
    required this.label,
    required this.hint,
    required this.icon,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 15,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon,
            const SizedBox(
              width: 15,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$label\n",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontSize: 14,
                        ),
                  ),
                  TextSpan(
                    text: hint,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          height: 1.4,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
