import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:msafi_mobi/components/snackback_component.dart';
import 'package:msafi_mobi/providers/orders.providers.dart';
import 'package:provider/provider.dart';

class MapViewPickUp extends StatefulWidget {
  int index;
  MapViewPickUp({required this.index, Key? key}) : super(key: key);

  @override
  State<MapViewPickUp> createState() => _MapViewPickUpState();
}

class _MapViewPickUpState extends State<MapViewPickUp> {
  final Completer<GoogleMapController> _controller = Completer();
  final String? googleApiKey = dotenv.env['GOOGLE_API_KEY'];
  Location location = new Location();

  bool loading = false;

  LatLng sourceLocation = LatLng(-1.2843319182232078, 36.81209195256612);
  LatLng destination = LatLng(-1.2853079968231786, 36.81299317474113);
// hold polyline coords
  List<LatLng> polyLineCoordinates = [];

  _getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        customSnackBar(
            context: context,
            message: "location not enabled",
            onPressed: () {});
        return Navigator.of(context).pop();
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        customSnackBar(
            context: context,
            message: "Grant location access",
            onPressed: () {});
        return Navigator.of(context).pop();
      }
    }

    return location.getLocation();
  }

  @override
  void initState() {
    super.initState();
    _startService();
  }

  _startService() async {
    setState(() {
      loading = true;
    });
    final userCoords = await _getUserLocation();
    final coords = _getCoordinates();
    final latitude = double.parse(coords['lat']);
    final longitude = double.parse(coords['long']);

    setState(() {
      destination = LatLng(latitude, longitude);
    });

    setState(() {
      sourceLocation = LatLng(latitude, longitude);
    });
    await getPolyLinePoints();
    setState(() {
      loading = false;
    });
  }

  _getCoordinates() {
    final location = context.read<Stations>().getPickUps[widget.index];
    return {
      "lat": location["lat"],
      "long": location["long"],
    };
  }

  getPolyLinePoints() async {
    try {
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey!,
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(destination.latitude, destination.longitude),
      );
      print(result.points);

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      }
      setState(() {});
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    _goback() {
      return Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        bottomOpacity: .3,
        elevation: 1,
        backgroundColor: Theme.of(context).canvasColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, size: 18),
          onPressed: _goback,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          "Tracker",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: sourceLocation,
          zoom: 12.5,
        ),
        polylines: {
          Polyline(
            polylineId: const PolylineId("route"),
            points: polyLineCoordinates,
            color: Theme.of(context).primaryColor,
            width: 6,
          ),
        },
        markers: {
          Marker(
            draggable: true,
            onDragEnd: (pos) {
              print(pos);
            },
            markerId: const MarkerId('source'),
            position: sourceLocation,
          ),
          Marker(
            markerId: const MarkerId('destination'),
            position: destination,
          ),
        },
      ),
    );
  }
}
