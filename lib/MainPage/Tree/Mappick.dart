import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class MapPickerPage extends StatefulWidget {
  final LatLng? initialPosition;
  final String userId;
  const MapPickerPage({Key? key, this.initialPosition, required this.userId})
    : super(key: key);

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  LatLng? _pickedLocation;
  LatLng? _currentLocation;
  List<Marker> _userMarkers = [];
  @override
  void initState() {
    super.initState();
    _setCurrentLocation();
    _loadUserMarkers(widget.userId);
  }

  Future<void> _setCurrentLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    }
  }

  Future<void> _loadUserMarkers(String userId) async {
    final ref = FirebaseDatabase.instance.ref().child('individualtrees');
    final snapshot = await ref.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      List<Marker> markers = [];
      data.forEach((key, value) {
        if (value is Map &&
            value['UserID'] == userId &&
            value['Latitude'] != null &&
            value['Longitude'] != null) {
          markers.add(
            Marker(
              markerId: MarkerId(key),
              position: LatLng(
                double.tryParse(value['Latitude'].toString()) ?? 0,
                double.tryParse(value['Longitude'].toString()) ?? 0,
              ),
              infoWindow: InfoWindow(title: value['name']?.toString() ?? ''),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure,
              ),
            ),
          );
        }
      });
      setState(() {
        _userMarkers = markers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เลือกตำแหน่ง')),
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator()) // รอจนกว่าจะได้ตำแหน่ง
          : GoogleMap(
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target:
                    widget.initialPosition ??
                    _currentLocation!, // ใช้ตำแหน่งปัจจุบัน
                zoom: 14,
              ),
              onTap: (latLng) {
                setState(() {
                  _pickedLocation = latLng;
                });
              },
              markers: {
                ..._userMarkers,
                if (_pickedLocation != null)
                  Marker(
                    markerId: MarkerId('picked'),
                    position: _pickedLocation!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed,
                    ),
                  ),
              },
            ),
      floatingActionButton: _pickedLocation == null
          ? null
          : FloatingActionButton(
              child: Icon(Icons.check),
              onPressed: () {
                Navigator.pop(context, _pickedLocation);
              },
            ),
    );
  }
}
