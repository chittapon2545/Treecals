import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:treecals/MainPage/Tree/Mappolygon.dart';

class Addfastplotpage extends StatefulWidget {
  final String ID;
  const Addfastplotpage({super.key, required this.ID});

  @override
  State<Addfastplotpage> createState() => _AddfastplotpageState();
}

class _AddfastplotpageState extends State<Addfastplotpage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _areaController = TextEditingController();
  final _treeNumController = TextEditingController();
  final _timeController = TextEditingController();

  List<LatLng> _polygonPoints = [];

  @override
  void dispose() {
    _nameController.dispose();
    _areaController.dispose();
    _treeNumController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _pickPolygon() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MapSample(userId: widget.ID)),
    );
    if (result != null && result is List<LatLng>) {
      setState(() {
        _polygonPoints = result;
      });
    }
  }

  Future<void> _saveToFirebase() async {
    if (_polygonPoints.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('กรุณาเลือกตำแหน่งแปลงก่อน')));
      return;
    }

    final treenum = int.parse(_treeNumController.text);
    final time = double.parse(_timeController.text);
    final CS = treenum * time * 9.5 * 0.001;
    final Credit = CS * 3.67;

    final plotRef = FirebaseDatabase.instance.ref("plotfast");
    final snapshot = await plotRef.get();

    int nextId = 1;

    if (snapshot.exists) {
      // หา PlotFID ล่าสุด
      final keys = (snapshot.value as Map).keys.cast<String>().toList();
      final lastId = keys
          .where((k) => k.startsWith("PlotFID"))
          .map((k) => int.tryParse(k.replaceAll("PlotFID", "")) ?? 0)
          .fold(0, (a, b) => a > b ? a : b);
      nextId = lastId + 1;
    }

    final plotId = "PlotFID$nextId";

    final data = {
      "CS": CS,
      "Credit": Credit,
      "area": double.parse(_areaController.text),
      "name": _nameController.text,
      "time": time,
      "treenum": treenum,
      "UserID": widget.ID,
      "polygon": _polygonPoints
          .map((p) => {"latitude": p.latitude, "longitude": p.longitude})
          .toList(),
    };

    await plotRef.child(plotId).set(data);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('บันทึกข้อมูลสำเร็จ!')));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เพิ่มแปลงด่วน')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'ชื่อแปลง'),
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกชื่อแปลง' : null,
              ),
              TextFormField(
                controller: _areaController,
                decoration: InputDecoration(labelText: 'ขนาดแปลง (ไร่)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกขนาดแปลง' : null,
              ),
              TextFormField(
                controller: _treeNumController,
                decoration: InputDecoration(labelText: 'จำนวนต้นไม้ (ต้น)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกจำนวนต้นไม้' : null,
              ),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(
                  labelText: 'ระยะเวลาที่ใช้ในการคำนวน (ปี)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกระยะเวลา' : null,
              ),

              SizedBox(height: 16),
              Text(
                'ตำแหน่งที่ตั้ง (Location)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text(
                  _polygonPoints.isEmpty
                      ? 'เลือกตำแหน่งบนแผนที่'
                      : 'จำนวนจุดในแปลง: ${_polygonPoints.length} จุด',
                ),
                trailing: Icon(Icons.map),
                onTap: _pickPolygon,
              ),
              SizedBox(height: 10),
              ElevatedButton(onPressed: _saveToFirebase, child: Text('บันทึก')),
            ],
          ),
        ),
      ),
    );
  }
}
