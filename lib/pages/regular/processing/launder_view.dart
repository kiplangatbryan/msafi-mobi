import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../../providers/store.providers.dart';
import 'home.dart';

class LaunderView extends StatelessWidget {
  const LaunderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "More Launder Marts :)",
          style: Theme.of(context).textTheme.headline6,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 40,
            bottom: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(context.read<Store>().count, (index) {
              return Hero(
                tag: context.read<Store>().stores[index]['id'],
                child: StoreItem(
                  margin: const EdgeInsets.only(
                    left: 0,
                    right: 0,
                    bottom: 15,
                  ),
                  index: index,
                  title: context.read<Store>().stores[index]['name'],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
