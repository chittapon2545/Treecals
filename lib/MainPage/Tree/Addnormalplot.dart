import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:treecals/MainPage/Tree/Addtreeinplot.dart';
import 'package:treecals/MainPage/Tree/Mappolygon.dart';

class Addnormalplotpage extends StatefulWidget {
  final String ID;
  const Addnormalplotpage({super.key, required this.ID});

  @override
  State<Addnormalplotpage> createState() => _AddnormalplotpageState();
}

class _AddnormalplotpageState extends State<Addnormalplotpage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final areacontroller = TextEditingController();
  final treeDB = FirebaseDatabase.instance.ref();
  List<Map<String, String>> groups = [];
  String? selectedGroupId;
  List<LatLng> polygonPoints = [];

  Future<void> SelectLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MapSample(userId: widget.ID)),
    );
    if (result != null && result is List<LatLng>) {
      setState(() {
        polygonPoints = result;
      });
    }
  }

  Future<String?> _saveToFirebase() async {
    if (polygonPoints.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('กรุณาเลือกตำแหน่งแปลงก่อน')));
      return null;
    }
    final plotRef = FirebaseDatabase.instance.ref("Normalplot");
    final snapshot = await plotRef.get();

    int nextId = 1;
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      nextId = data.length + 1;
    }
    final plotId = "PlotID$nextId";

    final plotData = {
      "UserID": widget.ID,
      'Name': nameController.text,
      "group": selectedGroupId,
      'Area': double.parse(areacontroller.text),
      "polygon": polygonPoints
          .map((p) => {"latitude": p.latitude, "longitude": p.longitude})
          .toList(),
    };

    await plotRef.child(plotId).set(plotData);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('บันทึกแปลงเรียบร้อยแล้ว')));

    return plotId;
  }

  Future<void> _loadGroups() async {
    final groupRef = treeDB.child('groups');
    final snapshot = await groupRef.get();
    if (snapshot.exists) {
      print('Groups data: ${snapshot.value}');
      final data = snapshot.value as Map;
      setState(() {
        groups = data.entries
            .map<Map<String, String>>(
              (e) => {'id': e.key, 'name': e.value['name'] ?? ''},
            )
            .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เพิ่มแปลงปกติ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'ชื่อแปลง'),
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกชื่อแปลง' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: areacontroller,
                decoration: InputDecoration(labelText: 'ขนาดแปลง (ไร่)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกขนาดแปลง' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField(
                value: selectedGroupId,
                decoration: InputDecoration(labelText: 'ชนิด (Group)'),
                items: groups
                    .map(
                      (group) => DropdownMenuItem<String>(
                        value: group['id'],
                        child: Text(group['name'] ?? ''),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGroupId = value;
                  });
                },
                validator: (value) => value == null ? 'กรุณาเลือกชนิด' : null,
              ),
              SizedBox(height: 16),
              Text(
                'ตำแหน่งที่ตั้ง (Location)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text(
                  polygonPoints.isEmpty
                      ? 'เลือกตำแหน่งบนแผนที่'
                      : 'จำนวนจุดในแปลง: ${polygonPoints.length} จุด',
                ),
                trailing: Icon(Icons.map),
                onTap: SelectLocation,
              ),
              ElevatedButton(
                onPressed: () async {
                  final plotId = await _saveToFirebase();
                  if (plotId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Addtreeinplot(
                          plotId: plotId,
                          userId: widget.ID,
                          group: selectedGroupId!,
                        ),
                      ),
                    );
                  }
                },
                child: Text('บันทึก'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
