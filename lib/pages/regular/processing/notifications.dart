import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../../providers/store.providers.dart';
import 'home.dart';

class AppNotifications extends StatefulWidget {
  const AppNotifications({Key? key}) : super(key: key);

  @override
  State<AppNotifications> createState() => _AppNotificationsState();
}

class _AppNotificationsState extends State<AppNotifications> {
  bool _snap = false;
  bool _floating = false;
  bool _pinned = false;

// [SliverAppBar]s are typically used in [CustomScrollView.slivers], which in
// turn can be placed in a [Scaffold.body].
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            pinned: _pinned,
            snap: _snap,
            floating: _floating,
            expandedHeight: 160.0,
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 1.6,
              titlePadding: const EdgeInsets.only(
                left: 25,
                bottom: 20,
              ),
              title: Text(
                textAlign: TextAlign.left,
                'Notifications',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
          // SliverToBoxAdapter(
          //   child: customNotification(),
          // ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 25,
                    ),
                    child: const customNotification());
              },
              childCount: 5,
            ),
          ),
        ],
      ),
    );
  }
}

class customNotification extends StatelessWidget {
  const customNotification({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 18,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "major",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Chip(
                    label: Text(
                      "happy",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        "LaunderMart",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        "Fystu",
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Expected Date",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        "hey now",
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
