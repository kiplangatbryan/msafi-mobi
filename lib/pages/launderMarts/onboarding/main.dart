import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'pages/basic.dart';

class BoardingRender extends StatefulWidget {
  const BoardingRender({Key? key}) : super(key: key);

  @override
  State<BoardingRender> createState() => _BoardingRenderState();
}

class _BoardingRenderState extends State<BoardingRender> {
  @override
  Widget build(BuildContext context) {
    return BasicInformation();
  }
}
