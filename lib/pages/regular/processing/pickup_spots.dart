import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/components/snackback_component.dart';
import 'package:msafi_mobi/pages/regular/components/app_bar.dart';
import 'package:msafi_mobi/pages/regular/processing/map_view_pickup.dart';
import 'package:msafi_mobi/pages/regular/processing/payment_options.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:provider/provider.dart';

import '../../../providers/orders.providers.dart';
import 'checkout.dart';

class PickUpSpots extends StatefulWidget {
  const PickUpSpots({Key? key}) : super(key: key);

  @override
  State<PickUpSpots> createState() => _PickUpSpotsState();
}

class _PickUpSpotsState extends State<PickUpSpots> {
  List addresses = [];
  // track radio selection
  var _radioVal = null;

  @override
  void initState() {
    super.initState();
    // get pick up spots from store;
    var spots = context.read<Stations>().getPickUps;
    setState(() {
      addresses = spots;
    });
  }

  _proceed() {
    // save the selected address
    if (_radioVal != null) {
      context.read<Order>().setStation(addresses[_radioVal]);
      Navigator.of(context)
          .push(CupertinoPageRoute(builder: (_) => const PaymentOptions()));
    } else {
      customSnackBar(
          context: context,
          message: "You have not selected a pick up spot",
          onPressed: () {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context: context, title: "Select pickup spot"),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        child: Column(
          children: [
            Text(
              textAlign: TextAlign.center,
              "Select a location where you can easily drop off your laundry",
              style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.bold, height: 1.4, fontSize: 25),
            ),
            const SizedBox(
              height: 40,
            ),
            pickUpListItem(context),
            const SizedBox(
              height: 40,
            ),
            customExtendButton(
              ctx: context,
              child: Text(
                "Save and Proceed",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: kTextLight,
                    ),
              ),
              onPressed: () => _proceed(),
            ),
          ],
        ),
      ),
    );
  }

  Column pickUpListItem(BuildContext context) {
    return Column(
      children: List.generate(addresses.length, (index) {
        final address = addresses[index];
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1.5,
                color: const Color(0xFFDDDDDD),
              )),
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 15),
          child: Row(children: [
            SizedBox(
              child: Radio(
                  value: index,
                  groupValue: _radioVal,
                  toggleable: true,
                  onChanged: (val) {
                    setState(() {
                      _radioVal = val;
                    });
                  }),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 18),
                    Text(
                      address['name'],
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (_) => MapViewPickUp(index: index)));
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_pin,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        "Tap to view on map",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Theme.of(context).primaryColor,
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
      }),
    );
  }
}
