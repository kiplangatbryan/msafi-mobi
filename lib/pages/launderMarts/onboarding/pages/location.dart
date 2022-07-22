import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:msafi_mobi/components/form_components.dart';
import 'package:msafi_mobi/components/snackback_component.dart';

import 'package:msafi_mobi/providers/map.provider.dart';
import 'package:msafi_mobi/services/map.services.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:provider/provider.dart';

import 'selected_spots_preview.dart';

class PickUpspotsSelection extends StatefulWidget {
  const PickUpspotsSelection({Key? key}) : super(key: key);

  @override
  State<PickUpspotsSelection> createState() => _PickUpspotsSelectiontate();
}

class _PickUpspotsSelectiontate extends State<PickUpspotsSelection> {
  Completer<GoogleMapController> _controller = Completer();

// default user location
  final centerLocation = "";
// fabe key
  final fabKey = GlobalKey<FabCircularMenuState>();

// toggle UI components we need
  bool searchToggle = true;
  bool radiusSlider = false;
  bool pressedNear = false;
  bool cardTapped = false;
  bool getDirection = false;
  // hold all search results
  List searchResults = [];
  // marker counter
  int markIdCounter = 0;
  // hold the info of selected location
  Map selectedLocation = {};
  // initiak user pos
  CameraPosition _kUserLocation = const CameraPosition(
    target: LatLng(-1.2843319182232078, 36.81209195256612),
    zoom: 14,
  );

  // inputcontroller
  TextEditingController searchController = TextEditingController();

  // throttle async calls
  Timer? _debounce;

