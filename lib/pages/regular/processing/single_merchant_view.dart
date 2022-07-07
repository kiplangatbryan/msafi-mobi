import 'package:flutter/material.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:provider/provider.dart';

import '../../../providers/store.providers.dart';
import 'cloth_select.dart';

class LaunderMartView extends StatelessWidget {
  int index;
  LaunderMartView({required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = context.read<Store>().stores[index];
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).canvasColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          "Details",
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            bottom: 30,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${store['name']}\n",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextSpan(
                        text: store['address'],
                        style: Theme.of(context).textTheme.subtitle1),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(.04),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    const MartSchedule(),
                    const SizedBox(
                      height: 15,
                    ),
                    const ContactInfo(),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(.04),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      child: Column(
                        children: const [
                          StationItem(),
                          StationItem(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    customExtendButton(
                        ctx: context,
                        child: Text(
                          "Up Next",
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: kTextLight,
                                  ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => LaundrySelection(index: index)));
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StationItem extends StatelessWidget {
  const StationItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 15,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 35,
                    child: const Center(
                      child: Icon(
                        Icons.location_disabled,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Antonio Hillario\n",
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        TextSpan(
                          text: "Owner",
                          style: Theme.of(context).textTheme.subtitle1!,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.pin_drop,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContactInfo extends StatelessWidget {
  const ContactInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(.02),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                child: Image(
                  image: AssetImage("assets/clothes/hat.png"),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Antonio Hillario\n",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextSpan(
                      text: "Owner",
                      style: Theme.of(context).textTheme.subtitle1!,
                    )
                  ],
                ),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.only(
                top: 12,
                bottom: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {},
            child: const Icon(
              Icons.phone,
            ),
          ),
        ],
      ),
    );
  }
}

class MartSchedule extends StatelessWidget {
  const MartSchedule({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(.02),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 15,
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "Open Hours",
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(.07),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(.07),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.lock_clock_sharp,
                        size: 16,
                      ),
                    ),
                  ),
                  Text(
                    "08:00",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_right_outlined,
              size: 35,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(.07),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(.07),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.history,
                        size: 16,
                      ),
                    ),
                  ),
                  Text(
                    "06:00",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        )
      ]),
    );
  }
}
