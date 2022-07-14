import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:msafi_mobi/components/form_components.dart';

import 'location.dart';

class MapIntro extends StatelessWidget {
  const MapIntro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _goback() {
      // navigate to the previous screen
      return Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Choose pick-ups Intro",
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontSize: 18,
              ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, size: 18),
          onPressed: _goback,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            child: SizedBox(
              height: 500,
              child: Lottie.asset("assets/lottie/map-location.json",
                  fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 30,
              right: 80,
              top: 40,
            ),
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "Make it easy for clients to find you\n\n\n\n\n\n\n\n\n",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                            ),
                      ),
                      TextSpan(
                        text:
                            "Please select a\nlocation on the map,\nthat best describes the\nexact location your drop\noff point will be",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.6),
                            ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: customExtendButton(
                      ctx: context,
                      child: Text(
                        'Next',
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: Theme.of(context).backgroundColor,
                            ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PickUpspotsSelection(),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