  // markers set
  Set<Marker> _markers = Set<Marker>();

// initialize map coordinates
  // zooms the focus to the selected location
  Future<void> goToLocation({required LatLng coords}) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: coords,
          zoom: 16.151926040649414,
        ),
      ),
    );
  }

  _onUserDragEnd(LatLng updatedCoords) {
    setState(() {
      selectedLocation = {
        "lat": updatedCoords.latitude,
        "long": updatedCoords.longitude,
      };
    });
  }

  // set marker on tapped location
  _setMarker(LatLng position) {
    int counter = markIdCounter += 1;

    final marker = Marker(
      markerId: MarkerId('marker_$counter'),
      onTap: () {
        // lauch a dialog
        showBottomSheet();
      },
      position: position,
      draggable: true,
      onDrag: _onUserDragEnd,
      onDragEnd: _onUserDragEnd,
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
          title: ' Drag the Me \'😎\' to \n where you want me 😜 \b',
          onTap: () {
            // display modal
            showBottomSheet();
          },
          snippet: "  Tap to set location  "),
    );
    // add it to markes
    setState(() {
      _markers.add(marker);
    });
  }

  showBottomSheet() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                textAlign: TextAlign.center,
                "Congrats, lets customize the location",
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(
                height: 15,
              ),
              customExtendButton(
                ctx: context,
                child: Text(
                  "Let's go",
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: kTextLight,
                      ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) =>
                          SelectedSpots(description: selectedLocation),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // handle taps on map
  _onMapTap(LatLng coords) {
    // remove the previous marker
    setState(() {
      _markers = {};
    });
    setState(() {
      selectedLocation = {
        "lat": coords.latitude,
        "long": coords.longitude,
      };
    });
    _setMarker(coords);
  }

  @override
  void initState() {
    super.initState();
  }

  _startService() async {
    final userCoords = await _getUserLocation();
    if (userCoords != null) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(userCoords.latitude, userCoords.longitude),
            zoom: 16.151926040649414,
          ),
        ),
      );
    }
  }

  Location location = Location();

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

  // fetch results
  _setResults(List res) {
    setState(() {
      searchResults = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchFlag = context.watch<SearchToggle>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                mapType: MapType.normal,
                markers: _markers,
                initialCameraPosition: _kUserLocation,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                onTap: _onMapTap,
              ),
            ),
            if (searchToggle)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 50,
                ),
                child: Column(
                  children: [
                    TextFormField(
                      onTap: () {
                        final slider = fabKey.currentState;
                        if (slider!.isOpen) {
                          slider.close();
                        }
                      },
                      controller: searchController,
                      style: Theme.of(context).textTheme.headline6,
                      cursorColor: kTextColor,
                      cursorHeight: 20,
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: Theme.of(context).textTheme.headline6,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        contentPadding:
                            const EdgeInsets.fromLTRB(15, 15, 15, 15),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                          gapPadding: 10,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: kTextMediumColor.withOpacity(.4),
                          ),
                          gapPadding: 10,
                        ),
                        filled: true,
                        fillColor: Theme.of(context).backgroundColor,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              searchToggle = false;
                              searchController.text = "";
                              _markers = {};
                            });
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ),
                      onChanged: (val) {
                        if (_debounce?.isActive ?? false) {
                          _debounce?.cancel();
                        }
                        _debounce =
                            Timer(const Duration(milliseconds: 700), () async {
                          if (val.length > 2) {
                            if (searchFlag.searchToggle) {
                              searchFlag.toggleSearch();
                              _markers = {};
                            }
                            dynamic results =
                                await MapServices().searchPlaces(val);
                            searchFlag.toggleSearch();
                            if (results == 2) {
                              customSnackBar(
                                  context: context,
                                  message: "Check your internet connection",
                                  onPressed: () {});
                            } else if (results == 4) {
                              customSnackBar(
                                  context: context,
                                  message: "Coonection Timeout",
                                  onPressed: () async {
                                    results =
                                        await MapServices().searchPlaces(val);
                                  });
                            } else if (results == 5) {
                              customSnackBar(
                                  context: context,
                                  message: "Server Error",
                                  onPressed: () {});
                            } else {
                              _setResults(results);
                            }
                          } else {
                            _setResults([]);
                          }
                        });
                      },
                    ),
                  ],
                ),
              )
            else
              Container(),
            searchFlag.searchToggle
                ? searchResults.isNotEmpty
                    ? Positioned(
                        top: 115,
                        left: 20,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                              children:
                                  List.generate(searchResults.length, (index) {
                            return searchResultsList(
                                searchResults[index], searchFlag);
                          })),
                        ))
                    : Positioned(
                        top: 115,
                        left: 20,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              "No relevant results found",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        ),
                      )
                : Container(),
          ],
        ),
      ),
      floatingActionButton: Builder(builder: (context) {
        return FabCircularMenu(
          alignment: Alignment.bottomLeft,
          fabColor: Colors.blue.shade50,
          fabOpenColor: Colors.red.shade100,
          key: fabKey,
          ringDiameter: 250.0,
          ringWidth: 60.0,
          fabSize: 60.0,
          ringColor: Colors.blue.shade50,
          children: [
            RawMaterialButton(
              onPressed: () {
                setState(() {
                  searchToggle = true;
                  radiusSlider = false;
                  pressedNear = false;
                  cardTapped = false;
                  getDirection = false;
                  _markers = {};
                });
              },
              child: const Icon(
                Icons.search,
                size: 30,
                color: kTextColor,
              ),
            ),
            RawMaterialButton(
              onPressed: () async {
                fabKey.currentState!.close();
                await _startService();
              },
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: const Icon(
                Icons.location_searching_outlined,
                color: kTextColor,
                size: 30,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget searchResultsList(placeItem, searchFlag) {
    return InkWell(
      onTap: () async {
        searchFlag.toggleSearch();
        setState(() {
          searchToggle = false;
          searchController.text = "";
        });

        final result = await MapServices().searchPlace(placeItem['id']);
        final long = result['center'][0];
        final lat = result['center'][1];

        await goToLocation(coords: LatLng(lat, long));
        _setMarker(LatLng(lat, long));
        // store the information
        setState(() {
          selectedLocation = {
            "lat": lat,
            "long": long,
            "name": placeItem["place_name"].split(",")[0]
          };
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 4.0,
            ),
            Icon(Icons.location_on,
                size: 25.0, color: Theme.of(context).primaryColor),
            const SizedBox(
              width: 5.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ' ${placeItem["place_name"].split(",")[0]}\n',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontSize: 17,
                      ),
                ),
                Text(
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.clip,
                  '${placeItem["place_name"].split(",")[1]} ${placeItem["place_name"].split(",")[2]}',
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        height: 0.1,
                      ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
