import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  static const CameraPosition GooglePlexnitialposition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final Completer<GoogleMapController> googlemapCompletercontroller =
      Completer<GoogleMapController>();
  GoogleMapController? _controllergooglemap;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: GooglePlexnitialposition,
            onMapCreated: (GoogleMapController mapcontroller) {
              _controllergooglemap = mapcontroller;
              googlemapCompletercontroller.complete(_controllergooglemap);
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    await Permission.location.request();
  }
}
