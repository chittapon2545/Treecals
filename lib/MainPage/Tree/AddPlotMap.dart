import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddplotMap extends StatefulWidget {
  const AddplotMap({super.key});

  @override
  State<AddplotMap> createState() => _AddplotMapState();
}

class _AddplotMapState extends State<AddplotMap> {
  late GoogleMapController mapController;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final List<LatLng> _markersPoints = [];
  int _MakerIdCounter = 1;
  bool check = false;

  final LatLng _center = const LatLng(13.7563, 100.5018); // กรุงเทพ

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _drawPolyline() {
    if (_markers.length < 2) return; // ต้องมีอย่างน้อย 2 จุด

    final List<LatLng> points = _markers.map((m) => m.position).toList();

    points.add(points.first);

    setState(() {
      check = true;
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: PolylineId('polyline'),
          points: points,
          color: Colors.blue,
          width: 4,
        ),
      );
    });
  }

  void _handleTap(LatLng tappedPoint) {
    if (!check) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แผนที่'),
        actions: [
          IconButton(
            onPressed: () {
              _drawPolyline();
            },
            icon: Icon(Icons.check),
            tooltip: 'ลากเส้นเชื่อมจุด',
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 10.0),
            markers: _markers,
            polylines: _polylines,
            onTap: _handleTap,
          ),
          Positioned(
            bottom: 10,
            right: MediaQuery.of(context).size.width * 0.25,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _markers.clear();
                  _polylines.clear();
                  _MakerIdCounter = 1;
                  _markersPoints.clear();
                  check = false;
                });
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'ล้างตำแหน่งทั้งหมด',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
