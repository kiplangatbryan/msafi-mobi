import 'package:flutter/material.dart';

import 'pages/basic.dart';

class BoardingRender extends StatefulWidget {
  const BoardingRender({Key? key}) : super(key: key);

  @override
  State<BoardingRender> createState() => _BoardingRenderState();
}

class _BoardingRenderState extends State<BoardingRender> {
  @override
  Widget build(BuildContext context) {
    return const BasicInformation();
  }
}
