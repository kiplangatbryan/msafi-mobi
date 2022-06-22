import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class PickUpspotsSelection extends StatefulWidget {
  const PickUpspotsSelection({Key? key}) : super(key: key);

  @override
  State<PickUpspotsSelection> createState() => _PickUpspotsSelectiontate();
}

class _PickUpspotsSelectiontate extends State<PickUpspotsSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Text('Hey'),
      ),
    );
  }
}
