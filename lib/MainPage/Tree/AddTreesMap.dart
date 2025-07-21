import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddtreesMap extends StatefulWidget {
  const AddtreesMap({super.key});

  @override
  State<AddtreesMap> createState() => _AddtreesMapState();
}

class _AddtreesMapState extends State<AddtreesMap> {
  late GoogleMapController mapController;

  final Set<Marker> _markers = {};
  final List<LatLng> _markersPoints = [];
  int _MakerIdCounter = 1;

  final LatLng _center = const LatLng(13.7563, 100.5018); // กรุงเทพ

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _handleTap(LatLng tappedPoint) {
    _markers.clear();
    if (_markers.isEmpty) {
      setState(() {
        final markerId = MarkerId('marker_${_MakerIdCounter++}');
        _markers.add(
          Marker(
            markerId: markerId,
            position: tappedPoint,
            infoWindow: InfoWindow(
              title: 'ตำแหน่งที่เลือก',
              snippet:
                  'Lat: ${tappedPoint.latitude}, Lng: ${tappedPoint.longitude}',
            ),
          ),
        );
        _markersPoints.add(tappedPoint);
        print(
          'Lat: ${_markersPoints.last.latitude}, Lng: ${_markersPoints.last.longitude}',
        );
      });
    } else {
      // ถ้ามี Marker แล้ว หรือ วาดเส้นแล้ว ไม่เพิ่ม Marker ใหม่
      print('เพิ่ม Marker ไม่ได้ เพราะมี Marker อยู่แล้วหรือวาดเส้นแล้ว');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แผนที่'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.check),
            tooltip: 'ยืนยันตำแหน่ง',
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 10.0),
            markers: _markers,
            onTap: _handleTap,
          ),
          Positioned(
            bottom: 10,
            right: MediaQuery.of(context).size.width * 0.25,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _markers.clear();
                  _markersPoints.clear();
                  _MakerIdCounter = 1;
                });
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'ล้างตำแหน่ง',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
