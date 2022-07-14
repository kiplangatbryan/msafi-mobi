// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:msafi_mobi/themes/main.dart';

// class ChoosePickUp extends StatefulWidget {
//   const ChoosePickUp({Key? key}) : super(key: key);

//   @override
//   State<ChoosePickUp> createState() => _ChoosePickUpState();
// }

// class _ChoosePickUpState extends State<ChoosePickUp> {
//   MapboxMapController? mapController;
//   final accessToken =
//       'pk.eyJ1IjoiYnJpYW4tdGsiLCJhIjoiY2w1YW82bTQ2Mm42aDNwdDcxcjVtYTAzdyJ9.MdnXz8j_UbMCbhikFmEFnA';
//   final styleString = 'mapbox://styles/brian-tk/cl5j80n7d000214mwkeuxemrn';
//   final center = const LatLng(37.810575, -122.477174);

//   _onMapCreated(MapboxMapController controller) {
//     mapController = controller;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         centerTitle: true,
//         backgroundColor: Theme.of(context).backgroundColor,
//         title: Text(
//           'Select pick up location',
//           style: Theme.of(context).textTheme.headline6!.copyWith(
//                 fontSize: 14,
//               ),
//         ),
//       ),
//       body: MapboxMap(
//         initialCameraPosition: CameraPosition(
//           target: center,
//           zoom: 15,
//         ),
//         onMapCreated: _onMapCreated,
//         styleString: styleString,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             mapController!.animateCamera(CameraUpdate.tiltTo(20));
//           });
//         },
//         backgroundColor: Theme.of(context).primaryColor,
//         child: const Icon(
//           Icons.location_on,
//           color: kTextLight,
//           size: 20,
//         ),
//       ),
//     );
//   }
// }
