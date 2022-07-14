// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class AlternativeMap extends StatefulWidget {
//   const AlternativeMap({Key? key}) : super(key: key);

//   @override
//   State<AlternativeMap> createState() => _AlternativeMapState();
// }

// class _AlternativeMapState extends State<AlternativeMap> {
//   final Completer<GoogleMapController> _controller = Completer();
//   final String? googleApiKey = dotenv.env['GOOGLE_API_KEY'];

//   static const LatLng sourceLocation = LatLng(37.33500926, -122.0372188);
//   static const LatLng destination = LatLng(37.33429383, -122.06600055);
// // 
//   List<LatLng> polyLineCoordinates = [];

//   @override
//   void initState() {
//     super.initState();
//     getPolyLinePoints();
//   }

//   void getPolyLinePoints() async {
//     PolylinePoints polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       googleApiKey!,
//       PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
//       PointLatLng(destination.latitude, destination.longitude),
//     );
//     print(result.points);

//     if (result.points.isNotEmpty) {
//       for (var point in result.points) {
//         polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
//       }
//     }
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     _goback() {
//       return Navigator.of(context).pop();
//     }

//     return Scaffold(
//       appBar: AppBar(
//         bottomOpacity: .3,
//         elevation: 1,
//         backgroundColor: Theme.of(context).canvasColor,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_outlined, size: 18),
//           onPressed: _goback,
//           color: Theme.of(context).colorScheme.primary,
//         ),
//         title: Text(
//           "Tracker",
//           style: TextStyle(
//             color: Theme.of(context).colorScheme.primary,
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: sourceLocation,
//           zoom: 12.5,
//         ),
//         polylines: {
//           Polyline(
//             polylineId: PolylineId("route"),
//             points: polyLineCoordinates,
//             color: Theme.of(context).primaryColor,
//             width: 6,
//           ),
//         },
//         markers: {
//           Marker(
//             markerId: MarkerId('source'),
//             position: sourceLocation,
//           ),
//           Marker(
//             markerId: MarkerId('destination'),
//             position: destination,
//           ),
//         },
//       ),
//     );
//   }
// }
