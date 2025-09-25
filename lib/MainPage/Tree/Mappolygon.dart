import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapSample extends StatefulWidget {
  String userId;

  MapSample({super.key, this.userId = ''});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _setCurrentLocation();
    _requestLocationPermission();
    _loadUserPolygons(widget.userId);
  }

  final Completer<GoogleMapController> googlemapCompletercontroller =
      Completer<GoogleMapController>();
  GoogleMapController? _controllergooglemap;

  List<LatLng> _polygonLatLngs = [];
  bool _isPolygonClosed = false;

  Set<Polygon> get _polygons {
    if (_polygonLatLngs.length < 3) return {};
    return {
      Polygon(
        polygonId: const PolygonId('plot'),
        points: _polygonLatLngs,
        strokeColor: Colors.green,
        fillColor: Colors.green.withOpacity(0.2),
        strokeWidth: 2,
      ),
    };
  }

  //เช็คว่าจุดใกล้กับมาร์กเกอร์เก่าหรือไม่
  bool _isNearOldMarker(LatLng point, {double threshold = 0.00005}) {
    for (var marker in _oldMarkers) {
      final distance = _calculateDistance(point, marker.position);
      if (distance < threshold) return true;
    }
    return false;
  }

  //เช็คว่าจุดอยู่ในโพลิกอนเก่าหรือไม่
  bool _isInsideOldPolygon(LatLng point) {
    for (var polygon in _oldPolygons) {
      if (_pointInPolygon(point, polygon.points)) {
        return true;
      }
    }
    return false;
  }

  //เช็คว่าโพลิกอนใหม่ซ้อนทับกับโพลิกอนเก่าหรือไม่
  bool isPolygonOverlapping(List<LatLng> newPolygon, List<LatLng> oldPolygon) {
    for (LatLng p in newPolygon) {
      if (_pointInPolygon(p, oldPolygon)) {
        return true; // ซ้อนทับ
      }
    }
    return false; // ไม่ซ้อน
  }

  // ตรวจเส้นขอบ polygon 2 อันว่ามีการตัดกันไหม
  bool _doPolygonsIntersect(List<LatLng> poly1, List<LatLng> poly2) {
    for (int i = 0; i < poly1.length; i++) {
      LatLng a1 = poly1[i];
      LatLng a2 = poly1[(i + 1) % poly1.length];

      for (int j = 0; j < poly2.length; j++) {
        LatLng b1 = poly2[j];
        LatLng b2 = poly2[(j + 1) % poly2.length];

        if (_linesIntersect(a1, a2, b1, b2)) {
          return true;
        }
      }
    }
    return false;
  }

  bool _linesIntersect(LatLng p1, LatLng p2, LatLng q1, LatLng q2) {
    double o1 = _orientation(p1, p2, q1);
    double o2 = _orientation(p1, p2, q2);
    double o3 = _orientation(q1, q2, p1);
    double o4 = _orientation(q1, q2, p2);

    const double eps = 1e-10;

    if ((o1 * o2 < -eps) && (o3 * o4 < -eps)) return true;

    // collinear case
    if (_isOnSegment(p1, q1, p2)) return true;
    if (_isOnSegment(p1, q2, p2)) return true;
    if (_isOnSegment(q1, p1, q2)) return true;
    if (_isOnSegment(q1, p2, q2)) return true;

    return false;
  }

  bool _isOnSegment(LatLng a, LatLng b, LatLng c) {
    return b.latitude <= (a.latitude > c.latitude ? a.latitude : c.latitude) &&
        b.latitude >= (a.latitude < c.latitude ? a.latitude : c.latitude) &&
        b.longitude <=
            (a.longitude > c.longitude ? a.longitude : c.longitude) &&
        b.longitude >= (a.longitude < c.longitude ? a.longitude : c.longitude);
  }

  double _orientation(LatLng a, LatLng b, LatLng c) {
    double val =
        (b.longitude - a.longitude) * (c.latitude - a.latitude) -
        (b.latitude - a.latitude) * (c.longitude - a.longitude);

    const double eps = 1e-6;
    if (val.abs() < eps) return 0; // collinear
    return val > 0 ? 1 : -1;
  }

  bool polygonsOverlap(List<LatLng> newPoly, List<List<LatLng>> oldPolys) {
    for (var oldPoly in oldPolys) {
      // 1) เช็คว่ามีจุดใดของ newPoly อยู่ใน oldPoly
      for (var p in newPoly) {
        if (_pointInPolygon(p, oldPoly)) return true;
      }

      // 2) เช็คว่ามีจุดใดของ oldPoly อยู่ใน newPoly
      for (var p in oldPoly) {
        if (_pointInPolygon(p, newPoly)) return true;
      }

      // 3) เช็คเส้นขอบตัดกัน
      if (_doPolygonsIntersect(newPoly, oldPoly)) return true;
    }
    return false;
  }

  /// Ray casting algorithm: ตรวจว่าจุดอยู่ใน Polygon หรือไม่
  bool _pointInPolygon(LatLng point, List<LatLng> polygon) {
    int intersectCount = 0;
    for (int j = 0; j < polygon.length; j++) {
      int i = j == 0 ? polygon.length - 1 : j - 1;
      LatLng a = polygon[i];
      LatLng b = polygon[j];

      if (((a.latitude > point.latitude) != (b.latitude > point.latitude)) &&
          (point.longitude <
              (b.longitude - a.longitude) *
                      (point.latitude - a.latitude) /
                      (b.latitude - a.latitude) +
                  a.longitude)) {
        intersectCount++;
      }
    }
    return (intersectCount % 2) == 1;
  }

  void _addPoint(LatLng point) {
    if (_isPolygonClosed) return;
    if (_isNearOldMarker(point) || _isInsideOldPolygon(point)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("ไม่สามารถวาง Marker ในพื้นที่เก่าได้")),
      );
      return;
    }

    setState(() {
      _polygonLatLngs.add(point);
    });
  }

  double _calculateDistance(LatLng a, LatLng b) {
    return ((a.latitude - b.latitude).abs() +
        (a.longitude - b.longitude).abs());
  }

  void _resetPolygon() {
    setState(() {
      _polygonLatLngs.clear();
      _isPolygonClosed = false;
    });
  }

  void _setCurrentLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } else if (status.isDenied) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("โปรดอนุญาตการเข้าถึงตำแหน่ง")));
      Navigator.pop(context);
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      Navigator.pop(context);
    }
  }

  Set<Polygon> _oldPolygons = {};
  Set<Marker> _oldMarkers = {};

  Future<void> _loadUserPolygons(String userId) async {
    final ref = FirebaseDatabase.instance.ref().child('plotfast');
    final ref2 = FirebaseDatabase.instance.ref().child('Normalplot');
    final snapshot = await ref.get();
    final snapshot2 = await ref2.get();
    Set<Polygon> oldPolys = {};
    Set<Marker> oldMarkers = {};
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      data.forEach((key, value) {
        if (value is Map &&
            value['UserID'] == userId &&
            value['polygon'] != null) {
          final List polygonList = value['polygon'];
          List<LatLng> points = [];

          for (var i = 0; i < polygonList.length; i++) {
            var p = polygonList[i];
            if (p['latitude'] != null && p['longitude'] != null) {
              LatLng point = LatLng(
                double.parse(p['latitude'].toString()),
                double.parse(p['longitude'].toString()),
              );
              points.add(point);

              // สร้าง Marker สำหรับแต่ละจุด
              oldMarkers.add(
                Marker(
                  markerId: MarkerId("plotfast-$key-$i"),
                  position: point,
                  infoWindow: InfoWindow(
                    title: value['name']?.toString() ?? '',
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed,
                  ),
                ),
              );
            }
          }

          if (points.length >= 3) {
            oldPolys.add(
              Polygon(
                polygonId: PolygonId("plotfast-$key"),
                points: points,
                strokeColor: Colors.red,
                fillColor: Colors.red.withOpacity(0.2),
                strokeWidth: 2,
              ),
            );
          }
        }
      });
    }

    if (snapshot2.exists) {
      final data2 = snapshot2.value as Map;

      data2.forEach((key, value) {
        if (value is Map &&
            value['UserID'] == userId &&
            value['polygon'] != null) {
          final List polygonList = value['polygon'];
          List<LatLng> points = [];

          for (var i = 0; i < polygonList.length; i++) {
            var p = polygonList[i];
            if (p['latitude'] != null && p['longitude'] != null) {
              LatLng point = LatLng(
                double.parse(p['latitude'].toString()),
                double.parse(p['longitude'].toString()),
              );
              points.add(point);

              // สร้าง Marker สำหรับแต่ละจุด
              oldMarkers.add(
                Marker(
                  markerId: MarkerId("Normalplot-$key-$i"),
                  position: point,
                  infoWindow: InfoWindow(
                    title: value['name']?.toString() ?? '',
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed,
                  ),
                ),
              );
            }
          }

          if (points.length >= 3) {
            oldPolys.add(
              Polygon(
                polygonId: PolygonId("Normalplot-$key"),
                points: points,
                strokeColor: Colors.red,
                fillColor: Colors.red.withOpacity(0.2),
                strokeWidth: 2,
              ),
            );
          }
        }
      });
    }
    setState(() {
      _oldPolygons = oldPolys;
      _oldMarkers = oldMarkers; // อัปเดต Marker เก่า
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _currentLocation == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  mapType: MapType.satellite,
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation!,
                    zoom: 16,
                  ),
                  onMapCreated: (GoogleMapController mapcontroller) {
                    _controllergooglemap = mapcontroller;
                    googlemapCompletercontroller.complete(_controllergooglemap);
                  },
                  polygons: {..._oldPolygons, ..._polygons},
                  onTap: _addPoint,
                  markers: {
                    ..._polygonLatLngs.map(
                      (e) => Marker(
                        markerId: MarkerId(e.toString()),
                        position: e,
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue,
                        ),
                      ),
                    ),
                    ..._oldMarkers,
                  },
                ),
          Positioned(
            bottom: 40,
            left: 40,
            child: ElevatedButton(
              onPressed: () {
                if (_polygonLatLngs.length < 3) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("ต้องมีอย่างน้อย 3 จุดเพื่อสร้าง Polygon"),
                    ),
                  );
                  return;
                }

                setState(() {
                  _isPolygonClosed = true;
                });

                // ใช้ฟังก์ชันใหม่
                if (polygonsOverlap(
                  _polygonLatLngs,
                  _oldPolygons.map((e) => e.points).toList(),
                )) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Polygon ใหม่ซ้อนทับกับ Polygon เก่า ไม่สามารถบันทึกได้",
                      ),
                    ),
                  );
                  _resetPolygon();
                  return;
                }

                Navigator.pop(context, _polygonLatLngs); // ส่งพิกัดกลับ
              },
              child: const Text('บันทึกขอบเขตแปลง'),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 40,
            child: ElevatedButton(
              onPressed: _resetPolygon,
              child: const Text('รีเซ็ต Polygon'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _requestLocationPermission() async {
    await Permission.location.request();
  }
}
