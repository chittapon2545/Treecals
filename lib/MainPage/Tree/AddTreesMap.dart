import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddtreesMap extends StatefulWidget {
  final String ID;
  final List<LatLng> markersPoints;
  const AddtreesMap({super.key, required this.ID, required this.markersPoints});

  @override
  State<AddtreesMap> createState() => _AddtreesMapState();
}

class _AddtreesMapState extends State<AddtreesMap> {
  late GoogleMapController mapController;
  String _ID = '';

  final Set<Marker> _markers = {};
  final List<LatLng> _markersPoints = [];
  int _MakerIdCounter = 1;

  final LatLng _center = const LatLng(13.7563, 100.5018); // กรุงเทพ

  @override
  void initState() {
    super.initState();
    _ID = widget.ID;
    _markersPoints.addAll(widget.markersPoints);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _handleTap(LatLng tappedPoint) {
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
        widget.markersPoints.clear();
        widget.markersPoints.add(tappedPoint);
        _markersPoints.clear();
        _markersPoints.add(tappedPoint);
        print(
          'Lat: ${widget.markersPoints.last.latitude}, Lng: ${widget.markersPoints.last.longitude}',
        );
      });
    } else {
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
            onPressed: () {
              setState(() {
                _markersPoints.clear();
                _markersPoints.add(widget.markersPoints.last);
              });
              Navigator.pop(context, _markersPoints);
            },
            icon: Icon(Icons.check),
            tooltip: 'ยืนยันตำแหน่ง',
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _markersPoints.last,
              zoom: 20,
            ),
            mapType: MapType.satellite,
            markers: _markersPoints
                .map(
                  (point) => Marker(
                    markerId: MarkerId(point.toString()),
                    position: point,
                    infoWindow: InfoWindow(
                      title: 'ตำแหน่งที่เลือก',
                      snippet:
                          'Lat: ${point.latitude}, Lng: ${point.longitude}',
                    ),
                  ),
                )
                .toSet(),
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
                  widget.markersPoints.clear();
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
