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

  List<LatLng> _polygonLatLngs = [];
  bool _isPolygonClosed = false;

  Set<Polygon> get _polygons {
    if (_polygonLatLngs.length < 3) return {};
    return {
      Polygon(
        polygonId: PolygonId('plot'),
        points: _polygonLatLngs,
        strokeColor: Colors.green,
        fillColor: Colors.green.withOpacity(0.2),
        strokeWidth: 2,
      ),
    };
  }

  void _addPoint(LatLng point) {
    if (_isPolygonClosed) return;
    setState(() {
      _polygonLatLngs.add(point);
      // เช็คว่าจุดแรกกับจุดสุดท้ายใกล้กันหรือไม่ (เช่น < 10 เมตร)
      if (_polygonLatLngs.length > 2) {
        final first = _polygonLatLngs.first;
        final last = _polygonLatLngs.last;
        final distance = _calculateDistance(first, last);
        if (distance < 0.0001) {
          // ประมาณ 10 เมตร
          _polygonLatLngs[_polygonLatLngs.length - 1] = first; // ปิด Polygon
          _isPolygonClosed = true;
        }
      }
    });
  }

  double _calculateDistance(LatLng a, LatLng b) {
    // ระยะทางแบบง่าย (Euclidean)
    return ((a.latitude - b.latitude).abs() +
        (a.longitude - b.longitude).abs());
  }

  void _resetPolygon() {
    setState(() {
      _polygonLatLngs.clear();
      _isPolygonClosed = false;
    });
  }

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
            polygons: _polygons,
            onTap: _addPoint,
            markers: _polygonLatLngs
                .map(
                  (e) => Marker(markerId: MarkerId(e.toString()), position: e),
                )
                .toSet(),
          ),
          Positioned(
            bottom: 40,
            left: 40,
            child: ElevatedButton(
              onPressed: () {
                // ตัวอย่าง: แสดงตำแหน่ง Polygon ใน console
                print('Polygon Points:');
                for (var point in _polygonLatLngs) {
                  print('Lat: ${point.latitude}, Lng: ${point.longitude}');
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('บันทึกขอบเขตแปลงสำเร็จ!')),
                );
                _resetPolygon();
              },
              child: Text('บันทึกขอบเขตแปลง'),
            ),
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
