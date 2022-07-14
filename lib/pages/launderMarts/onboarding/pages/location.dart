import 'dart:async';

import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:msafi_mobi/providers/map.provider.dart';
import 'package:msafi_mobi/providers/user.provider.dart';
import 'package:msafi_mobi/services/map.services.dart';
import 'package:msafi_mobi/themes/main.dart';
import 'package:provider/provider.dart';

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
  bool searchToggle = false;
  bool radiusSlider = false;
  bool pressedNear = false;
  bool cardTapped = false;
  bool getDirection = false;
  // hold all search results
  List searchResults = [];

//  places url
  static const placesUrl =
      "https://maps.googleapis.com/maps/api/place/autocomplete/output?parameters";

  // inputcontroller
  TextEditingController searchController = TextEditingController();

  // throttle async calls
  Timer? _debounce;

  // markers set
  Set<Marker> _markers = Set<Marker>();

// initialize map coordinates
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-1.2998511640066677, 36.80207174296653),
    zoom: 17.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(0.28927317965072585, 35.29253462041064),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  // zooms the focus to the selected location
  Future<void> goToLocation({required LatLng coords}) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 192.8334901395799,
          target: coords,
          tilt: 59.440717697143555,
          zoom: 19.151926040649414,
        ),
      ),
    );
  }

  // handle taps on map
  _onMapTap(LatLng coords) {
    print(coords);
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
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                onTap: _onMapTap,
              ),
            ),
            searchToggle
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 50,
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            controller: searchController,
                            style: GoogleFonts.notoSans(
                              color: kTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                            cursorColor: kTextColor,
                            cursorHeight: 20,
                            decoration: InputDecoration(
                              hintText: "Search",
                              hintStyle: GoogleFonts.notoSans(
                                color: kTextMediumColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
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
                              fillColor: kTextMediumColor.withOpacity(.08),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    searchToggle = false;
                                    searchController.text = "";
                                  });
                                },
                                icon: Icon(Icons.close),
                              ),
                            ),
                            onChanged: (val) {
                              if (_debounce?.isActive ?? false)
                                _debounce?.cancel();
                              _debounce = Timer(
                                  const Duration(milliseconds: 700), () async {
                                if (val.length > 2) {
                                  if (searchFlag.searchToggle) {
                                    searchFlag.toggleSearch();
                                    _markers = {};
                                  }
                                  List results =
                                      await MapServices().searchPlaces(val);
                                  searchFlag.toggleSearch();
                                  _setResults(results);
                                } else {
                                  _setResults([]);
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
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
                goToLocation(coords: LatLng(0, 0));
                setState(() {
                  searchToggle = true;
                  radiusSlider = false;
                  pressedNear = false;
                  cardTapped = false;
                  getDirection = false;
                });
              },
              child: const Icon(
                Icons.search,
                size: 30,
                color: kTextColor,
              ),
            ),
            RawMaterialButton(
              onPressed: () {},
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: const Icon(
                Icons.looks_two,
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
        final lat = placeItem['center'][0];
        final long = placeItem['center'][1];

        searchFlag.toggleSearch();
        setState(() {
          searchToggle = false;
          searchController.text = "";
        });
        print('$lat, $long');
        // await goToLocation(coords: LatLng(lat, long));
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
