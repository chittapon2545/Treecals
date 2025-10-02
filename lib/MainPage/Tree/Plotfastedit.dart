import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:treecals/MainPage/Tree/Mappolygon.dart';
import 'package:turf/helpers.dart';

class Plotfastedit extends StatefulWidget {
  final String userID;
  final String plotID;
  final Map<String, dynamic> plotData;
  const Plotfastedit({
    super.key,
    required this.userID,
    required this.plotID,
    required this.plotData,
  });

  @override
  State<Plotfastedit> createState() => _PlotfasteditState();
}

class _PlotfasteditState extends State<Plotfastedit> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController areaController;
  late TextEditingController treeNumController;
  late TextEditingController TimeController;
  final db = FirebaseDatabase.instance.ref();
  List<LatLng> polygonPoints = [];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.plotData['name'] ?? '');
    areaController = TextEditingController(
      text: widget.plotData['area'].toString() ?? '',
    );
    treeNumController = TextEditingController(
      text: widget.plotData['treenum'].toString() ?? '',
    );
    TimeController = TextEditingController(
      text: widget.plotData['time'].toString() ?? '',
    );

    if (widget.plotData['polygon'] != null) {
      final polygonList = widget.plotData['polygon'] as List;
      polygonPoints = polygonList
          .map((point) {
            final lat = (point['lat'] as num?)?.toDouble();
            final lng = (point['lng'] as num?)?.toDouble();
            if (lat != null && lng != null) {
              return LatLng(lat, lng);
            }
            return null; // ถ้าเจอ null จะข้าม
          })
          .where((e) => e != null)
          .cast<LatLng>()
          .toList();
    }
  }

  Future<void> pickPolygon() async {
    final selectedPoints = await Navigator.push<List<LatLng>>(
      context,
      MaterialPageRoute(builder: (context) => MapSample(userId: widget.userID)),
    );

    if (selectedPoints != null) {
      setState(() {
        polygonPoints = selectedPoints;
      });
    }
  }

  Future<void> updateplot() async {
    final plotfastdb = db.child('plotfast/${widget.plotID}');
    final treenum = int.tryParse(treeNumController.text) ?? 0;
    final area = double.tryParse(areaController.text) ?? 0.0;
    final time = double.tryParse(TimeController.text) ?? 0.0;
    final CS = treenum * time * 9.5 * 0.001;
    final Credit = CS * 3.67;

    await plotfastdb.update({
      'name': nameController.text,
      'area': area,
      'treenum': treenum,
      'time': time,
      'Credit': Credit,
      'CS': CS,
      'polygon': polygonPoints
          .map(
            (point) => {
              'latitude': point.latitude,
              'longitude': point.longitude,
            },
          )
          .toList(),
    });
    Navigator.pop(context, true);
  }

  Future<void> deletePlot() async {
    final plotfastdb = db.child('plotfast/${widget.plotID}');
    await plotfastdb.remove();
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("แก้ไขข้อมูลแปลงเร็ว")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'ชื่อแปลง'),
                validator: (value) =>
                    value == null || value.isEmpty ? "กรุณากรอกชื่อแปลง" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: areaController,
                decoration: InputDecoration(labelText: 'ขนาดแปลง (ไร่)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? "กรุณากรอกขนาดแปลง" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: treeNumController,
                decoration: InputDecoration(labelText: "จำนวนต้นไม้"),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty
                    ? "กรุณากรอกจำนวนต้นไม้"
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: TimeController,
                decoration: InputDecoration(labelText: "เวลา (ปี)"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? "กรุณากำหนดเวลา" : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text('ตำแหน่งที่ตั้ง (Location)'),
                trailing: Icon(Icons.map),
                onTap: pickPolygon,
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.save),
                    onPressed: updateplot,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    label: const Text(
                      'บันทึก',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: Icon(Icons.delete),
                    onPressed: deletePlot,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    label: const Text(
                      'ลบแปลง',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
