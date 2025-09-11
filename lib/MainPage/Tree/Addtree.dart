import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:treecals/MainPage/Tree/Mappick.dart';
import 'package:treecals/Services/Calculator.dart';

class AddTreePage extends StatefulWidget {
  final String ID; // ต้องเป็น String
  const AddTreePage({super.key, required this.ID});

  @override
  State<AddTreePage> createState() => _AddTreePageState();
}

class _AddTreePageState extends State<AddTreePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _circumferenceController = TextEditingController();
  final _heightController = TextEditingController();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  List<Map<String, String>> _groups = [];
  String? _selectedGroupId;
  LatLng? _selectedLatLng;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เพิ่มต้นไม้เดี่ยว')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'ชื่อ'),
                validator: (value) => value!.isEmpty ? 'กรุณากรอกชื่อ' : null,
              ),
              TextFormField(
                controller: _circumferenceController,
                decoration: InputDecoration(labelText: 'เส้นรอบวง'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกเส้นรอบวง' : null,
              ),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'ความสูง'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกความสูง' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedGroupId,
                decoration: InputDecoration(labelText: 'ชนิด (Group)'),
                items: _groups
                    .map(
                      (group) => DropdownMenuItem<String>(
                        value: group['id'],
                        child: Text(group['name'] ?? ''),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGroupId = value;
                  });
                },
                validator: (value) => value == null ? 'กรุณาเลือกชนิด' : null,
              ),
              SizedBox(height: 20),
              Text(
                'ตำแหน่งที่ตั้ง (Location)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text(
                  _selectedLatLng == null
                      ? 'เลือกตำแหน่งบนแผนที่'
                      : 'Lat: ${_selectedLatLng!.latitude}, Lng: ${_selectedLatLng!.longitude}',
                ),
                trailing: Icon(Icons.map),
                onTap: _pickLocation,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _addTree, child: Text('บันทึก')),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addTree() async {
    try {
      if (_formKey.currentState!.validate()) {
        DatabaseReference treesRef = _dbRef.child('individualtrees');

        // 2. อ่าน Itree ล่าสุด
        DataSnapshot snapshot = await treesRef.get();
        int newTreeNum = 1;
        if (snapshot.exists) {
          final keys = (snapshot.value as Map).keys
              .where((k) => k.toString().startsWith('Itree'))
              .map((k) => int.tryParse(k.toString().replaceFirst('Itree', '')))
              .where((n) => n != null)
              .toList();
          if (keys.isNotEmpty) {
            keys.sort();
            newTreeNum = keys.last! + 1;
          }
        }

        final newTreeKey = "Itree$newTreeNum";
        final double circumference =
            double.tryParse(_circumferenceController.text) ?? 0;
        final double height = double.tryParse(_heightController.text) ?? 0;

        final carbonResult = BiomassCalculator.calculate(
          _selectedGroupId ?? '',
          circumference,
          height,
        );

        final carbon = carbonResult?.carbon ?? 0;
        final credits = carbon * 0.85; // สมมุติว่า 1 ตันคาร์บอน = 100 เครดิต
        await treesRef.child(newTreeKey).set({
          "Circumference": circumference,
          "Group_ID": _selectedGroupId,
          "Height": height,
          "Latitude": _selectedLatLng?.latitude ?? 0,
          "Longitude": _selectedLatLng?.longitude ?? 0,
          "UserID": widget.ID,
          "name": _nameController.text,
          "CS": carbon,
          "Credit": credits, // CS = Carbon Sequestration
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('เพิ่มข้อมูลต้นไม้สำเร็จ')));
        Navigator.pop(context);
        _formKey.currentState!.reset();
      }
    } catch (e) {
      print('เกิดข้อผิดพลาด: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
    }
  }

  Future<void> _loadGroups() async {
    final groupRef = _dbRef.child('groups');
    final snapshot = await groupRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      setState(() {
        _groups = data.entries
            .map<Map<String, String>>(
              (e) => {'id': e.key, 'name': e.value['name'] ?? ''},
            )
            .toList();
      });
    }
  }

  Future<void> _pickLocation() async {
    LatLng? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MapPickerPage(initialPosition: _selectedLatLng, userId: widget.ID),
      ),
    );
    if (result != null) {
      setState(() {
        _selectedLatLng = result;
      });
    }
  }
}
