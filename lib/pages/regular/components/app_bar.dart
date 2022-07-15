import 'package:flutter/material.dart';

AppBar mainAppBar({
  required BuildContext context,
  required String title,
}) {
  return AppBar(
    backgroundColor: Theme.of(context).backgroundColor,
    elevation: 0,
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
      title,
      style: Theme.of(context).textTheme.headline6!.copyWith(
            fontWeight: FontWeight.bold,
          ),
    ),
    centerTitle: true,
  );
}
